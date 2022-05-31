//
//  PosterImageViewController.swift
//  BoxOffice
//
//  Created by 박제균 on 2022/05/31.
//

import UIKit

class PosterImageViewController: UIViewController {

    // MARK: - Constants & IBOutlets
    @IBOutlet weak var posterImageView: UIImageView!
    var posterImageURLString: String?


    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        requestPosterImage()
//        print(posterImageURLString)
        // Do any additional setup after loading the view.
    }


    // MARK: - Functions

    func requestPosterImage() {
        
        DispatchQueue.global().async {
            guard let posterImageURLString = self.posterImageURLString else { return }
            guard let posterImageURL: URL = URL(string: posterImageURLString) else { return }
            guard let posterImageData = try? Data(contentsOf: posterImageURL) else { return }

            DispatchQueue.main.async {
                self.posterImageView.image = UIImage(data: posterImageData)
            }
        }


    }

}
