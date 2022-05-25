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
    @IBOutlet weak var contentTextView: UITextView!


    var movieTitleString: String = ""
    var ageIconString: String = ""




    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTitleAndAgeGrade()
        setContentTextViewBorder()
    }



// MARK: - IBActions & Functions & Methods

    func loadTitleAndAgeGrade() {
        self.movieTitle.text = movieTitleString
        self.movieAgeIcon.image = UIImage(named: "\(ageIconString)")
    }
    
    func setContentTextViewBorder() {
        let contentTextViewBorderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        contentTextView.layer.borderColor = contentTextViewBorderColor
        contentTextView.layer.borderWidth = 1.0
        contentTextView.layer.cornerRadius = 5
    }

    @IBAction func touchUpCancelButton (_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func touchUpCompleteButton( _ sender: UIButton) {
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


