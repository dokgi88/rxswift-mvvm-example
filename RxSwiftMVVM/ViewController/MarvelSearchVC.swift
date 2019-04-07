//
//  MarvelSearchVC.swift
//  RxSwiftMVVM
//
//  Created by soom on 21/12/2018.
//

import RxCocoa
import RxSwift

final class MarvelSearchVC: ViewController {
    
    // MARK: - Properties

    private let disposeBag = DisposeBag()
    private var searchText = PublishRelay<String>()
    private lazy var viewModel = MarvelSearchViewModel(navigator: .init(self.navigationController))
    
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
        $0.isHidden = false
    }
    
    // MARK: - Overridden: BackViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindView()
        bindViewModel()
        setProperties()
        setupUI()
    }
    
    // MARK: - Private methods
    
    private func bindView() {
        searchTextField.rx.controlEvent(.editingDidEndOnExit)
            .bind { [weak self] (event) in
                guard let self = self, let text = self.searchTextField.text else {return}
                
                self.showLoading()
                UIView.animate(withDuration: 0.3, animations: {
                    self.tableView.contentOffset = .zero
                }, completion: { (_) in
                    self.searchText.accept(text)
                })
            }
            .disposed(by: disposeBag)
    }

    private func bindViewModel() {
        let input = MarvelSearchViewModel.Input(searchText: searchText.asDriverComplete(),
                                                modelSelected: tableView.rx.modelSelected(MarvelHeroModel.self))
        
        let output = viewModel.transform(input: input)
        output.heros
            .do(onNext: { [weak self] (heros) in
                guard let self = self else {return}
                self.hideLoading()
                self.emptyLabel.isHidden = heros.count > 0 ? true:false
            })
            .bind(to: tableView.rx.items(cellIdentifier: MarvelSearchTVCell.reuseIdentifier, cellType: MarvelSearchTVCell.self)) { (row, hero, cell) in
                cell.configure(viewModel: .init(model: hero))
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(MarvelSearchTVCell.self, forCellReuseIdentifier: MarvelSearchTVCell.reuseIdentifier)
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
        view.addSubview(searchTextField)
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
    }
}

// MARK: - UITableViewDelegate

extension MarvelSearchVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 320
    }
}
