//
//  MovieDetailInformation.swift
//  BoxOffice
//
//  Created by 박제균 on 2022/04/20.
//

import Foundation

struct MovieDetailResponse {
    let results: [MovieDetailInformation]
}

struct MovieDetailInformation: Codable {

    let audience: Int
    let actor: String
    let duration: Int
    let director: String
    let synopsis: String
    let genre: String
    let grade: Int
    let posterImageURL: String
    let reservationGrade: Int
    let title: String
    let reservationRate: Double
    let userRating: Double
    let date: String
    let movieId: String

    var ageIconString: String {
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
        case audience
        case actor
        case duration
        case director
        case synopsis
        case genre
        case grade
        case posterImageURL = "image"
        case reservationGrade = "reservation_grade"
        case title
        case reservationRate = "reservation_rate"
        case userRating = "user_rating"
        case date
        case movieId = "id"
    }

}
