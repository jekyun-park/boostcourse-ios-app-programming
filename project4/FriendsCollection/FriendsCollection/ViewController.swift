//
//  ViewController.swift
//  FriendsCollection
//
//  Created by 박제균 on 2022/02/22.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

//    var numberOfCell: Int = 10
    let cellIdentifier: String = "cell"
    var friends: [Friend] = []
    @IBOutlet weak var collectionView: UICollectionView!


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.numberOfCell
        return self.friends.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: FriendCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as? FriendCollectionViewCell else {
            return UICollectionViewCell()
        }

        let friend: Friend = self.friends[indexPath.item]

        cell.nameAgeLabel.text = friend.nameAndAge
        cell.addressLabel.text = friend.fullAddress

        return cell
    }

//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.numberOfCell += 1
//        collectionView.reloadData()
//    }




    override func viewDidLoad() {
        super.viewDidLoad()

        let flowLayout: UICollectionViewFlowLayout
        flowLayout = UICollectionViewFlowLayout()

        // inset을 없애고, item사이의 최소간격 10포인트 이상, 아이템 라인간 최소간격 10포인트 이상
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10

        // 화면에 2개씩 배치하기 위해

        let halfWidth: CGFloat = UIScreen.main.bounds.width / 2.0
        // 오토레이아웃에 따라 셀 사이즈가 가변적일 수 있기 때문에 예상크기를 지정해줌
        flowLayout.estimatedItemSize = CGSize(width: halfWidth - 30, height: 90)

        self.collectionView.collectionViewLayout = flowLayout


        let jsonDecoder: JSONDecoder = JSONDecoder()
        guard let dataAsset: NSDataAsset = NSDataAsset(name: "friends") else {
            return
        }

        do {
            self.friends = try jsonDecoder.decode([Friend].self, from: dataAsset.data)
        } catch {
            print(error.localizedDescription)
        }

        self.collectionView.reloadData()

    }


}

