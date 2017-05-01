//
//  PhotoCollectionViewController.swift
//  MyPhotoAlbum
//
//  Created by Guillaume Bellut on 01/05/2017.
//  Copyright © 2017 Guillaume Bellut. All rights reserved.
//

import UIKit

class PhotoCollectionViewController: UICollectionViewController {
	
	var photos: [PhotoModel]!
	
	internal static func instantiate(with photos: [PhotoModel]) -> PhotoCollectionViewController {
		let photoCollectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoCollectionViewController") as! PhotoCollectionViewController
		photoCollectionViewController.photos = photos
		return photoCollectionViewController
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	// MARK: UICollectionViewDataSource
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return photos.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell else {
			return UICollectionViewCell()
		}
		
		let photo = photos[indexPath.row]
		cell.thumbnailImageView.image = photo.thumbnail
		
		return cell
	}
	
}

