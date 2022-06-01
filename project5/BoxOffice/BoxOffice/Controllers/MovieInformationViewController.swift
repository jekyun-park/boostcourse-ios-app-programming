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
    var movieDetailInformation: MovieDetailInformation? = nil
    var comments: [Comment] = []


// MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMovieDetailInformationNotification(_:)), name: DidReceiveMovieDetailInformationNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMovieComments(_:)), name: DidReceiveMovieCommentsNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveDataReceivingErrorNotification(_:)), name: DidReceiveDataReceivingError, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        requestMovieDetailInformation(movieId)
        requestMovieCommentsList(movieId)
    }

// MARK: - Functions

    @IBAction func didTapImageView(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let destinationViewController = storyboard.instantiateViewController(withIdentifier: "PosterImageViewController") as? PosterImageViewController else { return }
        destinationViewController.posterImageURLString = self.movieDetailInformation?.posterImageURL
        navigationController?.pushViewController(destinationViewController, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let writeCommentViewController = segue.destination as? WriteCommentViewController else { return }
        writeCommentViewController.movieDetailInformation = self.movieDetailInformation
    }

    func setUpNavigationItemTitles() {
        guard let movieDetailInformation = movieDetailInformation else { return }
        guard let navigationBarTopItem = self.navigationController?.navigationBar.topItem else { return }
        guard let navigationBarBackItem = self.navigationController?.navigationBar.backItem else { return }
        navigationBarTopItem.title = movieDetailInformation.title
        navigationBarBackItem.title = "영화목록"
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

    @objc func didReceiveMovieDetailInformationNotification(_ notification: Notification) {

        guard let movieDetailInformation: MovieDetailInformation = notification.userInfo?["movieDetailInformation"] as? MovieDetailInformation else { return }

        self.movieDetailInformation = movieDetailInformation

        DispatchQueue.main.async {
            self.movieInformationTableView.reloadData()
            self.setUpNavigationItemTitles()
        }
    }

    @objc func didReceiveMovieComments(_ notification: Notification) {

        guard let movieComments: Comments = notification.userInfo?["comments"] as? Comments else { return }
        self.comments = movieComments.comments

        DispatchQueue.main.async {
            self.movieInformationTableView.reloadData()
        }
    }

}

// MARK: - Table View

extension MovieInformationViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4 + comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let movieDetailInformation = movieDetailInformation else { return UITableViewCell() }

        switch indexPath.row {

        case 0:

            guard let movieInformationCell: MovieInformationCell = movieInformationTableView.dequeueReusableCell(withIdentifier: "movieInformationCell") as? MovieInformationCell else { return UITableViewCell() }

            movieInformationCell.poster.image = nil
            movieInformationCell.ageImageView.image = nil

            movieInformationCell.title.text = movieDetailInformation.title
            movieInformationCell.date.text = "\(movieDetailInformation.date) 개봉"
            movieInformationCell.genreAndRunningTime.text = movieDetailInformation.genre + "/\(movieDetailInformation.duration) 분"
            movieInformationCell.reservationRate.text = "\(movieDetailInformation.reservationGrade)위 \(movieDetailInformation.reservationRate)%"
            movieInformationCell.rating.text = "\(movieDetailInformation.userRating)"
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            movieInformationCell.numberOfAudience.text = formatter.string(from: NSNumber(value: movieDetailInformation.audience))

            for tag in 0...5 {
                if let starImage = movieInformationCell.viewWithTag(tag) as? UIImageView {
                    if tag <= Int(floor(movieDetailInformation.userRating)) / 2 {
                        starImage.image = UIImage(named: "ic_star_large_full")
                    } else {
                        if (2 * tag - Int(floor(movieDetailInformation.userRating))) <= 1 {
                            starImage.image = UIImage(named: "ic_star_large_half")
                        } else {
                            starImage.image = UIImage(named: "ic_star_large")
                        }
                    }
                }
            }

            DispatchQueue.global().async {
                guard let posterURL: URL = URL(string: movieDetailInformation.posterImageURL) else { return }
                guard let posterImageData: Data = try? Data(contentsOf: posterURL) else { return }

                DispatchQueue.main.async {
                    guard let index: IndexPath = self.movieInformationTableView.indexPath(for: movieInformationCell) else { return }

                    if index.row == indexPath.row {
                        movieInformationCell.poster.image = UIImage(data: posterImageData)
                        movieInformationCell.ageImageView.image = UIImage(named: movieDetailInformation.ageIconString)
                    }
                }
            }

            return movieInformationCell

        case 1:

            guard let movieSummaryCell: MovieSummaryCell = movieInformationTableView.dequeueReusableCell(withIdentifier: "movieSummaryCell") as? MovieSummaryCell else { return UITableViewCell() }

            movieSummaryCell.summaryText.text = movieDetailInformation.synopsis

            return movieSummaryCell

        case 2:

            guard let movieCastCell: MovieCastCell = movieInformationTableView.dequeueReusableCell(withIdentifier: "movieCastCell") as? MovieCastCell else { return UITableViewCell() }

            movieCastCell.directorLabel.text = movieDetailInformation.director
            movieCastCell.actorLabel.text = movieDetailInformation.actor

            return movieCastCell

        case 3:

            guard let reviewLabelCell: ReviewLabelCell = movieInformationTableView.dequeueReusableCell(withIdentifier: "reviewLabelCell") as? ReviewLabelCell else { return UITableViewCell() }

            return reviewLabelCell

        default:

            guard let movieReviewCell: MovieReviewCell = movieInformationTableView.dequeueReusableCell(withIdentifier: "movieReviewCell") as? MovieReviewCell else { return UITableViewCell() }

            movieReviewCell.writer.text = self.comments[indexPath.row - 4].writer
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = Date(timeIntervalSince1970: self.comments[indexPath.row - 4].timestamp)
            movieReviewCell.time.text = dateFormatter.string(from: date)
            movieReviewCell.contents.text = self.comments[indexPath.row - 4].contents

            for tag in 1...5 {
                if let starImage = movieReviewCell.viewWithTag(tag) as? UIImageView {
                    if tag <= Int(floor(self.comments[indexPath.row - 4].rating)) / 2 {
                        starImage.image = UIImage(named: "ic_star_large_full")
                    } else {
                        if (2 * tag - Int(floor(self.comments[indexPath.row - 4].rating))) <= 1 {
                            starImage.image = UIImage(named: "ic_star_large_half")
                        } else {
                            starImage.image = UIImage(named: "ic_star_large")
                        }
                    }
                }
            }

            return movieReviewCell
        }
    }
}
