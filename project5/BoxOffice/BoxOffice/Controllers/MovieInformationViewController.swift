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
    var comments: [Comment] = []


// MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMovieDetailInformationNotification(_:)), name: DidReceiveMovieDetailInformationNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMovieComments(_:)), name: DidReceiveMovieCommentsNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        requestMovieDetailInformation(movieId)
        requestMovieCommentsList(movieId)
    }

    override func viewDidAppear(_ animated: Bool) {
//        print(movieDetailInformation)
//        printContent(movieDetailInformation)
//        print(comments)
    }

// MARK: - functions & Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

    @objc func didReceiveMovieDetailInformationNotification(_ notification: Notification) {

        guard let movieDetailInformation: MovieDetailInformation = notification.userInfo?["movieDetailInformation"] as? MovieDetailInformation else { return }
        self.movieDetailInformation = movieDetailInformation
        DispatchQueue.main.async {
            // UI setting
            self.movieInformationTableView.reloadData()
            guard let navigationBarTopItem = self.navigationController?.navigationBar.topItem else { return }
            guard let navigationBarBackItem = self.navigationController?.navigationBar.backItem else { return }
            navigationBarTopItem.title = movieDetailInformation.title
            navigationBarBackItem.title = "영화목록"
            
        }
    }
    
    @objc func didReceiveMovieComments(_ notification:Notification) {
        
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
        return 4+comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let movieDetailInformation = movieDetailInformation else { return UITableViewCell() }

        switch indexPath.row {
        case 0:

            guard let movieInformationCell: MovieInformationCell = movieInformationTableView.dequeueReusableCell(withIdentifier: "movieInformationCell") as? MovieInformationCell else { return UITableViewCell() }

            movieInformationCell.poster.image = nil
            movieInformationCell.ageImageView.image = nil

            DispatchQueue.global().async {
                guard let posterURL: URL = URL(string: movieDetailInformation.posterImageURL) else { return }
                guard let posterImageData: Data = try? Data(contentsOf: posterURL) else { return }

                DispatchQueue.main.async {
                    guard let index: IndexPath = self.movieInformationTableView.indexPath(for: movieInformationCell) else { return }

                    if index.row == indexPath.row {
                        movieInformationCell.poster.image = UIImage(data: posterImageData)
                        movieInformationCell.ageImageView.image = UIImage(named: movieDetailInformation.ageIconString)
                        movieInformationCell.title.text = movieDetailInformation.title
                        movieInformationCell.date.text = "\(movieDetailInformation.date) 개봉"
                        movieInformationCell.genreAndRunningTime.text = movieDetailInformation.genre + "/\(movieDetailInformation.duration) 분"
                        movieInformationCell.reservationRate.text = "\(movieDetailInformation.reservationGrade)위 \(movieDetailInformation.reservationRate)%"
                        movieInformationCell.rating.text = "\(movieDetailInformation.userRating)"

                        let formatter = NumberFormatter()
                        formatter.numberStyle = .decimal
                        movieInformationCell.numberOfAudience.text = formatter.string(from: NSNumber(value: movieDetailInformation.audience))

                        // star rating
                        for tag in 1...5 {
                            if let starImage = self.view.viewWithTag(tag) as? UIImageView {
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
                    }
                }
            }

            return movieInformationCell
        case 1:
            guard let movieSummaryCell: MovieSummaryCell = movieInformationTableView.dequeueReusableCell(withIdentifier: "movieSummaryCell") as? MovieSummaryCell else { return UITableViewCell() }
            DispatchQueue.main.async {
                guard let index: IndexPath = self.movieInformationTableView.indexPath(for: movieSummaryCell) else { return }
                if index.row == indexPath.row {
                    movieSummaryCell.summaryText.text = movieDetailInformation.synopsis
                }
            }

            return movieSummaryCell
        case 2:
            guard let movieCastCell: MovieCastCell = movieInformationTableView.dequeueReusableCell(withIdentifier: "movieCastCell") as? MovieCastCell else { return UITableViewCell() }
            
            DispatchQueue.main.async {
                guard let index: IndexPath = self.movieInformationTableView.indexPath(for: movieCastCell) else { return }
                if index.row == indexPath.row {
                    movieCastCell.directorLabel.text = movieDetailInformation.director
                    movieCastCell.actorLabel.text = movieDetailInformation.actor
//                    movieCastCell.directorLabel.sizeToFit()
//                    movieCastCell.actorLabel.sizeToFit()
                }
            }
            
            return movieCastCell
        case 3:
            guard let reviewLabelCell: ReviewLabelCell = movieInformationTableView.dequeueReusableCell(withIdentifier: "reviewLabelCell") as? ReviewLabelCell else { return UITableViewCell() }
            return reviewLabelCell
            
        default:
            
            guard let movieReviewCell: MovieReviewCell = movieInformationTableView.dequeueReusableCell(withIdentifier: "movieReviewCell") as? MovieReviewCell else { return UITableViewCell() }
            
            DispatchQueue.main.async {
                guard let index:IndexPath = self.movieInformationTableView.indexPath(for: movieReviewCell) else { return }
                if index.row == indexPath.row {
                    movieReviewCell.writer.text = self.comments[indexPath.row-4].writer
                    movieReviewCell.writer.sizeToFit()
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let date = Date(timeIntervalSince1970: self.comments[indexPath.row-4].timestamp)
                    movieReviewCell.time.text = dateFormatter.string(from: date)
                    movieReviewCell.contents.text = self.comments[indexPath.row-4].contents
                    
                    for tag in 1...5 {
                        
                        if let starImage = movieReviewCell.viewWithTag(tag) as? UIImageView {
                            if tag <= Int(floor(self.comments[indexPath.row-4].rating)) / 2 {
                                starImage.image = UIImage(named: "ic_star_large_full")
                            } else {
                                if (2 * tag - Int(floor(self.comments[indexPath.row-4].rating))) <= 1 {
                                    starImage.image = UIImage(named: "ic_star_large_half")
                                } else {
                                    starImage.image = UIImage(named: "ic_star_large")
                                }
                            }
                        }
                    }
                    
                }
            }
            
            
            return movieReviewCell
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
