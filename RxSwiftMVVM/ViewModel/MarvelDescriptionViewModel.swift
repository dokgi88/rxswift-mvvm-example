//
//  MarvelDescriptionViewModel.swift
//  RxSwiftMVVM
//
//  Created by cashwalk on 21/12/2018.
//  Copyright © 2018 cashwalk. All rights reserved.
//

import RxSwift

class MarvelDescriptionViewModel {
    
    var thumbnail: Observable<URL>
    var name: Observable<String>
    var description: Observable<NSAttributedString>
    var hero: MarvelHeroModel? {
        didSet {
            guard let hero = hero else {return}
            
            if let thumbnail = hero.thumbnail, let url = URL(string: thumbnail) {
                let thumbnailUrl = BehaviorSubject<URL>(value: url)
                self.thumbnail = thumbnailUrl.asObservable()
            }
            if let name = hero.name, let desc = hero.description {
                let description = desc.count > 0 ? desc:"Not Description"
                let attrDescription = convertDescription(name: name, desc: description)
                let tempDescription = BehaviorSubject<NSAttributedString>(value: attrDescription)
                let tempName = BehaviorSubject<String>(value: name)
                self.name = tempName.asObserver()
                self.description = tempDescription.asObservable()
            }
        }
    }
    
    init() {
        thumbnail = PublishSubject<URL>()
        name = PublishSubject<String>()
        description = PublishSubject<NSAttributedString>()
    }
    
    private func convertDescription(name: String, desc: String) -> NSAttributedString {
        let originText = "\(name)\n\n\(desc)"
        let range = originText.lowercased().range(of: name.lowercased())
        let attributeString = NSMutableAttributedString(string: originText,
                                                        attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold), NSAttributedString.Key.foregroundColor:UIColor.black])
        attributeString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 30, weight: .black), range: NSRange(location: (range?.lowerBound.encodedOffset)!, length: name.count))
        return attributeString
    }
    
}
