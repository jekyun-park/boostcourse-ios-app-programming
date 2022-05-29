//
//  Request.swift
//  BoxOffice
//
//  Created by 박제균 on 2022/04/20.
//


import UIKit

let DidReceiveMovieListNotification: Notification.Name = Notification.Name("didReceiveMovieList")
let DidReceiveMovieDetailInformationNotification: Notification.Name = Notification.Name("didReceiveMovieDetailInformation")
let DidReceiveMovieCommentsNotification: Notification.Name = Notification.Name("didReceiveMovieComments")


func requestMovieList(_ orderType: Int) -> Bool {
    var isError = false
    guard let url: URL = URL(string: "https://connect-boxoffice.run.goorm.io/movies?order_type=\(orderType)") else { return false }

    let session: URLSession = URLSession(configuration: .default)

    let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in

        if let error = error {
            print(error.localizedDescription)
            isError = true
        }

        guard let movieListData = data else { return }

        do {

            let movieListResponse: MovieList = try JSONDecoder().decode(MovieList.self, from: movieListData)
            NotificationCenter.default.post(name: DidReceiveMovieListNotification, object: nil, userInfo: ["movieList": movieListResponse.movies, "orderType": movieListResponse.description])

        } catch (let error) {
            print(error.localizedDescription)
            isError = true
        }

    }
    if isError { return false }
    dataTask.resume()
    return true
}

func requestMovieDetailInformation(_ movieId: String) -> Bool {
    var isError = false
    guard let url: URL = URL(string: "https://connect-boxoffice.run.goorm.io/movie?id=\(movieId)") else { return false }

    let session: URLSession = URLSession(configuration: .default)

    let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in

        if let error = error {
            print(error.localizedDescription)
            isError = true
        }

        guard let movieDetailInformationData = data else { return }

        do {
            let movieDetailInformationResponse: MovieDetailInformation = try JSONDecoder().decode(MovieDetailInformation.self, from: movieDetailInformationData)

            NotificationCenter.default.post(name: DidReceiveMovieDetailInformationNotification, object: nil, userInfo: ["movieDetailInformation": movieDetailInformationResponse])

        } catch (let error) {
            print(error.localizedDescription)
            isError = true
        }

    }
    if isError { return false }
    dataTask.resume()
    return true
}


func requestMovieCommentsList(_ movieId: String) -> Bool {
    var isError = false

    guard let url: URL = URL(string: "https://connect-boxoffice.run.goorm.io/comments?movie_id=\(movieId)") else { return false }

    let session: URLSession = URLSession(configuration: .default)

    let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in

        if let error = error { print(error.localizedDescription) }

        guard let movieCommentsData = data else { return }

        do {
            let movieCommentsResponse: Comments = try JSONDecoder().decode(Comments.self, from: movieCommentsData)

            NotificationCenter.default.post(name: DidReceiveMovieCommentsNotification, object: nil, userInfo: ["comments": movieCommentsResponse])

        } catch (let error) {
            print(error.localizedDescription)
            isError = true
        }
    }
    
    if isError { return false }
    
    dataTask.resume()
    return true
}

func requestPostComment(rating: Double, writer: String, movieId: String, contents: String) -> Bool {
    /*
        한줄평 등록하기
        해당 영화 id, 별점, 내용, 글쓴이를 묶어서 json 형식으로 Post
     */
    var isError = false

    let comment = PostComment(rating: rating, writer: writer, movieId: movieId, contents: contents)

    let session: URLSession = URLSession(configuration: .default)

    guard let url: URL = URL(string: "https://connect-boxoffice.run.goorm.io/comment") else { return false }

    guard let dataToUpload = try? JSONEncoder().encode(comment) else { print("Encoding failed"); return false }

    var postRequest = URLRequest(url: url)
    postRequest.httpMethod = "POST"
    postRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let uploadTask = session.uploadTask(with: postRequest, from: dataToUpload) { (data: Data?, response: URLResponse?, error: Error?) in

        if let error = error {
            print(error.localizedDescription)
            isError = true
            return
        } else {
            if let _ = response {
                 print("POST Complete")
                UserInformation.shared.nickName = writer
            }
        }
    }
    
    if isError { return false }
    
    uploadTask.resume()

    return true
}


