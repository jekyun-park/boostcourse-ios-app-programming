//
//  PhotoListViewController.swift
//  MyAlbum
//
//  Created by 박제균 on 2022/02/24.
//

import Photos
import UIKit

class PhotoListViewController: UIViewController {

    // MARK: - IBOutlets & Constants & Variables

    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var selectBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var activityBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var latestBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var deleteBarButtonItem: UIBarButtonItem!

    var album: PHAssetCollection!
    var fetchResult: PHFetchResult<PHAsset>!
    var selectedPhotos: Set<PHAsset> = []
    var isSelectingMode: Bool = false

    let photoManager: PHCachingImageManager = PHCachingImageManager()
    let cellIdentifier: String = "photoCollectionViewCell"

    // MARK: - Life Cycle
    override func viewDidLoad() {

        super.viewDidLoad()
        PHPhotoLibrary.shared().register(self)
        setupNavigationController()
        requestPhotos(false)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PHPhotoLibrary.shared().register(self)
        requestPhotos(false)
        reloadPhotoCollectionViewData()
    }


    // MARK: - IBActions

    @IBAction func touchUpSelectBarButtonItem() {

        let albumName = album.localizedTitle
        
        
        if !isSelectingMode {
            
            photoCollectionView.allowsMultipleSelection = true
            selectBarButtonItem.title = "취소"
            navigationItem.title = "항목 선택"

            OperationQueue.main.addOperation {
                self.photoCollectionView.reloadData()
            }

        } else {
            
            selectBarButtonItem.title = "선택"
            navigationItem.title = albumName
            activityBarButtonItem.isEnabled = false
            deleteBarButtonItem.isEnabled = false

            guard let selectedCells = photoCollectionView.indexPathsForSelectedItems else { return }

            if selectedCells.count > 0 {
                selectedCells.forEach {
                    guard let cell = photoCollectionView.cellForItem(at: $0) as? PhotoCollectionViewCell else { return }
                    cell.alpha = 1
                    cell.layer.borderWidth = 0
                    cell.layer.borderColor = UIColor.white.cgColor
                }
                selectedPhotos.removeAll()
            }
            photoCollectionView.allowsMultipleSelection = false
        }
        
        isSelectingMode.toggle()
        navigationItem.hidesBackButton.toggle()
        latestBarButtonItem.isEnabled.toggle()
    }

    @IBAction func touchUpLatestBarButtonItem(_ sender: Any) {

        if latestBarButtonItem.title == "과거순" {
            latestBarButtonItem.title = "최신순"
            OperationQueue.main.addOperation {
                self.requestPhotos(false)
                self.photoCollectionView.reloadData()
            }
        } else {
            latestBarButtonItem.title = "과거순"
            OperationQueue.main.addOperation {
                self.requestPhotos(true)
                self.photoCollectionView.reloadData()
            }
        }

    }

    @IBAction func touchUpActivityBarButtonItem(_ sender: Any) {

        OperationQueue.main.addOperation {
            var images: [UIImage] = []
            for asset in self.selectedPhotos {
                self.photoManager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .default, options: nil) { image, _ in
                    guard let uiImageAsset = image else { return }
                    images.append(uiImageAsset)
                }
            }

            let activityViewContoroller = UIActivityViewController(activityItems: images, applicationActivities: nil)
            self.present(activityViewContoroller, animated: true, completion: nil)
        }

    }

    @IBAction func touchUpDeleteBarButtonItem(_ sender: Any) {

        let assetsToDelete: [PHAsset] = Array(selectedPhotos)
        guard let indexOfSelectedCells = photoCollectionView.indexPathsForSelectedItems else { return }

        // 데이터 삭제 이후 컬렉션뷰 아이템 삭제

        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.deleteAssets(assetsToDelete as NSArray)
        } completionHandler: { sucess, error in
            self.selectedPhotos.removeAll()

            OperationQueue.main.addOperation {
                self.requestPhotos(false)
                self.photoCollectionView.deleteItems(at: indexOfSelectedCells)
                self.photoCollectionView.reloadData()
            }
        }
        touchUpSelectBarButtonItem()
    }


// MARK: - functions

    func reloadPhotoCollectionViewData() {
        OperationQueue.main.addOperation {
            self.photoCollectionView.reloadData()
        }
    }

    func requestPhotos(_ isLatest: Bool) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: isLatest)]
        self.fetchResult = PHAsset.fetchAssets(in: album, options: fetchOptions)
    }


    func setupNavigationController() {
        navigationItem.title = album.localizedTitle
        guard let navigationController = navigationController else { return }
        navigationController.toolbar.isHidden = false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let imageViewController = segue.destination as? ImageViewController else { return }
        guard let asset = sender as? PHAsset else { return }
        imageViewController.asset = asset
    }

}

// MARK: - PHPhotoLibraryChangeObserver

extension PhotoListViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {

        guard let albumChanges = changeInstance.changeDetails(for: album) else { return }
        guard let changes = changeInstance.changeDetails(for: self.fetchResult) else { return }

        self.fetchResult = changes.fetchResultAfterChanges
        self.album = albumChanges.objectAfterChanges

        guard let insertedIndexes = changes.insertedIndexes else { return }
        let insertedIndexPath = IndexPath(indexes: insertedIndexes).map { IndexPath(indexes: [0, $0]) }

        OperationQueue.main.addOperation {
            self.photoCollectionView.insertItems(at: insertedIndexPath)
            self.photoCollectionView.reloadData()
        }

        guard let removedIndexes = changes.removedIndexes else { return }
        let removedIndexPath = IndexPath(indexes: removedIndexes).map { IndexPath(indexes: [0, $0]) }

        OperationQueue.main.addOperation {
            self.photoCollectionView.deleteItems(at: removedIndexPath)
            self.photoCollectionView.reloadData()
        }

    }
    
}




// MARK: - collection View
extension PhotoListViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return self.fetchResult.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let photoCollectionViewCell: PhotoCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }

        let asset: PHAsset = fetchResult[indexPath.item]

        photoManager.requestImage(for: asset, targetSize: CGSize(width: 50, height: 50), contentMode: .aspectFill, options: nil) { image, _ in
            photoCollectionViewCell.photoImageView.image = image
        }

        return photoCollectionViewCell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let cell = collectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell else {
            return
        }

        if isSelectingMode {

            guard let numberOfSelectedCells = collectionView.indexPathsForSelectedItems?.count else { return }
            selectedPhotos.update(with: fetchResult[indexPath.item])

            navigationItem.title = "\(numberOfSelectedCells)장 선택"

            if selectedPhotos.count > 0 {
                activityBarButtonItem.isEnabled = true
                deleteBarButtonItem.isEnabled = true
            }
            cell.alpha = 0.5
            cell.layer.borderWidth = 2.0
            cell.layer.borderColor = UIColor.black.cgColor

        } else {
            let asset = fetchResult[indexPath.item]
            performSegue(withIdentifier: "presentImageViewController", sender: asset)
        }


    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

        guard let cell = collectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell else {
            return
        }

        if navigationItem.title != album.localizedTitle {

            guard let numberOfSelectedCells = collectionView.indexPathsForSelectedItems?.count else { return }

            selectedPhotos.remove(fetchResult[indexPath.item])

            if numberOfSelectedCells == 0 { navigationItem.title = "항목 선택" } else {
                navigationItem.title = "\(numberOfSelectedCells)장 선택"
            }

            if selectedPhotos.count > 0 {
                activityBarButtonItem.isEnabled = true
                deleteBarButtonItem.isEnabled = true
            } else {
                activityBarButtonItem.isEnabled = false
                deleteBarButtonItem.isEnabled = false
            }

            cell.alpha = 1
            cell.layer.borderWidth = 0
            cell.layer.borderColor = UIColor.white.cgColor
        }
    }

}

// MARK: - collection View layout
extension PhotoListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize() }

        let numberOfCells: CGFloat = 3

        let width: CGFloat = collectionView.frame.size.width - (flowLayout.minimumInteritemSpacing * (numberOfCells - 1))

        return CGSize(width: CGFloat(Int(width / numberOfCells)), height: CGFloat(Int(width / numberOfCells)))
    }


}
