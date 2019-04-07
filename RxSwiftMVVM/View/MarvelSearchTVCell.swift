//
//  MarvelSearchTVCell.swift
//  RxSwiftMVVM
//
//  Created by soom on 21/12/2018.
//

import UIKit

import Kingfisher
import RxCocoa
import RxSwift
import Then

class MarvelSearchTVCell: UITableViewCell {
    
    // MARK: - Constants
    
    static let reuseIdentifier = "MarvelSearchTVCell"
    
    // MARK: - Properties
    
    private var disposeBag = DisposeBag()
    private var viewModel: MarvelSearchTVCellViewModel!
    
    // MARK: - UI Components
    
    private let heroImageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 6
        $0.clipsToBounds = true
    }
    private let heroTitleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        $0.font = .systemFont(ofSize: 20, weight: .black)
        $0.textColor = .white
        $0.textAlignment = .center
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setProperties()
        contentView.addSubview(heroImageView)
        contentView.addSubview(heroTitleLabel)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        heroImageView.image = nil
        heroTitleLabel.text = nil
    }
    
    func configure(viewModel: MarvelSearchTVCellViewModel) {
        self.viewModel = viewModel
        bindViewModel()
    }
    
    private func bindViewModel() {
        let layoutSubviews = rx.sentMessage(#selector(UITableViewCell.layoutSubviews)).take(1).mapToVoid().asDriverComplete()
        let input = MarvelSearchTVCellViewModel.Input(trigger: layoutSubviews)
        
        let output = viewModel.transform(input: input)
        output.thumbnail
            .drive(onNext: { [weak self] (url) in
                guard let self = self else {return}
                self.heroImageView.kf.setImage(with: url)
            })
            .disposed(by: disposeBag)
        output.name
            .drive(heroTitleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setProperties() {
        backgroundColor = .clear
        selectionStyle = .none
    }
}

// MARK: - Layout

extension MarvelSearchTVCell {
    
    private func layout() {
        heroImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        heroImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        heroImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        heroImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        
        heroTitleLabel.topAnchor.constraint(equalTo: heroImageView.topAnchor).isActive = true
        heroTitleLabel.leadingAnchor.constraint(equalTo: heroImageView.leadingAnchor).isActive = true
        heroTitleLabel.trailingAnchor.constraint(equalTo: heroImageView.trailingAnchor).isActive = true
        heroTitleLabel.bottomAnchor.constraint(equalTo: heroImageView.bottomAnchor).isActive = true
    }
}
