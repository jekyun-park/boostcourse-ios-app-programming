//
//  Country.swift
//  WeatherToday
//
//  Created by 박제균 on 2022/01/26.
//

import Foundation

// MARK: - 국가 정보
struct Country: Codable {

    let koreanName: String
    let assetName: String
    
    var flagImageName: String {
        return "flag_"+self.assetName
    }

    enum CodingKeys: String, CodingKey {
        case koreanName = "korean_name"
        case assetName = "asset_name"
    }
}
