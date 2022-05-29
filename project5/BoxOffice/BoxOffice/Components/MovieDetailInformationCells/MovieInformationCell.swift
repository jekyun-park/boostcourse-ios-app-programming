//
//  MovieInformationCell.swift
//  BoxOffice
//
//  Created by 박제균 on 2022/05/12.
//

import UIKit

class MovieInformationCell: UITableViewCell {
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var ageImageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var genreAndRunningTime: UILabel!
    @IBOutlet weak var reservationRate: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var numberOfAudience: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
    }
}
