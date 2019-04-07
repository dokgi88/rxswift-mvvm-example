//
//  MarvelSearchTVCellViewModel.swift
//  RxSwiftMVVM
//
//  Created by soom on 07/04/2019.
//

import RxCocoa
import RxSwift

final class MarvelSearchTVCellViewModel {
    
    let model: MarvelHeroModel
    
    init(model: MarvelHeroModel) {
        self.model = model
    }
    
    struct Input {
        let trigger: Driver<Void>
    }
    struct Output {
        let name: Driver<String>
        let thumbnail: Driver<URL>
    }
    
    // MARK: - Internal Method
    
    func transform(input: Input) -> Output {
        let name: Driver<String> = input.trigger
            .flatMapLatest { [weak self] (_) in
                guard let self = self, let name = self.model.name else {return Driver.empty()}
                return Driver.just(name)
            }
        let thumbnail: Driver<URL> = input.trigger
            .flatMapLatest { [weak self] (_) in
                guard let self = self else {return Driver.empty()}
                guard let thumnail = self.model.thumbnail, let url = URL(string: thumnail) else {return Driver.empty()}
                return Driver.just(url)
            }
        
        return Output(name: name, thumbnail: thumbnail)
    }
    
}
