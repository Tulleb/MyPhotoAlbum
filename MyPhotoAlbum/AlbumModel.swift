//
//  AlbumModel.swift
//  MyPhotoAlbum
//
//  Created by Guillaume Bellut on 01/05/2017.
//  Copyright © 2017 Guillaume Bellut. All rights reserved.
//

import Foundation
import ObjectMapper

class AlbumModel: NSObject, Mappable, NSCoding {
	
	var userId: Double = 0
	var id: Double = 0
	var title: String = ""
	var photos: [PhotoModel]? = nil
	
	// MARK: Mappable
	
	required init(map: Map) {
		
	}
	
	func mapping(map: Map) {
		userId <- map["userId"]
		id <- map["id"]
		title <- map["title"]
	}
	
	
	// MARK: NSCoding
	
	required init(coder aDecoder: NSCoder) {
		userId = aDecoder.decodeDouble(forKey: "userId")
		id = aDecoder.decodeDouble(forKey: "id")
		
		if let title = aDecoder.decodeObject(forKey: "title") as? String {
			self.title = title
		}
	}
	
	func encode(with aCoder: NSCoder) {
		aCoder.encode(userId, forKey: "userId")
		aCoder.encode(id, forKey: "id")
		aCoder.encode(title, forKey: "title")
	}
	
}
