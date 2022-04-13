//
//  ImageZoomViewController.swift
//  PhotosExample
//
//  Created by 박제균 on 2022/02/16.
//

import UIKit
import Photos

class ImageZoomViewController: UIViewController, UIScrollViewDelegate {

    var asset: PHAsset!
    let imageManager: PHCachingImageManager = PHCachingImageManager()

    @IBOutlet weak var imageView: UIImageView!

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        imageManager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
                self.imageView.image = image
            })

    }
}
