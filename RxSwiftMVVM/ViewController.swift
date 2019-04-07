//
//  ViewController.swift
//  RxSwiftMVVM
//
//  Created by soom on 13/12/2018.
//

import UIKit

class ViewController: UIViewController {
    
    private let indicatorView = UIActivityIndicatorView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.style = .whiteLarge
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        $0.startAnimating()
        $0.alpha = 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setProperties()
    }
    
    public func setTitle(_ text: String) {
        title = text
    }
    
    public func showLoading() {
        view.addSubview(indicatorView)
        
        indicatorView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        indicatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        indicatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        indicatorView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        indicatorView.alpha = 1
    }
    
    public func hideLoading() {
        indicatorView.alpha = 0
        
        indicatorView.removeFromSuperview()
    }

    private func getClassName(_ anyClass: AnyObject) -> String {
        return String(describing: type(of: anyClass))
    }
    
    private func setProperties() {
        view.backgroundColor = .black
    }
    
}

