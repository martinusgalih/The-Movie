//
//  CastCell.swift
//  The Movie
//
//  Created by Martinus Galih Widananto on 07/04/24.
//

import UIKit

class CastCell: UITableViewCell {

    @IBOutlet var castLabel: UILabel! {
        didSet {
            castLabel.font = .poppins(size: 14.0, type: .bold)
        }
    }
    
    @IBOutlet var collectionView: UICollectionView!
    
    var crew: [CastResponse] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setupCollectionView()
    }
    
    func setupCollectionView() {
        collectionView.register(UINib(nibName: "CrewItemCell", bundle: nil), forCellWithReuseIdentifier: "CrewItemCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }

}

extension CastCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return crew.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CrewItemCell", for: indexPath) as? CrewItemCell else { return UICollectionViewCell() }
        cell.setupItem(crew: crew[indexPath.row])
        return cell
    }
}
