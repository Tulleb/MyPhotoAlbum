//
//  PhotoModel.swift
//  MyPhotoAlbum
//
//  Created by Guillaume Bellut on 01/05/2017.
//  Copyright © 2017 Guillaume Bellut. All rights reserved.
//

import Foundation
import ObjectMapper

class PhotoModel: NSObject, Mappable, NSCoding {
	
	var id: Double = 0
	var thumbnailUrl: String = ""
	var thumbnail: UIImage? = nil
	
	// MARK: Mappable
	
	required init(map: Map) {
		
	}
	
	func mapping(map: Map) {
		id <- map["id"]
		thumbnailUrl <- map["thumbnailUrl"]
	}
	
	
	// MARK: NSCoding
	
	required init(coder aDecoder: NSCoder) {
		id = aDecoder.decodeDouble(forKey: "id")
		
		if let thumbnailUrl = aDecoder.decodeObject(forKey: "thumbnailUrl") as? String {
			self.thumbnailUrl = thumbnailUrl
		}
		
		if let thumbnailData = aDecoder.decodeObject(forKey: "thumbnailData") as? Data {
			self.thumbnail = UIImage(data: thumbnailData)!
		}
	}
	
	func encode(with aCoder: NSCoder) {
		aCoder.encode(id, forKey: "id")
		
		if let thumbnail = self.thumbnail {
			aCoder.encode(UIImagePNGRepresentation(thumbnail), forKey: "thumbnailData")
		}
	}
	
}
