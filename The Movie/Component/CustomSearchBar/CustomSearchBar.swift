//
//  CustomSearchBar.swift
//  The Movie
//
//  Created by Martinus Galih Widananto on 06/04/24.
//

import UIKit

final class CustomSearchBar: UIView {
    
    lazy var searchTextfield: UITextField = {
        let searchBar = UITextField()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private lazy var searchIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
        return imageView
    }()
    
    private lazy var separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        return view
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 17.0, left: 16.0, bottom: 11.0, right: 16.0)
        return stackView
    }()
    
    var placeholder: String? {
        get {
            return searchTextfield.placeholder
        }
        set {
            searchTextfield.placeholder = newValue
            setupView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(searchTextfield)
        addSubview(searchIcon)
        addSubview(horizontalStackView)
        addSubview(separatorLine)
        
        horizontalStackView.addArrangedSubview(searchTextfield)
        horizontalStackView.addArrangedSubview(searchIcon)
        addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(horizontalStackView)
        verticalStackView.addArrangedSubview(separatorLine)
        
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: topAnchor),
            verticalStackView.leftAnchor.constraint(equalTo: leftAnchor),
            verticalStackView.rightAnchor.constraint(equalTo: rightAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        layoutSubviews()
    }
}
