//
//  WriteCommentViewController.swift
//  BoxOffice
//
//  Created by 박제균 on 2022/04/19.
//

import UIKit

class WriteCommentViewController: UIViewController {

    // MARK: - IBOutlets & Contstants & Varibles
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieAgeIcon: UIImageView!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var starRatingSlider: UISlider!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!

    var movieDetailInformation: MovieDetailInformation!



    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTitleAndAgeGrade()
        setContentTextViewBorder()
        setNickNameTextField()
    }



// MARK: - IBActions & Functions & Methods

    func loadTitleAndAgeGrade() {
        self.movieTitle.text = movieDetailInformation.title
        self.movieAgeIcon.image = UIImage(named: "\(movieDetailInformation.ageIconString)")
    }

    func setContentTextViewBorder() {
        let contentTextViewBorderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        contentTextView.layer.borderColor = contentTextViewBorderColor
        contentTextView.layer.borderWidth = 1.0
        contentTextView.layer.cornerRadius = 5
    }

    func setNickNameTextField() {
        if UserInformation.shared.nickName != nil {
            nickNameTextField.text = UserInformation.shared.nickName
        }
    }

    func contentTextViewSetupView() {
        if contentTextView.text == "한줄평을 작성해주세요" {
            contentTextView.text = ""
            contentTextView.textColor = UIColor.black
        } else if contentTextView.text == "" {
            contentTextView.text = "한줄평을 작성해주세요"
            contentTextView.textColor = UIColor.lightGray
        }
    }

    @IBAction func touchUpCancelButton (_ sender: UIButton) {
        self.dismiss(animated: true)
    }

    @IBAction func touchUpCompleteButton(_ sender: UIButton) {
        let rating = Double(starRatingSlider.value)
        guard let writer = nickNameTextField.text else { return }
        let movieId = movieDetailInformation.movieId
        guard let contents = contentTextView.text else { return }
        requestPostComment(rating: rating, writer: writer, movieId: movieId, contents: contents)
        self.dismiss(animated: true)
    }

    @IBAction func onDragStarRatingSlider(_ sender: UISlider) {
        let floatValue = floor(sender.value * 10) / 10
        let intValue = Int(floor(sender.value))

        for tag in 1...5 {
            if let starImageView = view.viewWithTag(tag) as? UIImageView {
                if tag <= intValue / 2 {
                    starImageView.image = UIImage(named: "ic_star_large_full")
                } else {
                    if (2 * tag - intValue) <= 1 {
                        starImageView.image = UIImage(named: "ic_star_large_half")
                    } else {
                        starImageView.image = UIImage(named: "ic_star_large")
                    }
                }
            }
        }
        self.rating.text = String(Int(floatValue))
    }

}


extension WriteCommentViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        contentTextViewSetupView()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if contentTextView.text == "" {
            contentTextViewSetupView()
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if contentTextView.text == "\n" {
            contentTextView.resignFirstResponder()
        }
        return true
    }
}
