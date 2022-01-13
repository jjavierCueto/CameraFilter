//
//  ViewController.swift
//  CameraFilter
//
//  Created by Javier Cueto on 13/01/22.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var button: UIButton!
    
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigation = segue.destination as? UINavigationController, let photoVC = navigation.viewControllers.first as? PhotosCollectionViewController else { return }
        
        photoVC.selectedPhoto.subscribe { photo in
            DispatchQueue.main.async {
                self.photoImageView.image = photo
            }
        }.disposed(by: disposeBag)

        
    }
    
    @IBAction func applyFilterButton() {
        guard let sourceImage = self.photoImageView.image else { return }
        let filter = FilterService()
        
        filter.applyFilter(to: sourceImage).subscribe { image in
                self.photoImageView.image = image
        }.disposed(by: disposeBag)
        
    }



}

