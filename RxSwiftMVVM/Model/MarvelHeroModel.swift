//
//  MarvelHeroModel.swift
//  RxSwiftMVVM
//
//  Created by soom on 21/12/2018.
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

struct MarvelHeroData: Decodable {
    let data: MarvelHeroResult
}

struct MarvelHeroResult: Decodable {
    let results: [HeroModel]
}

struct HeroModel: Decodable {
    let name: String
    let description: String
    let thumbnail: HeroThumbnail
}

struct HeroThumbnail: Decodable {
    let path: String
    let `extension`: String
}
