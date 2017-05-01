//
//  AlbumTableViewController.swift
//  MyPhotoAlbum
//
//  Created by Guillaume Bellut on 01/05/2017.
//  Copyright © 2017 Guillaume Bellut. All rights reserved.
//

import UIKit

class AlbumTableViewController: UITableViewController {
	
	var albums: [AlbumModel]!
	
	internal static func instantiate(with albums: [AlbumModel]) -> AlbumTableViewController {
		let albumTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AlbumTableViewController") as! AlbumTableViewController
		albumTableViewController.albums = albums
		return albumTableViewController
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	// MARK: UITableViewDataSource
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return albums.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumTableViewCell") as? AlbumTableViewCell else {
			return UITableViewCell()
		}
		
		let album = albums[indexPath.row]
		cell.titleLabel.text = album.title
		
		return cell
	}
	
	
	// MARK: UITableViewDelegate
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let album = albums[indexPath.row]
		
		if let photos = album.photos {
			print("Loading photo view for album \(album.title) from cache")
			self.navigationController?.pushViewController(PhotoCollectionViewController.instantiate(with: photos), animated: true)
		} else {NetworkManager.sharedInstance.loadPhotos(for: album) { (photos: [PhotoModel]?) in
			guard let photos = photos else {
				print("Couldn't load photos for album \(album.title)")
				return
			}
			
			print("Loading photo view for album \(album.title) from remote")
			self.navigationController?.pushViewController(PhotoCollectionViewController.instantiate(with: photos), animated: true)
			
			if let savedAlbums = (UIApplication.shared.delegate as! AppDelegate).save(photos: photos, from: album) {
				self.albums = savedAlbums
				self.tableView.reloadData()
			}
			}
		}
	}
	
}
