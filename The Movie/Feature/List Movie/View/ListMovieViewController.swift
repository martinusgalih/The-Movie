//
//  ListMovieViewController.swift
//  The Movie
//
//  Created by Martinus Galih Widananto on 06/04/24.
//

import UIKit
import RxSwift
import RxCocoa

final class ListMovieViewController: UIViewController {
    
    let viewModel = ListMovieViewModel()
    private let disposeBag = DisposeBag()
    private let refreshControl = UIRefreshControl()
    
    private lazy var searchBar: CustomSearchBar = {
        let searchBar = CustomSearchBar()
        searchBar.placeholder = "Search"
        searchBar.backgroundColor = UIColor(hex: "#EEEEEE")
        return searchBar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.contentInset = .init(top: 20.0, left: .zero, bottom: .zero, right: .zero)
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        setupView()
        setupTableView()
        bind()
        viewModel.onViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
}

// MARK: - Setup View
extension ListMovieViewController {
    func bind() {
        viewModel.isLoading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                guard let self else { return }
                self.view.loading(on: isLoading)
                if !isLoading {
                    self.refreshControl.endRefreshing()
                }
            })
            .disposed(by: disposeBag)

        viewModel.movieList
            .bind(to: tableView.rx.items(cellIdentifier: "MovieCell", cellType: MovieCell.self)) { row, item, cell in
                cell.setupData(movie: item)
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self else { return }
                let movie = self.viewModel.items[indexPath.row]
                let vc = MovieDetailViewController()
                vc.viewModel.id = movie.id
                self.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
        
        tableView.rx.willDisplayCell
            .subscribe(onNext: { [weak self] cell, indexPath in
                guard let self else { return }
                if self.viewModel.items.count > 0 {
                    if indexPath.row == self.viewModel.items.count - 1 {
                        self.viewModel.onPagination()
                    }
                }
            }).disposed(by: disposeBag)
        
        searchBar.searchTextfield.rx.text.orEmpty
            .skip(2)
            .debounce(.milliseconds(800), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] query in
                guard let self else { return }
                viewModel.resetPage()
                if !query.isEmpty {
                    self.viewModel.isSearchActive = true
                    self.viewModel.searchMovie(query: query)
                } else {
                    self.viewModel.isSearchActive = false
                    self.viewModel.fetchPopularMovie()
                }
                
            }).disposed(by: disposeBag)
    }
    
    func setupView() {
        view.backgroundColor = UIColor(hex: "#EEEEEE")
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "MovieCell")
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func refreshData() {
        viewModel.refreshData()
    }
}
