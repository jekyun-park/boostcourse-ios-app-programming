//
//  Country.swift
//  WeatherToday
//
//  Created by 박제균 on 2022/01/26.
//
/*
 {"korean_name":"한국","asset_name":"kr"},
 {"korean_name":"독일","asset_name":"de"},
 {"korean_name":"이탈리아","asset_name":"it"},
 {"korean_name":"미국","asset_name":"us"},
 {"korean_name":"프랑스","asset_name":"fr"},
 {"korean_name":"일본","asset_name":"jp"}
 */

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
