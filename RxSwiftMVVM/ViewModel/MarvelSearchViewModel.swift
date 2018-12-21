//
//  MarvelSearchViewModel.swift
//  RxSwiftMVVM
//
//  Created by cashwalk on 21/12/2018.
//  Copyright © 2018 cashwalk. All rights reserved.
//

import RxCocoa
import RxSwift

class MarvelSearchViewModel {
    
    let selectHero: AnyObserver<MarvelHeroModel>
    let showHero: Observable<MarvelHeroModel>
    var heros = BehaviorRelay<[MarvelHeroModel]>(value: [])
    var behaHero = BehaviorSubject<[MarvelHeroModel]>(value: [])
    var search: String = "" {
        didSet {
            MarvelService().getCharacters(name: search, offset: 20) { (error, result) in
                guard error == nil, let result = result, result.count > 0 else {
                    self.heros.accept([])
                    return
                }
                self.heros.accept(result)
            }
        }
    }
    
    init() {
        self.search = ""
        let tempSelectHero = PublishSubject<MarvelHeroModel>()
        selectHero =  tempSelectHero.asObserver()
        showHero = tempSelectHero.asObservable().map({$0})
    }
    
}
