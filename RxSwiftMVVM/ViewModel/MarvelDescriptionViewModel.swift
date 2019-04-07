//
//  MarvelDescriptionViewModel.swift
//  RxSwiftMVVM
//
//  Created by soom on 21/12/2018.
//

import RxCocoa
import RxSwift

final class MarvelDescriptionViewModel {
    
    private let model: MarvelHeroModel
    
    init(model: MarvelHeroModel) {
        self.model = model
    }
    
    struct Input {
        let trigger: Driver<Void>
    }
    struct Output {
        let thumbnail: Driver<URL>
        let name: Driver<String>
        let description: Driver<NSAttributedString>
    }
    
    // MARK: - Internal Method
    
    func transform(input: Input) -> Output {
        let thumbnail: Driver<URL> = input.trigger
            .flatMapLatest { [weak self] (_) in
                guard let self = self else {return Driver.empty()}
                guard let thumbnail = self.model.thumbnail, let url = URL(string: thumbnail) else {return Driver.empty()}
                return Driver.just(url)
            }
        let name: Driver<String> = input.trigger
            .flatMapLatest { [weak self] (_) in
                guard let self = self, let name = self.model.name else {return Driver.empty()}
                return Driver.just(name)
            }
        let description: Driver<NSAttributedString> = input.trigger
            .flatMapLatest { [weak self] (_) in
                guard let self = self else {return Driver.empty()}
                return Driver.just(self.getDescription())
            }
        
        return Output(thumbnail: thumbnail, name: name, description: description)
    }
    
    // MARK: - Private Method
    
    private func getDescription() -> NSAttributedString {
        guard let name = model.name, let desc = model.description else {return NSAttributedString(string: "Not Description")}
        let description = desc.count > 0 ? desc:"Not Description"
        let originText = "\(name)\n\n\(description)"
        let range = originText.lowercased().range(of: name.lowercased())
        let attributeString = NSMutableAttributedString(string: originText,
                                                        attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold), NSAttributedString.Key.foregroundColor:UIColor.black])
        attributeString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 30, weight: .black), range: NSRange(location: (range?.lowerBound.encodedOffset)!, length: name.count))
        return attributeString
    }
    
}
