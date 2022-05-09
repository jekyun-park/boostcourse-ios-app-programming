//
//  MovieList.swift
//  BoxOffice
//
//  Created by 박제균 on 2022/04/20.
//

import Foundation

struct MovieList: Codable {
    let orderType: Int
    let movies: [Movie]

    enum CodingKeys: String, CodingKey {
        case orderType = "order_type"
        case movies
    }

}

struct Movie: Codable, CustomStringConvertible {
    
    let grade: Int
    let thumb: String
    let reservationGrade: Int
    let title: String
    let reservationRate: Double
    let userRating: Double
    let date: String
    let movieId: String
    var description: String {
        switch self.grade {
        case 0:
            return "ic_allages"
        case 12:
            return "ic_12"
        case 15:
            return "ic_15"
        case 19:
            return "ic_19"
        default:
            return ""
        }
    }

    enum CodingKeys: String, CodingKey {
        case grade
        case thumb
        case reservationGrade = "reservation_grade"
        case title
        case reservationRate = "reservation_rate"
        case userRating = "user_rating"
        case date
        case movieId = "id"
    }

}


