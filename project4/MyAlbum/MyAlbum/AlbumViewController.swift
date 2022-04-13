//
//  AlbumViewController.swift
//  MyAlbum
//
//  Created by 박제균 on 2022/02/23.
//


import Photos
import UIKit

final class AlbumViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var albumCollectionView: UICollectionView!
    var fetchResults: [PHAssetCollection] = []
    let albumManager: PHCachingImageManager = PHCachingImageManager()
    let cellIdentifier: String = "albumCollectionViewCell"

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideToolbar()
        getAuthorization()

    }

    // MARK: - functions

    func requestAlbumCollections() {

        // 사용자 커스텀 앨범
        let userCreatedAlbums: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)

        // 기본 앨범(카메라롤, 즐겨찾기, 셀피 등)

        // recents
        let recentsAlbum: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)

        // favorites
        let favoritesAlbum: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: nil)


        // 위에서 불러온 앨범들을 fetchResults 배열에 합친다.

        for i in 0..<userCreatedAlbums.count {
            self.fetchResults.append(userCreatedAlbums.object(at: i))
        }

        for i in (0..<recentsAlbum.count) {
            self.fetchResults.append(recentsAlbum.object(at: i))
        }

        for i in 0..<favoritesAlbum.count {
            self.fetchResults.append(favoritesAlbum.object(at: i))
        }

    }

    func getAuthorization() {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()

        switch authorizationStatus {

        case .authorized:
            self.requestAlbumCollections()
            OperationQueue.main.addOperation {
                self.albumCollectionView.reloadData()
            }
        case .denied:
            print("사용자가 접근 거부하였음")
        case .notDetermined:
            print("사용자가 아직 응답하지 않음")
            PHPhotoLibrary.requestAuthorization({ (authorizationStatus) in
                switch authorizationStatus {
                case .denied:
                    print("사용자가 접근 거부")
                case .authorized:
                    print("접근 허가되었음")
                    self.requestAlbumCollections()
                    OperationQueue.main.addOperation {
                        self.albumCollectionView.reloadData()
                    }
                default: break
                }
            })
        case .restricted:
            print("권한 없음")
        case .limited:
            print("권한 제한됨")
        @unknown default:
            break
        }

        if authorizationStatus == .authorized {
            PHPhotoLibrary.shared().register(self)
        }
    }

    func hideToolbar() {
        navigationController?.toolbar.isHidden = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let photoViewController = segue.destination as? PhotoListViewController else { return }

        guard let cell = sender as? AlbumCollectionViewCell else { return }

        guard let index = albumCollectionView.indexPath(for: cell) else { return }

        photoViewController.album = fetchResults[index.item]
    }
}

// MARK: - PHPhotoLibraryChangeObserver

extension AlbumViewController: PHPhotoLibraryChangeObserver {

    func photoLibraryDidChange(_ changeInstance: PHChange) {

        for (index, _) in fetchResults.enumerated() {
            let album = fetchResults[index]

            guard let changes = changeInstance.changeDetails(for: album) else {
                continue
            }

            fetchResults[index] = changes.objectAfterChanges ?? fetchResults[index]
        }

        OperationQueue.main.addOperation {
            self.albumCollectionView.reloadData()
        }

    }

}


// MARK: - Collection View
extension AlbumViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fetchResults.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let albumCollectionViewCell: AlbumCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as? AlbumCollectionViewCell else {
            return UICollectionViewCell()
        }

        let album = self.fetchResults[indexPath.item]
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchedAlbum = PHAsset.fetchAssets(in: album, options: fetchOptions)

        let coverImage = fetchedAlbum.firstObject
        albumCollectionViewCell.albumName.text = album.localizedTitle
        albumCollectionViewCell.numberOfPhotos.text = String(fetchedAlbum.count)

        guard let coverAsset = coverImage else {
            albumCollectionViewCell.thumbnailImage.image = UIImage(systemName: "photo.circle.fill")
            return albumCollectionViewCell
        }

        albumManager.requestImage(for: coverAsset, targetSize: CGSize(width: 50, height: 50), contentMode: .aspectFill, options: nil, resultHandler: {
                image, _ in albumCollectionViewCell.thumbnailImage.image = image
            })

        return albumCollectionViewCell

    }

}

// MARK: - collection View layout
extension AlbumViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize() }
        flowLayout.sectionInset = UIEdgeInsets.zero
        let width: CGFloat = (collectionView.frame.width - flowLayout.minimumInteritemSpacing * 3)

        return CGSize(width: width / 2, height: width * (2 / 3))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
