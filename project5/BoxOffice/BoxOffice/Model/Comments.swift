//
//  Comments.swift
//  BoxOffice
//
//  Created by 박제균 on 2022/04/20.
//

import Foundation

struct CommentsResponse: Codable {
    let comments: [Comment]

    struct Comment: Codable {
        let rating: Double
        let timestamp: Double
        let writer: String
        let movieId: String
        let contents: String
        let commentId: String

        enum CodingKeys: String, CodingKey {
            case rating
            case timestamp
            case writer
            case movieId = "movie_id"
            case contents
            case commentId = "id"
        }
    }

}
