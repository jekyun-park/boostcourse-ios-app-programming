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
        let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data:Data?, response:URLResponse?, error:Error?) in
            
            if let error = error { print(error.localizedDescription) }
            guard let data = data else { return }
            
            do {
                let apiResponse: APIResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                self.friends = apiResponse.results
                self.tableView.reloadData()
                
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

        guard let imageURL: URL = URL(string: friend.picture.thumbnail) else { return cell }
        guard let imageData: Data = try? Data(contentsOf: imageURL) else { return cell }
        cell.imageView?.image = UIImage(data: imageData)

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        friends.count
    }


}


