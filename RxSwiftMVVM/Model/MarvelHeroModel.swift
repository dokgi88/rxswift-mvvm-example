//
//  MarvelHeroModel.swift
//  RxSwiftMVVM
//
//  Created by cashwalk on 21/12/2018.
//  Copyright © 2018 cashwalk. All rights reserved.
//

import SwiftyJSON

class MarvelHeroModel {
    
    private(set) var name: String?
    private(set) var description: String?
    private(set) var thumbnail: String?
    
    init(json: JSON) {
        name = json["name"].string
        description = json["description"].string
        if let dicThumnail = json["thumbnail"].dictionary {
            guard let path = dicThumnail["path"]?.string else {return}
            guard let thumbnailEx = dicThumnail["extension"]?.string else {return}
            thumbnail = "\(path).\(thumbnailEx)"
        }
    }
}

