//
//  MovieSummaryCell.swift
//  BoxOffice
//
//  Created by 박제균 on 2022/05/12.
//

import UIKit

class MovieSummaryCell: UITableViewCell {
    @IBOutlet weak var synopsysLabel: UILabel!
    @IBOutlet weak var summaryText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
    }
}
