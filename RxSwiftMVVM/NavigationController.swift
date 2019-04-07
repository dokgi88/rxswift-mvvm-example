//
//  NavigationController.swift
//  RxSwiftMVVM
//
//  Created by soom on 07/04/2019.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let logoView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        logoView.image = UIImage(named: "Marvel_logo.jpg")
        logoView.contentMode = .scaleAspectFit
        
        navigationBar.tintColor = .white
        navigationBar.barTintColor = .black
        navigationBar.topItem?.titleView = logoView
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

}
