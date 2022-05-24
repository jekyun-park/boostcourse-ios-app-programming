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
    var movieTitle: String = ""
    var
    



    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }



// MARK: - IBActions & Functions & Methods
    @IBAction func touchUpCancelButton (_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
