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


// MARK: - Functions

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

    func checkBlank() -> Bool {
        let regex = "\\S"
        guard let nickName = nickNameTextField.text else { return false }
        let isNickNameHasOnlySpace = !(nickName.trimmingCharacters(in: .whitespaces).range(of: regex, options: .regularExpression) != nil)
        let isContentHasOnlySpace = !(contentTextView.text.trimmingCharacters(in: .whitespaces).range(of: regex, options: .regularExpression) != nil)

        if (nickNameTextField.text == nil) || (nickNameTextField.text == "") || isNickNameHasOnlySpace {
            return false
        }
        if (contentTextView.text == nil) || (contentTextView.text == "") || (contentTextView.text == "한줄평을 작성해주세요") || isContentHasOnlySpace {
            return false
        }
        return true
    }

    @IBAction func touchUpCancelButton (_ sender: UIButton) {
        self.dismiss(animated: true)
    }

    @IBAction func touchUpCompleteButton(_ sender: UIButton) {
        let rating = Double(starRatingSlider.value)
        guard let writer = nickNameTextField.text?.trimmingCharacters(in: .whitespaces) else { return }
        let movieId = movieDetailInformation.movieID
        guard var contents = contentTextView.text else { return }
        contents = contents.trimmingCharacters(in: .whitespaces)

        if checkBlank() {
            requestPostComment(rating: rating, writer: writer, movieId: movieId, contents: contents)
            self.dismiss(animated: true)
        } else {
            let alertController = UIAlertController(title: "닉네임과 한줄평을 모두 작성해주세요", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            present(alertController, animated: true)
        }
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

    @objc func didReceiveCommentPostErrorNotification(_ notification: Notification) {
        guard let error = notification.userInfo?["commentPostError"] as? Error else { return }
        let alertController = UIAlertController(title: "한줄평 작성에 실패하였습니다.", message: "다시 시도해 주세요, 에러 메시지는 아래와 같습니다." + "\n \(error.localizedDescription)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}


// MARK: - Text View 
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
