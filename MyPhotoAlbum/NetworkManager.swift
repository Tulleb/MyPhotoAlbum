//
//  NetworkManager.swift
//  MyPhotoAlbum
//
//  Created by Guillaume Bellut on 01/05/2017.
//  Copyright © 2017 Guillaume Bellut. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class NetworkManager: NSObject {
	
	static let sharedInstance = NetworkManager()
	
	private override init() {
		print("Shared Network Manager instance created")
	}
	
	func loadUsers(completionHandler: @escaping ([UserModel]?) -> ()) {
		let stringURL = "https://jsonplaceholder.typicode.com/users"
		
		print("Loading users: \(stringURL)...")
		
		Alamofire.request(stringURL).responseArray { (response: DataResponse<[UserModel]>) in
			guard let users = response.result.value else {
				print("Could not load users from URL")
				completionHandler(nil)
				return
			}
			
			print("Loaded \(users.count) users")
			completionHandler(users)
		}
	}
	
	func loadAlbums(for user: UserModel, completionHandler: @escaping ([AlbumModel]?) -> ()) {
		let stringURL = "https://jsonplaceholder.typicode.com/users/\(user.id)/albums"
		
		print("Loading albums from \(user.name): \(stringURL)...")
		
		Alamofire.request(stringURL).responseArray { (response: DataResponse<[AlbumModel]>) in
			guard let albums = response.result.value else {
				print("Could not load albums from URL")
				completionHandler(nil)
				return
			}
			
			print("Loaded \(albums.count) albums")
			completionHandler(albums)
		}
	}
	
	func loadPhotos(for album: AlbumModel, completionHandler: @escaping ([PhotoModel]?) -> ()) {
		let stringURL = "https://jsonplaceholder.typicode.com/albums/\(album.id)/photos"
		
		print("Loading photos from \(album.title): \(stringURL)...")
		
		Alamofire.request(stringURL).responseArray { (response: DataResponse<[PhotoModel]>) in
			guard let photos = response.result.value else {
				print("Could not load photos from URL")
				completionHandler(nil)
				return
			}
			
			print("Loaded \(photos.count) photos")
			print("Downloading thumbnails for each one of them...")
			
			var photoStillDownloading = photos.count
			
			for photo in photos {
				self.downloadImage(at: photo.thumbnailUrl) { (thumbnail: UIImage?) in
					if let thumbnail = thumbnail {
						photo.thumbnail = thumbnail
					}
					
					photoStillDownloading -= 1
					
					if photoStillDownloading == 0 {
						completionHandler(photos)
					}
				}
			}
		}
	}
	
	func downloadImage(at url: String, _ completionHandler: @escaping (UIImage?) -> ()) {
		print("Requesting \(url)...")
		
		Alamofire.request(url).responseData { response in
			guard let data = response.result.value else {
				print("Download failed without answer!")
				completionHandler(nil)
				
				return
			}
			
			do {
				let json = try JSONSerialization.jsonObject(with: data)
				
				if let dictionaryJson = json as? [String: Any] {
					if let error = dictionaryJson["error"] {
						print("Download failed with error: \(error)")
						completionHandler(nil)
						
						return
					}
				}
				
				print("Download failed with unknown error!")
				completionHandler(nil)
				
				return
			} catch {
				let image = UIImage(data: data)
				print("Download was a success!")
				completionHandler(image)
			}
		}
	}
	
}
