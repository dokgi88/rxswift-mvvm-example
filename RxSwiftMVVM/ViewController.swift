//
//  ViewController.swift
//  RxSwiftMVVM
//
//  Created by cashwalk on 13/12/2018.
//  Copyright © 2018 cashwalk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        title = getClassName(self)
        view.backgroundColor = .black
        
        let logoView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        logoView.image = UIImage(named: "Marvel_logo.jpg")
        logoView.contentMode = .scaleAspectFit
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.topItem?.titleView = logoView
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    public func setTitle(_ text: String) {
        title = text
    }

    private func getClassName(_ anyClass: AnyObject) -> String {
        return String(describing: type(of: anyClass))
    }
}

