//
//  ImageViewController.swift
//  MyAlbum
//
//  Created by 박제균 on 2022/03/30.
//

import UIKit
import Photos

class ImageViewController: UIViewController {


    // MARK: - IBOutlets & Constants & Variables

    @IBOutlet weak var assetImageView: UIImageView!
    @IBOutlet weak var ImageScrollView: UIScrollView!
    @IBOutlet weak var activityBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var favoriteBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var deleteBarButtonItem: UIBarButtonItem!

    var asset: PHAsset!
    let imageManager: PHCachingImageManager = PHCachingImageManager()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        PHPhotoLibrary.shared().register(self)
        presentToolbar()
        setNavigationItemTitle()
        requestImage()
        setFavorite()
        setGestureRecognizer()
    }

    // MARK: - IBActions

    @IBAction func touchUpActivityBarButtonItem(_ sender: Any) {

        var activityImage: [UIImage] = []
        self.imageManager.requestImage(for: self.asset, targetSize: CGSize(width: self.asset.pixelWidth, height: self.asset.pixelHeight), contentMode: .aspectFill, options: nil) { image, _ in
            guard let imageToShare = image else { return }
            activityImage.append(imageToShare)
        }
        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: activityImage as [Any], applicationActivities: nil)
        self.present(activityViewController, animated: true)

    }

    @IBAction func touchUpFavoriteBarButtonItem(_ sender: Any) {

        PHPhotoLibrary.shared().performChanges {
            let favoriteRequest = PHAssetChangeRequest(for: self.asset)
            favoriteRequest.isFavorite = !(self.asset.isFavorite)
            OperationQueue.main.addOperation {
                self.setFavorite()
            }
        }

    }

    @IBAction func touchUpDeleteBarButtonItem(_ sender: Any) {

        PHPhotoLibrary.shared().performChanges {
            guard let asset = self.asset else { return }
            PHAssetChangeRequest.deleteAssets([asset] as NSArray)
        } completionHandler: { success, error in
            OperationQueue.main.addOperation {
                guard let navigationController = self.navigationController else { return }
                navigationController.popViewController(animated: true)
            }
        }
    }


    // MARK: - functions

    func presentToolbar() {
        guard let navigationController = navigationController else { return }
        navigationController.isToolbarHidden = false
    }

    func setNavigationItemTitle() {
        guard let asset = asset else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd a HH:mm:ss"
        guard let assetDate = asset.creationDate else { return }
        navigationItem.title = dateFormatter.string(from: assetDate)
    }

    func requestImage() {
        imageManager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFill, options: nil) { image, _ in
            self.assetImageView.image = image
        }
    }

    func setFavorite() {
        if asset.isFavorite {
            favoriteBarButtonItem.title = "❤️"
        } else {
            favoriteBarButtonItem.title = "🖤"
        }
    }

}

// MARK: - PHPhotoLibraryChangeObserver
extension ImageViewController: PHPhotoLibraryChangeObserver {

    func photoLibraryDidChange(_ changeInstance: PHChange) {

        OperationQueue.main.addOperation {
            guard let assetChange = changeInstance.changeDetails(for: self.asset) else { return }
            guard let updatedAsset = assetChange.objectAfterChanges else { return }
            self.asset = updatedAsset
            self.setFavorite()
        }

    }

}

// MARK: - Tap Gesture Recognizer

extension ImageViewController: UIGestureRecognizerDelegate {

    func setGestureRecognizer() {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(assetImageViewDidTap))
        self.assetImageView.addGestureRecognizer(tapGesture)
    }

    @objc func assetImageViewDidTap() {
        guard let navigationController = navigationController else { return }
        navigationController.navigationBar.isHidden.toggle()
        navigationController.toolbar.isHidden.toggle()
    }

}

// MARK: - ScrollView
extension ImageViewController: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.assetImageView
    }

}
