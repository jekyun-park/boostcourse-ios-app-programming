//
//  MovieListCollectionViewController.swift
//  BoxOffice
//
//  Created by 박제균 on 2022/04/19.
//

import UIKit

class MovieListCollectionViewController: UIViewController {

    // MARK: - IBOutlets & Variables & Constants
    @IBOutlet weak var movieListCollectionView: UICollectionView!
    var movies: [Movie] = []
    var orderTitle = ""
    let cellIdentifier = "movieListCollectionViewCell"




    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMovieListNotification(_:)), name: DidReceiveMovieListNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        if let orderType = UserInformation.shared.orderType {
            requestMovieList(orderType)
        } else {
            requestMovieList(0)
        }
    }


    // MARK: - IBActions & Methods

    @objc func didReceiveMovieListNotification(_ notification: Notification) {
        guard let movieList: [Movie] = notification.userInfo?["movieList"] as? [Movie] else { return }
        guard let orderTypeString = notification.userInfo?["orderType"] as? String else { return }
        
        self.movies = movieList
        self.orderTitle = orderTypeString

        DispatchQueue.main.async {
            self.movieListCollectionView.reloadData()
            self.navigationItem.title = self.orderTitle
        }

    }




}

// MARK: - Collection View

extension MovieListCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let movieListCollectionViewCell: MovieListCollectionViewCell = movieListCollectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? MovieListCollectionViewCell else { return UICollectionViewCell() }

        let movie = self.movies[indexPath.item]

        movieListCollectionViewCell.date.text = "개봉일 : " + movie.date
        movieListCollectionViewCell.title.text = movie.title
        movieListCollectionViewCell.title.sizeToFit()
        movieListCollectionViewCell.reservationInformation.text = "\(movie.reservationGrade)위(\(movie.userRating)) / \(movie.reservationRate)%"
        movieListCollectionViewCell.posterImageView.image = nil
        movieListCollectionViewCell.ageImageView.image = nil

        DispatchQueue.global().async {
            guard let posterURL: URL = URL(string: movie.thumb) else { return }
            guard let posterImageData: Data = try? Data(contentsOf: posterURL) else { return }

            DispatchQueue.main.async {
                guard let index: IndexPath = self.movieListCollectionView.indexPath(for: movieListCollectionViewCell) else { return }
                if index.item == indexPath.item {
                    movieListCollectionViewCell.posterImageView.image = UIImage(data: posterImageData)
                    movieListCollectionViewCell.ageImageView.image = UIImage(named: movie.description)
                }
            }
        }
        return movieListCollectionViewCell
    }

}

extension MovieListCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize() }
        
        let numberOfCells: CGFloat = 2
        
        let width: CGFloat = collectionView.frame.size.width - (flowLayout.minimumLineSpacing * (numberOfCells - 1))
        
        return CGSize(width: CGFloat(Int(width/numberOfCells)), height: CGFloat(Int(width*0.9)) )
    }
}
