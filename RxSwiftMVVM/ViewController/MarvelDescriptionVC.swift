//
//  MarvelDescriptionVC.swift
//  RxSwiftMVVM
//
//  Created by cashwalk on 21/12/2018.
//  Copyright © 2018 cashwalk. All rights reserved.
//

import RxCocoa
import RxSwift
import Kingfisher

class MarvelDescriptionVC: ViewController {

    // MARK: - NSLayoutConstraints
    
    private var containerViewTop: NSLayoutConstraint!
    
    // MARK: - Properties
    
    var hero: MarvelHeroModel? {
        didSet {
            guard let hero = hero else {return}
            
            viewModel.hero = hero
        }
    }
    private let disposeBag = DisposeBag()
    private var viewModel = MarvelDescriptionViewModel()
    
    // MARK: - UI Components
    
    private let heroImageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
    }
    private let containerView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        $0.clipsToBounds = true
    }
    private let descriptionButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("DESCRIPTION", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
        $0.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        $0.layer.cornerRadius = 3
        $0.isSelected = true
    }
    private let heroDescTextView = UITextView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isEditable = false
        $0.backgroundColor = .clear
        $0.clipsToBounds = true
    }
    
    // MARK: - Overridden: ParentClass
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBinding()
        setupUI()
    }
    
    // MARK: - Private methods
    
    private func setupBinding() {
        descriptionButton.rx.tap
            .bind {
                let height = self.descriptionButton.isSelected ? 0:-(self.view.bounds.width-100)
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.containerViewTop.constant = height
                    self.view.layoutIfNeeded()
                }) { (_) in
                    self.descriptionButton.isSelected = !self.descriptionButton.isSelected
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.name
            .bind { (name) in
                self.title = name
            }
            .disposed(by: disposeBag)
        
        viewModel.thumbnail
            .bind { (url) in
                self.heroImageView.kf.setImage(with: url)
            }
            .disposed(by: disposeBag)
        
        viewModel.description
            .bind { (description) in
                self.heroDescTextView.attributedText = description
            }
            .disposed(by: disposeBag)
    }
    
    private func setupUI() {
        view.addSubview(heroImageView)
        view.addSubview(containerView)
        view.addSubview(descriptionButton)
        containerView.addSubview(heroDescTextView)
        layout()
    }
    
}

// MARK: - Layout

extension MarvelDescriptionVC {
    
    private func layout() {
        heroImageView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        heroImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        heroImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        heroImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        containerViewTop = containerView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -(view.bounds.width-100))
        containerViewTop.isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: view.bounds.width-100).isActive = true
        
        descriptionButton.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
        descriptionButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        descriptionButton.widthAnchor.constraint(equalToConstant: 130).isActive = true
        descriptionButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        heroDescTextView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8).isActive = true
        heroDescTextView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8).isActive = true
        heroDescTextView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8).isActive = true
        heroDescTextView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8).isActive = true
    }
}
