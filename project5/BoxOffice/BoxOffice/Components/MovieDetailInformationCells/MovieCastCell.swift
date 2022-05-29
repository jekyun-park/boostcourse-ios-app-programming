//
//  MovieCastCell.swift
//  BoxOffice
//
//  Created by 박제균 on 2022/05/12.
//

import UIKit

class MovieCastCell: UITableViewCell {
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var actorLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
    }
}
