//
//  ReviewLabelCell.swift
//  BoxOffice
//
//  Created by 박제균 on 2022/05/12.
//

import UIKit

class ReviewLabelCell: UITableViewCell {
    @IBOutlet weak var writeButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
    }
}
