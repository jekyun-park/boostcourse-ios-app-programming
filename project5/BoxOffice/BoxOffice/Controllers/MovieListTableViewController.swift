//
//  MovieListTableViewController.swift
//  BoxOffice
//
//  Created by 박제균 on 2022/04/19.
//

import UIKit

class MovieListTableViewController: UIViewController {

    // MARK: - IBOutlets & Variables & Constants
    @IBOutlet weak var movieListTableView: UITableView!

    var movies: [Movie] = []
    let cellIdentifier = "movieListTableViewCell"



    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMovieListNotification(_:)), name: DidReceiveMovieListNotification, object: nil)
//        requestMovieList(0)
//        print(self.movies)
        setConfigurations()
    }

    override func viewWillAppear(_ animated: Bool) {
        requestMovieList(0)
//        print(movieList)
    }

    override func viewDidAppear(_ animated: Bool) {
//        requestMovieList(0)
//        print(self.movies)
    }

    // MARK: - IBActions, Methods

    @objc func didReceiveMovieListNotification(_ notification: Notification) {
        guard let movieList: [Movie] = notification.userInfo?["movieList"] as? [Movie] else { return }
        self.movies = movieList
        DispatchQueue.main.async {
            self.movieListTableView.reloadData()
        }

    }

    func setConfigurations() {
        navigationItem.title = "예매율순"
//        navigationController?.navigationBar.backgroundColor = .blue
    }


}

extension MovieListTableViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let movieListTableViewCell: MovieListTableViewCell = movieListTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MovieListTableViewCell else { return UITableViewCell() }

        let movie = movies[indexPath.row]

        movieListTableViewCell.date.text = "개봉일 : " + movie.date
        movieListTableViewCell.title.text = movie.title
        movieListTableViewCell.reservationInformation.text = "평점 : \(movie.userRating) 예매순위 : \(movie.reservationGrade) 예매율 : \(movie.reservationRate)"
        movieListTableViewCell.posterImageView.image = nil
        movieListTableViewCell.ageImageView.image = nil

        DispatchQueue.global().async {
            guard let posterURL: URL = URL(string: movie.thumb) else { return }
            guard let posterImageData: Data = try? Data(contentsOf: posterURL) else { return }

            DispatchQueue.main.async {
                guard let index: IndexPath = self.movieListTableView.indexPath(for: movieListTableViewCell) else { return }
                if index.row == indexPath.row {
                    movieListTableViewCell.posterImageView.image = UIImage(data: posterImageData)
                    movieListTableViewCell.ageImageView.image = UIImage(named: movie.description)
                }
            }
        }

        return movieListTableViewCell
    }

}

