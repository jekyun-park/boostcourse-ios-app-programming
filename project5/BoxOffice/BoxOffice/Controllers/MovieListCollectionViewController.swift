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
    @IBOutlet weak var orderBarButtonItem: UIBarButtonItem!

    var movies: [Movie] = []
    var orderTitle = ""
    let cellIdentifier = "movieListCollectionViewCell"


// MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMovieListNotification(_:)), name: DidReceiveMovieListNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveDataReceivingErrorNotification(_:)), name: DidReceiveDataReceivingError, object: nil)
        configureRefreshControl()
        requestMovieList(UserInformation.shared.orderType)
    }


// MARK: - Functions

    func handleRequests(_ orderType: Int) -> ((UIAlertAction) -> ()) {
        let handler = { (action: UIAlertAction) in
            requestMovieList(UserInformation.shared.orderType)
            UserInformation.shared.orderType = orderType
            DispatchQueue.main.async {
                self.movieListCollectionView.reloadData()
            }
        }
        return handler
    }

    @IBAction func showAlertController() {
        let orderAlertController: UIAlertController

        orderAlertController = UIAlertController(title: "정렬방식 선택", message: "영화를 어떤 순서로 정렬할까요?", preferredStyle: UIAlertController.Style.actionSheet)

        orderAlertController.addAction(UIAlertAction(title: "예매율", style: UIAlertAction.Style.default, handler: handleRequests(0)))
        orderAlertController.addAction(UIAlertAction(title: "큐레이션", style: UIAlertAction.Style.default, handler: handleRequests(1)))
        orderAlertController.addAction(UIAlertAction(title: "개봉일", style: UIAlertAction.Style.default, handler: handleRequests(2)))
        orderAlertController.addAction(UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel))

        self.present(orderAlertController, animated: true, completion: nil)
    }

    @objc func didReceiveDataReceivingErrorNotification(_ notification: Notification) {
        guard let error = notification.userInfo?["dataReceivingError"] as? Error else { return }
        let alertController = UIAlertController(title: "데이터 수신 에러", message: "다시 시도해 주세요, 에러 메시지는 아래와 같습니다." + "\n \(error.localizedDescription)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { UIAlertAction in
            guard let navigationController = self.navigationController else { return }
            navigationController.popViewController(animated: true)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true)

    }

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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let movieInformationViewController = segue.destination as? MovieInformationViewController else { return }
        guard let movieListCollectionViewCell = sender as? MovieListCollectionViewCell else { return }
        guard let index = movieListCollectionView.indexPath(for: movieListCollectionViewCell) else { return }
        movieInformationViewController.movieID = movies[index.row].movieId
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
        movieListCollectionViewCell.title.adjustsFontSizeToFitWidth = true
        movieListCollectionViewCell.title.preferredMaxLayoutWidth = UIScreen.main.bounds.width
        movieListCollectionViewCell.title.sizeToFit()
        movieListCollectionViewCell.title.layoutIfNeeded()

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


// MARK: - Collection View Layout

extension MovieListCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize() }

        let numberOfCells: CGFloat = 2

        let width: CGFloat = collectionView.frame.size.width - (flowLayout.minimumLineSpacing)

        return CGSize(width: CGFloat(Int(width / numberOfCells)), height: CGFloat(Int(width * 0.9)))
    }
}

// MARK: - RefreshControl

extension MovieListCollectionViewController {
    func configureRefreshControl() {
        self.movieListCollectionView.refreshControl = UIRefreshControl()
        guard let refreshControl = self.movieListCollectionView.refreshControl else { return }
        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }

    @objc func handleRefreshControl() {
        DispatchQueue.main.async {
            self.movieListCollectionView.reloadData()
            guard let refreshControl = self.movieListCollectionView.refreshControl else { return }
            refreshControl.endRefreshing()
        }
    }
}
