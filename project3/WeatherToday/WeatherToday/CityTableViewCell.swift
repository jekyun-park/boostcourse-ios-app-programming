//
//  CityTableViewCell.swift
//  WeatherToday
//
//  Created by 박제균 on 2022/01/27.
//

import UIKit

// MARK: - Custom TableView Cell
class CityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var rainFallProbabilityLabel: UILabel!
}
