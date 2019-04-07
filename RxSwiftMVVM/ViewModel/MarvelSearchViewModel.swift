//
//  MarvelSearchViewModel.swift
//  RxSwiftMVVM
//
//  Created by soom on 21/12/2018.
//

import RxCocoa
import RxSwift

final class MarvelSearchViewModel {
    
    // MARK: - Properties
    
    private var disposeBag = DisposeBag()
    private var heros = PublishRelay<[MarvelHeroModel]>()
    private let navigator: MarvelSearchNavigator
    
    init(navigator: MarvelSearchNavigator) {
        self.navigator = navigator
    }
    
    struct Input {
        let searchText: Driver<String>
        let modelSelected: ControlEvent<MarvelHeroModel>
    }
    struct Output {
        let heros: Observable<[MarvelHeroModel]>
    }
    
    // MARK: - Internal methods
    
    func transform(input: Input) -> Output {
        input.searchText
            .drive(onNext: { [weak self] (searchText) in
                guard let self = self else {return}
                self.requestHero(searchText: searchText)
            })
            .disposed(by: disposeBag)
        input.modelSelected
            .bind { [weak self] (model) in
                guard let self = self else {return}
                self.navigator.showDescription(model: model)
            }
            .disposed(by: disposeBag)
        
        return Output(heros: heros.asObservable())
    }
    
    // MARK: - Private Method
    
    private func requestHero(searchText: String) {
        MarvelService().getCharacters(name: searchText, offset: 20) { [weak self] (error, result) in
            guard let self = self else {return}
            guard error == nil, let result = result, result.count > 0 else {return self.heros.accept([])}
            self.heros.accept(result)
        }
    }
    
}
