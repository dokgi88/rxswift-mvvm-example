//
//  MarvelSearchNavigator.swift
//  RxSwiftMVVM
//
//  Created by soom on 07/04/2019.
//  Copyright © 2019 cashwalk. All rights reserved.
//

import UIKit

final class MarvelSearchNavigator {
    
    private let navigationController: UINavigationController?
    
    init(_ navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    // MARK: - Internal Method
    
    func showDescription(model: MarvelHeroModel) {
        let controller = MarvelDescriptionVC()
        navigationController?.show(controller, sender: nil)
    }
    
}
