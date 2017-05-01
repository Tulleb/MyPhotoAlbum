//
//  UserTableViewController.swift
//  MyPhotoAlbum
//
//  Created by Guillaume Bellut on 01/05/2017.
//  Copyright © 2017 Guillaume Bellut. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
	
	var users: [UserModel] = []

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	// MARK: UITableViewDataSource
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return users.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell") as? UserTableViewCell else {
			return UITableViewCell()
		}
		
		let user = users[indexPath.row]
		cell.nameLabel.text = user.name
		
		return cell
	}
	
	
	// MARK: UITableViewDelegate
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let user = users[indexPath.row]
		
		if let albums = user.albums {
			print("Loading album view for user \(user.name) from cache")
			self.navigationController?.pushViewController(AlbumTableViewController.instantiate(with: albums), animated: true)
		} else {
			NetworkManager.sharedInstance.loadAlbums(for: user) { (albums: [AlbumModel]?) in
				guard let albums = albums else {
					print("Couldn't load albums for user \(user.name)")
					return
				}
				
				print("Loading album view for user \(user.name) from remote")
				self.navigationController?.pushViewController(AlbumTableViewController.instantiate(with: albums), animated: true)
				
				self.users = (UIApplication.shared.delegate as! AppDelegate).save(albums: albums, from: user)
				self.tableView.reloadData()
			}
		}
	}
	
}
