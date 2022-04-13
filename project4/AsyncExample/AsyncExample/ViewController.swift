//
//  ViewController.swift
//  AsyncExample
//
//  Created by 박제균 on 2022/02/15.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBAction func touchUpDownloadButton(_ sender: UIButton) {
        // 이미지 다운로드 -> 이미지 뷰에 세팅
        // https://movieposterhd.com/wp-content/uploads/2019/03/Tom-Holland-Spider-man-Avengers-Endgame-Wallpaper-HD.jpg

        let imageURL: URL = URL(string: "https://movieposterhd.com/wp-content/uploads/2019/03/Tom-Holland-Spider-man-Avengers-Endgame-Wallpaper-HD.jpg")!

        // 이 작업이 끝나야 다음 코드 진행 가능, 동기 메서드...
//        let imageData: Data = try! Data.init(contentsOf: imageURL)

        OperationQueue().addOperation {
            let imageData: Data = try! Data.init(contentsOf: imageURL)
            let image: UIImage = UIImage(data: imageData)!

            OperationQueue.main.addOperation {
                self.imageView.image = image
            }
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

