//
//  MovieReviewCell.swift
//  BoxOffice
//
//  Created by 박제균 on 2022/05/24.
//

import UIKit

class MovieReviewCell: UITableViewCell {
    @IBOutlet weak var writer: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var contents: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
    }
}
