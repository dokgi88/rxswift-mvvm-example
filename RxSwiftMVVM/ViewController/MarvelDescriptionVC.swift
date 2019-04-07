//
//  MarvelDescriptionVC.swift
//  RxSwiftMVVM
//
//  Created by soom on 21/12/2018.
//

import RxCocoa
import RxSwift
import Kingfisher

final class MarvelDescriptionVC: ViewController {

    // MARK: - NSLayoutConstraints
    
    private var containerViewTop: NSLayoutConstraint!
    
    // MARK: - Properties

    private let disposeBag = DisposeBag()
    private var viewModel: MarvelDescriptionViewModel!
    
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
        $0.isSelected = true
    }
    private let heroDescTextView = UITextView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isEditable = false
        $0.backgroundColor = .clear
        $0.clipsToBounds = true
    }
    
    init(viewModel: MarvelDescriptionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        showLoading()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Overridden: ParentClass
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindView()
        bindViewModel()
        setupUI()
    }
    
    // MARK: - Private methods
    
    private func bindView() {
        descriptionButton.rx.tap
            .bind { [weak self] in
                guard let self = self else {return}
                let height = self.descriptionButton.isSelected ? 0:-(self.view.bounds.width-100)
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.containerViewTop.constant = height
                    self.view.layoutIfNeeded()
                }) { (_) in
                    self.descriptionButton.isSelected = !self.descriptionButton.isSelected
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let viewDidAppear = rx.sentMessage(#selector(UIViewController.viewDidAppear(_:))).take(1).mapToVoid().asDriverComplete()
        let input = MarvelDescriptionViewModel.Input(trigger: viewDidAppear)
        
        let output = viewModel.transform(input: input)
        output.thumbnail
            .drive(onNext: { [weak self] (url) in
                guard let self = self else {return}
                self.heroImageView.kf.setImage(with: url)
                self.hideLoading()
            })
            .disposed(by: disposeBag)
        output.name
            .drive(rx.title)
            .disposed(by: disposeBag)
        output.description
            .drive(heroDescTextView.rx.attributedText)
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
