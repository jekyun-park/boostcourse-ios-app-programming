//
//  Comments.swift
//  BoxOffice
//
//  Created by 박제균 on 2022/04/20.
//

import Foundation

struct Comments: Codable {
    let comments: [Comment]

    enum CodingKeys: String, CodingKey {
        case comments
    }
}

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

struct PostComment: Codable {
    let rating: Double
    let writer: String
    let movieId: String
    let contents: String

    enum CodingKeys: String, CodingKey {
        case rating, writer, contents
        case movieId = "movie_id"
    }

}
