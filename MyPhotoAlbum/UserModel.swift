//
//  UserModel.swift
//  MyPhotoAlbum
//
//  Created by Guillaume Bellut on 01/05/2017.
//  Copyright © 2017 Guillaume Bellut. All rights reserved.
//

import Foundation
import ObjectMapper

class UserModel: NSObject, Mappable, NSCoding {
	
	var id: Double = 0
	var name: String = ""
	var albums: [AlbumModel] = []
	
	// MARK: Mappable
	
	required init(map: Map) {
		
	}
	
	func mapping(map: Map) {
		id <- map["id"]
		name <- map["name"]
	}
	
	
	// MARK: NSCoding
	
	required init(coder aDecoder: NSCoder) {
		id = aDecoder.decodeDouble(forKey: "id")
		
		if let name = aDecoder.decodeObject(forKey: "name") as? String {
			self.name = name
		}
	}
	
	func encode(with aCoder: NSCoder) {
		aCoder.encode(id, forKey: "id")
		aCoder.encode(name, forKey: "name")
	}
	
}
