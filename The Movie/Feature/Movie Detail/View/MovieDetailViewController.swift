//
//  MovieDetailViewController.swift
//  The Movie
//
//  Created by Martinus Galih Widananto on 07/04/24.
//

import UIKit
import RxSwift

class MovieDetailViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    let viewModel = MovieDetailViewModel()
    private let disposeBag = DisposeBag()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        viewModel.onViewDidLoad()
        bind()
    }
    
    func bind() {
        viewModel.isLoading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                guard let self else { return }
                self.view.loading(on: isLoading)
                if !isLoading {
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                }
            }).disposed(by: disposeBag)
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "ImageHeaderCell", bundle: nil), forCellReuseIdentifier: "ImageHeaderCell")
        tableView.register(UINib(nibName: "DescriptionCell", bundle: nil), forCellReuseIdentifier: "DescriptionCell")
        tableView.register(UINib(nibName: "CastCell", bundle: nil), forCellReuseIdentifier: "CastCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    @objc private func refreshData() {
        viewModel.refreshData()
    }
}

// MARK: - TableView Delegate
extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageHeaderCell") as? ImageHeaderCell else { return UITableViewCell() }
            cell.delegate = self
            if let item = viewModel.movieDetailItem {
                cell.setupItem(item)
            }
            return cell
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell") as? DescriptionCell else { return UITableViewCell() }
            cell.descriptionLabel.text = viewModel.movieDetailItem?.overview
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CastCell") as? CastCell else { return UITableViewCell() }
            cell.crew = viewModel.movieDetailItem?.credits.cast ?? []
            return cell
        }
    }
}

// MARK: - ImageHeaderCellProtocol
extension MovieDetailViewController: ImageHeaderCellProtocol {
    func didBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
