//
//  MarvelSearchVC.swift
//  RxSwiftMVVM
//
//  Created by cashwalk on 21/12/2018.
//  Copyright © 2018 cashwalk. All rights reserved.
//

import RxCocoa
import RxSwift

class MarvelSearchVC: ViewController {
    
    let showMarvelDescriptionVC = "showMarvelDescriptionVC"

    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private var viewModel = MarvelSearchViewModel()
    
    
    // MARK: - UI Components
    
    private let searchTextField = UITextField().then {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 48))
        $0.leftView = paddingView
        $0.leftViewMode = .always
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.borderStyle = UITextField.BorderStyle.roundedRect
        $0.placeholder = "ex. Spider-Man"
        $0.backgroundColor = .white
    }
    private let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let emptyLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .black
        $0.text = "no heros :("
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 30)
    }
    private let indicatorView = UIActivityIndicatorView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.style = .whiteLarge
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        $0.startAnimating()
        $0.alpha = 0
    }
    
    // MARK: - Overridden: BackViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setProperties()
        setupBindings()
        setupUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == showMarvelDescriptionVC,
            let controller = segue.destination as? MarvelDescriptionVC,
            let hero = sender as? MarvelHeroModel else {return}
        
        controller.hero = hero
    }
    
    // MARK: - Private methods
    
    private func setProperties() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.register(MarvelSearchTVCell.self, forCellReuseIdentifier: MarvelSearchTVCell.reuseIdentifier)
    }
    
    private func setupBindings() {
        viewModel.heros
            .asObservable()
            .do(onNext: { (heros) in
                self.indicatorView.alpha = 0
                self.emptyLabel.isHidden = heros.count > 0 ? true:false
            })
            .bind(to: tableView.rx.items(cellIdentifier: MarvelSearchTVCell.reuseIdentifier, cellType: MarvelSearchTVCell.self)) { (row, hero, cell) in
                cell.hero = hero
            }.disposed(by: disposeBag)
        
        viewModel.showHero
            .bind { (hero) in
                self.performSegue(withIdentifier: self.showMarvelDescriptionVC, sender: hero)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(MarvelHeroModel.self)
            .bind(to: viewModel.selectHero)
            .disposed(by: disposeBag)
        
        searchTextField.rx.controlEvent(.editingDidEndOnExit)
            .bind { [weak self] (event) in
                guard let weakSelf = self else {return}
                guard let text = weakSelf.searchTextField.text else {return}
                
                weakSelf.indicatorView.alpha = 1
                UIView.animate(withDuration: 0.3, animations: {
                    weakSelf.tableView.contentOffset = .zero
                }, completion: { (_) in
                    weakSelf.viewModel.search = text
                })
            }
            .disposed(by: disposeBag)
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
        view.addSubview(searchTextField)
        view.addSubview(indicatorView)
        layout()
    }
    
}

// MARK: - Layout

extension MarvelSearchVC {
    
    private func layout() {
        searchTextField.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 10).isActive = true
        searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 14).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        emptyLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        emptyLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        indicatorView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        indicatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        indicatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        indicatorView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

// MARK: - UITableViewDelegate

extension MarvelSearchVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 320
    }
}
