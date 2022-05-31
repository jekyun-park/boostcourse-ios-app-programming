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
    @IBOutlet weak var orderBarButtonItem: UIBarButtonItem!

    var movies: [Movie] = []
    var orderTitle: String = ""
    let cellIdentifier = "movieListTableViewCell"


    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMovieListNotification(_:)), name: DidReceiveMovieListNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveDataReceivingErrorNotification(_:)), name: DidReceiveDataReceivingError, object: nil)
        configureRefreshControl()
    }

    override func viewWillAppear(_ animated: Bool) {
        requestMovieList(UserInformation.shared.orderType)
    }

    override func viewDidAppear(_ animated: Bool) {
        // printing logs
//         requestMovieList(0)
//         print(self.movies)
    }

    // MARK: - Functions

    func handleRequests(_ orderType: Int) -> ((UIAlertAction) -> ()) {
        let handler = { (action: UIAlertAction) in
            requestMovieList(orderType)
            UserInformation.shared.orderType = orderType
            DispatchQueue.main.async {
                self.movieListTableView
                    .reloadData()
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
    
    @objc func didReceiveDataReceivingErrorNotification(_ notification:Notification) {
        guard let error = notification.userInfo?["dataReceivingError"] as? Error else { return }
        let alertController = UIAlertController(title: "데이터 수신 에러", message: "다시 시도해 주세요, 에러 메시지는 아래와 같습니다."+"\n \(error.localizedDescription)", preferredStyle: .alert)
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
            self.movieListTableView.reloadData()
            self.navigationItem.title = self.orderTitle
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let movieInformationViewController = segue.destination as? MovieInformationViewController else { return }
        guard let movieListTableViewCell = sender as? MovieListTableViewCell else { return }
        guard let index = movieListTableView.indexPath(for: movieListTableViewCell) else { return }
        movieInformationViewController.movieId = movies[index.row].movieId
    }
}

// MARK: - Table View

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

// RefreshControl
extension MovieListTableViewController {
    
    func configureRefreshControl() {
        self.movieListTableView.refreshControl = UIRefreshControl()
        guard let refreshControl = self.movieListTableView.refreshControl else { return }
        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        DispatchQueue.main.async {
            self.movieListTableView.reloadData()
            guard let refreshControl = self.movieListTableView.refreshControl else { return }
            refreshControl.endRefreshing()
        }
    }
    
}
