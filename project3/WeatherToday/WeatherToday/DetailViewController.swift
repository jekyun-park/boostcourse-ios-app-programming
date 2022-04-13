//
//  DetailViewController.swift
//  WeatherToday
//
//  Created by 박제균 on 2022/01/26.
//

import UIKit

class DetailViewController: UIViewController {
    
    var cityWeatherInformation : City?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var rainFallProbabilityLabel: UILabel!
    
    
    // MARK: - 네비게이션 아이템 타이틀, 날씨 이미지 및 세부 정보 표시
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = cityWeatherInformation?.cityName
        
        guard let city: City = cityWeatherInformation else {
            return
        }
        
        var koreanWeather: String {
            var string: String = ""
            if city.description == "sunny" {
                string = "맑음"
            } else if city.description == "cloudy" {
                string = "구름"
            } else if city.description == "rainy" {
                string = "비"
            } else if city.description == "snowy" {
                string = "눈"}
            return string
        }
    
        weatherImageView.image = UIImage(named: city.description)
        weatherLabel.text = koreanWeather
        
        temperatureLabel.text = city.temperatureString
        rainFallProbabilityLabel.text = city.rainFallProbabilityString
        if city.rainFallProbability > 50 { rainFallProbabilityLabel.textColor = .orange }
        if city.celsius < 10 { temperatureLabel.textColor = .blue }
    }
}
