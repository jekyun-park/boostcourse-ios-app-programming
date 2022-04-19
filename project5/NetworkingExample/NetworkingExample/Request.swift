//
//  Request.swift
//  NetworkingExample
//
//  Created by 박제균 on 2022/04/19.
//

import Foundation

let DidReceiveFriendsNotification: Notification.Name = Notification.Name("DidReceiveFriends")

func requestFriends() {
    guard let url: URL = URL(string: "https://randomuser.me/api/?results=20&inc=name,email,picture") else { return }

    let session: URLSession = URLSession(configuration: .default)

    
    /*
     아래의 dataTask 의 클로저는 백그라운드에서 동작할 클로저이다. 그러나 그 안에서 main 스레드에서 동작해야하는 코드는 DispatchQueue.main에 작성한다.
     클로저가 있는 새끼 스레드, 즉 백그라운드 스레드에서 노티피케이션 센터를 발송하면 백그라운드 스레드에서 ViewController.swift의
     didReceiveFriendsNotification을 호출하게 된다.
     */
    let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in

        if let error = error { print(error.localizedDescription) }
        guard let data = data else { return }

        do {
            let apiResponse: APIResponse = try JSONDecoder().decode(APIResponse.self, from: data)
            
            // 노티피케이션을 발송하는 아래 코드가 있는 스레드에서 발송을 하면, 받는 쪽도 해당 스레드에서 동작하게 된다.
            NotificationCenter.default.post(name: DidReceiveFriendsNotification, object: nil, userInfo: ["friends": apiResponse.results])

        } catch (let err) {
            print(err.localizedDescription)
        }

    }

    dataTask.resume()
}
