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
    @IBOutlet weak var posterImageScrollView: UIScrollView!

    var posterImageURLString: String?


    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        requestPosterImage()
        setTapGestureRecognizer()
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

// MARK: - Tap Gesture Recognizer
extension PosterImageViewController: UIGestureRecognizerDelegate {
    func setTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(didTapPosterImageView))
        self.posterImageView.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func didTapPosterImageView() {
        guard let navigationController = navigationController else { return }
        guard let tabBarController = tabBarController else { return }
        navigationController.navigationBar.isHidden.toggle()
        tabBarController.tabBar.isHidden.toggle()
    }

}

// MARK: - Scroll View
extension PosterImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.posterImageView
    }
}
