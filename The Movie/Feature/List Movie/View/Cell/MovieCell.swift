//
//  MovieCell.swift
//  The Movie
//
//  Created by Martinus Galih Widananto on 06/04/24.
//

import UIKit
import RxSwift

class MovieCell: UITableViewCell {
    @IBOutlet var movieTitle: UILabel! {
        didSet {
            movieTitle.font = .poppins(size: 16.0, type: .regular)
            movieTitle.textColor = .init(hex: "#000000")
            movieTitle.numberOfLines = .zero
        }
    }
    @IBOutlet var movieImage: UIImageView! {
        didSet {
            movieImage.contentMode = .scaleAspectFill
        }
    }
    
    @IBOutlet var movieGenre: UILabel! {
        didSet {
            movieGenre.font = .poppins(size: 12.0, type: .regular)
            movieGenre.textColor = .init(hex: "#777777")
            movieGenre.numberOfLines = .zero
        }
    }
    @IBOutlet var movieYear: UILabel! {
        didSet {
            movieYear.font = .poppins(size: 16.0, type: .regular)
            movieYear.textColor = .init(hex: "#777777")
        }
    }
    
    private let disposeBag = DisposeBag()
    private var genreIds: [Int]?
    override func layoutSubviews() {
        super.layoutSubviews()
        selectionStyle = .none
        movieImage.cornerRadius(radius: 4)
    }
    
    
    func setupData(movie: MovieResponse) {
        genreIds = movie.genreIds
        movieTitle.text = movie.title
        
        movieYear.text = movie.releaseDate.extractYear()
        
        if let path = movie.posterPath {
            movieImage.source(url: MovieConstant.imageUrl + path)
        }
        getGenreData()
    }
    
    /**
     This is a function to get genre data from local storage
     since the genre data is not available in the movie list response
     we should map the genre id to the genre name
     **/
    func getGenreData() {
        LocalStorage.shared.getCachedResponse(forKey: "MovieAllGenreResponse")
            .subscribe(onNext: { [weak self] (cachedResponse: AllGenreResponse?) in
                guard let self = self, let cachedResponse = cachedResponse else {
                    self?.movieGenre.text = "Loading..."
                    return
                }
                var genreAllString: String = ""
                var genreArray: [String] = []
                for item in self.genreIds ?? [] {
                    for name in cachedResponse.genres {
                        if item == name.id {
                            genreArray.append(name.name)
                        }
                    }
                    genreAllString = genreArray.joined(separator: ", ")
                }
                movieGenre.text = genreAllString
            })
            .disposed(by: disposeBag)
    }
    
    
    func setupSkeleton() {
        movieTitle.text = "Loading"
        movieGenre.text = "Loading"
        movieYear.text = "Loading"
    }
}
