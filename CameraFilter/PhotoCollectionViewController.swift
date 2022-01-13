//
//  PhotoCollectionViewController.swift
//  CameraFilter
//
//  Created by Javier Cueto on 13/01/22.
//

import UIKit
import Photos
import RxSwift


let cellId = "cellImages"
class PhotosCollectionViewController: UICollectionViewController {
    // MARK: - Properties
    private var images = [PHAsset]()
    private let selectedPhotoSubject = PublishSubject<UIImage>()
    
    var selectedPhoto: Observable<UIImage> {
        return selectedPhotoSubject.asObservable()
    }

    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        porpulatePhotos()
//        collectionView.register(ImagagesCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    // MARK: - Helpers
    private func porpulatePhotos(){
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            if status == .authorized {
                let assets = PHAsset.fetchAssets(with: .image, options: nil)
                assets.enumerateObjects { object, count, stop in
                    self?.images.append(object)
                }
                self?.images.reverse()
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
               
            }
        }
    }
    
    // MARK: - Actions
    
    // MARK: - Extension
}

extension PhotosCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? ImagagesCell else {
            fatalError("no hay cellda")
        }
        let asset = images[indexPath.row]
        let manager = PHImageManager.default()
        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: nil) { image, _ in
            DispatchQueue.main.async {
                cell.photoImageView.image = image
            }
        }
        
        

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = images[indexPath.row]
        let manager = PHImageManager.default()
        manager.requestImage(for: asset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFit, options: nil) { image, info in
            DispatchQueue.main.async {
                guard let info = info else { return }
                let isDegradedImage = info["PHImageResultIsDegradedKey"] as! Bool
                
                if !isDegradedImage {
                    if let image = image {
                        self.selectedPhotoSubject.onNext(image)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
