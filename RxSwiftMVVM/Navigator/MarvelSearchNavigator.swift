//
//  MarvelSearchNavigator.swift
//  RxSwiftMVVM
//
//  Created by soom on 07/04/2019.
//

import UIKit

final class MarvelSearchNavigator {
    
    private let navigationController: UINavigationController?
    
    init(_ navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    // MARK: - Internal Method
    
    func showDescription(model: MarvelHeroModel) {
        let controller = MarvelDescriptionVC(viewModel: .init(model: model))
        navigationController?.show(controller, sender: nil)
    }
    
}
