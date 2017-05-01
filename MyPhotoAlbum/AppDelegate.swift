//
//  AppDelegate.swift
//  MyPhotoAlbum
//
//  Created by Guillaume Bellut on 01/05/2017.
//  Copyright © 2017 Guillaume Bellut. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var navigationController: UINavigationController = UINavigationController()
	
	var users: [UserModel] {
		get {
			if let encodedReturnValue = UserDefaults.standard.object(forKey: "users") as? Data {
				if let returnValue = NSKeyedUnarchiver.unarchiveObject(with: encodedReturnValue) as? [UserModel] {
					return returnValue
				}
			}
			
			return []
		}
		
		set {
			print("Encoding users...")
			
			let encodedObject = NSKeyedArchiver.archivedData(withRootObject: newValue)
			UserDefaults.standard.set(encodedObject, forKey: "users")
			UserDefaults.standard.synchronize()
			
			print("Users encoded")
		}
	}

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		navigationController = application.windows[0].rootViewController as! UINavigationController
		
		guard let userTableViewController = self.navigationController.topViewController as? UserTableViewController else {
			print("Error while looking for top view controller")
			return false
		}
		
		if users.count == 0 {
			loadUsers() { (succeed: Bool) in
				if succeed {
					print("Users loaded successfully")
				} else {
					print("Loading user request encountered an issue")
				}
				
				print("Loading user view from remote")
				userTableViewController.users = self.users
				userTableViewController.tableView.reloadData()
			}
		} else {
			print("Loading user view from cache")
			userTableViewController.users = self.users
			userTableViewController.tableView.reloadData()
		}
		
		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}
	
	func loadUsers(completionHandler: @escaping (Bool) -> ()) {
		NetworkManager.sharedInstance.loadUsers() { (users: [UserModel]?) in
			guard let users = users else {
				completionHandler(false)
				return
			}
			
			self.users = users
			completionHandler(true)
		}
	}
	
	func loadPhotos(for album: AlbumModel, completionHandler: @escaping (Bool) -> ()) {
		NetworkManager.sharedInstance.loadPhotos(for: album) { (photos: [PhotoModel]?) in
			guard let photos = photos else {
				completionHandler(false)
				return
			}
			
			album.photos = photos
			completionHandler(true)
		}
	}
	
	func save(albums: [AlbumModel], from user: UserModel) -> [UserModel] {
		let usersBuffer = users
		
		for userBuffer in usersBuffer {
			if userBuffer.id == user.id {
				userBuffer.albums = albums
				break
			}
		}
		
		users = usersBuffer
		
		return usersBuffer
	}
	
	func save(photos: [PhotoModel], from album: AlbumModel) -> [AlbumModel]? {
		var concernedUser: UserModel? = nil
		let usersBuffer = users
		
		for userBuffer in usersBuffer {
			if userBuffer.id == album.userId, let albumsBuffer = userBuffer.albums {
				for albumBuffer in albumsBuffer {
					if albumBuffer.userId == userBuffer.id && albumBuffer.id == album.id {
						albumBuffer.photos = photos
						concernedUser = userBuffer
						break
					}
				}
			}
		}
		
		users = usersBuffer
		
		return concernedUser?.albums
	}
	
}
