//
//  MarvelService.swift
//  RxSwiftMVVM
//
//  Created by soom on 21/12/2018.
//

import Alamofire
import CryptoSwift
import RxCocoa
import SwiftyJSON

class MarvelService {
    
    @discardableResult
    public func getCharacters(name: String, offset: Int, completion: @escaping (NSError?, [MarvelHeroModel]?) -> Void) -> URLSessionTask? {
        
        let url = "\(MARVEL_API)\(MARVEL_API_CHARACTERS)"
        var param = [String: Any]()
        let timeStamp = Int(Date().timeIntervalSince1970)
        param["ts"] = timeStamp
        param["apikey"] = MARVEL_PUBLIC_KEY
        param["hash"] = getHash(ts: timeStamp)
        if name.count > 0 {
            param["nameStartsWith"] = name
        }
        param["limit"] = 20
        param["offset"] = offset
        let headers = ["Content-Type":"application/json", "Accept":"application/json"]
        
        return Alamofire.request(url, method: HTTPMethod.get, parameters: param, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let error = json["error"]
                guard error.isEmpty else {return}
                guard let data = json["data"].dictionary else {return}
                guard let result = data["results"]?.array else {return}
                
                completion(nil, result.compactMap({MarvelHeroModel(json: $0)}))
            case .failure(let error):
                completion(error as NSError, nil)
            }
            }.task
    }
    
    private func getHash(ts: Int) -> String {
        let hash = "\(ts)\(MARVEL_PRIVATE_KEY)\(MARVEL_PUBLIC_KEY)"
        return hash.md5()
    }
}

