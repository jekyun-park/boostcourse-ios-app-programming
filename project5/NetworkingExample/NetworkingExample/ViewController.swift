//
//  ViewController.swift
//  NetworkingExample
//
//  Created by 박제균 on 2022/04/15.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {


    // MARK: - IBOutlet, Constants, Variables

    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier: String = "friendCell"
    var friends: [Friend] = []




    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard let url: URL = URL(string: "https://randomuser.me/api/?results=20&inc=name,email,picture") else { return }
        
        let session: URLSession = URLSession(configuration: .default)
        
        // 아래의 dataTask 의 클로저는 백그라운드에서 동작할 클로저이다. 그러나 그 안에서 main 스레드에서 동작해야하는 코드는 DispatchQueue.main에 작성한다.
        let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data:Data?, response:URLResponse?, error:Error?) in
            
            if let error = error { print(error.localizedDescription) }
            guard let data = data else { return }
            
            do {
                let apiResponse: APIResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                self.friends = apiResponse.results
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            } catch (let err) {
                print(err.localizedDescription)
            }

        }
                                 
        dataTask.resume()

    }



    // MARK: - Table View
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)

        let friend = self.friends[indexPath.row]

        cell.textLabel?.text = friend.name.full
        cell.detailTextLabel?.text = friend.email
        cell.imageView?.image = nil
        
        DispatchQueue.global().async {
            guard let imageURL: URL = URL(string: friend.picture.thumbnail) else { return  }
            guard let imageData: Data = try? Data(contentsOf: imageURL) else { return }
            
            DispatchQueue.main.async {
                
                if let index: IndexPath = tableView.indexPath(for: cell) {
                    if index.row == indexPath.row {
                        cell.imageView?.image = UIImage(data: imageData)
                        cell.setNeedsLayout()
                        cell.layoutIfNeeded()
                    }
                }
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        friends.count
    }


}



