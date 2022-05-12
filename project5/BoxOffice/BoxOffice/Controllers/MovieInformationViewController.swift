//
//  MovieInformationViewController.swift
//  BoxOffice
//
//  Created by 박제균 on 2022/04/19.
//

import UIKit

class MovieInformationViewController: UIViewController {


// MARK: - IBOutlet & Constants & Variables
    @IBOutlet weak var movieInformationTableView: UITableView!
    var movieId: String = ""
    var movieDetailInformation: MovieDetailInformation!


// MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMovieDetailInformationNotification(_:)), name: DidReceiveMovieDetailInformationNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        requestMovieDetailInformation(movieId)
    }

    override func viewDidAppear(_ animated: Bool) {
//        print(movieDetailInformation)
//        printContent(movieDetailInformation)
    }

// MARK: - functions & Methods

    @objc func didReceiveMovieDetailInformationNotification(_ notification: Notification) {

        guard let movieDetailInformation: MovieDetailInformation = notification.userInfo?["movieDetailInformation"] as? MovieDetailInformation else { return }
        self.movieDetailInformation = movieDetailInformation
        DispatchQueue.main.async {
            // UI setting
            self.movieInformationTableView.reloadData()
        }
    }


}

// MARK: - Table View

extension MovieInformationViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let movieDetailInformation = movieDetailInformation else { return UITableViewCell() }
        
        switch indexPath.row {
        case 0:
            
            guard let movieInformationCell: MovieInformationCell = movieInformationTableView.dequeueReusableCell(withIdentifier: "movieInformationCell") as? MovieInformationCell else { return UITableViewCell() }
//            guard let movieInformationCell: MovieInformationCell =
//                movieInformationTableView.cellForRow(at: indexPath) as? MovieInformationCell else { return UITableViewCell() }
            movieInformationCell.poster.image = nil
            movieInformationCell.ageImageView.image = nil

            DispatchQueue.global().async {
                guard let posterURL: URL = URL(string: movieDetailInformation.posterImageURL) else { return }
                guard let posterImageData: Data = try? Data(contentsOf: posterURL) else { return }

                DispatchQueue.main.async {
                    guard let index: IndexPath = self.movieInformationTableView.indexPath(for: movieInformationCell) else { return }
//                    print(posterImageData)
                    if index.row == indexPath.row {
                        movieInformationCell.poster.image = UIImage(data: posterImageData)
                        movieInformationCell.ageImageView.image = UIImage(named: movieDetailInformation.ageIconString)
                    }
                }
            }

            return movieInformationCell
        case 1:
            return UITableViewCell()
        case 2:
            return UITableViewCell()
        case 3:
            return UITableViewCell()
        default:
            return UITableViewCell()
        }
    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
//    }
    /*
     테이블뷰 구성
     
     - 정보
     - 줄거리
     - 감독/출연
     - 한줄평
     
     */

}
