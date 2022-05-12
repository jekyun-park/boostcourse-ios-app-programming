//
//  Request.swift
//  BoxOffice
//
//  Created by 박제균 on 2022/04/20.
//

import Foundation

let DidReceiveMovieListNotification: Notification.Name = Notification.Name("didReceiveMovieList")
let DidReceiveMovieDetailInformationNotification: Notification.Name = Notification.Name("didReceiveMovieDetailInformation")


func requestMovieList(_ orderType: Int) {

    guard let url: URL = URL(string: "https://connect-boxoffice.run.goorm.io/movies?order_type=\(orderType)") else { return }

    let session: URLSession = URLSession(configuration: .default)

    let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in

        if let error = error { print(error.localizedDescription) }

        guard let movieListData = data else { return }

        do {
            
            let movieListResponse: MovieList = try JSONDecoder().decode(MovieList.self, from: movieListData)
            NotificationCenter.default.post(name: DidReceiveMovieListNotification, object: nil, userInfo: ["movieList": movieListResponse.movies, "orderType": movieListResponse.description])
            
        } catch (let error) { print(error.localizedDescription) }
    }

    dataTask.resume()
}

func requestMovieDetailInformation(_ movieId:String) {
    guard let url: URL = URL(string: "https://connect-boxoffice.run.goorm.io/movie?id=\(movieId)") else { return }
    
    let session: URLSession = URLSession(configuration: .default)
    
    let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data:Data?, response:URLResponse?, error:Error?) in
        
        if let error = error { print(error.localizedDescription) }
        
        guard let movieDetailInformationData = data else { return }
        
        do {
            let movieDetailInformationResponse: MovieDetailInformation = try JSONDecoder().decode(MovieDetailInformation.self, from: movieDetailInformationData)
            
            NotificationCenter.default.post(name: DidReceiveMovieDetailInformationNotification, object: nil,userInfo: ["movieDetailInformation":movieDetailInformationResponse])
            
        } catch (let error) { print(error.localizedDescription) }
        
    }
    dataTask.resume()
}


func requestCommentsList() {
    /*
        한줄평 목록 요청하기
        해당 영화의 id가 있어야함
     */
}

func requestPostComment() {
    /*
        한줄평 등록하기
        해당 영화 id, 별점, 내용, 글쓴이를 묶어서 json 형식으로 Post
     */
}


