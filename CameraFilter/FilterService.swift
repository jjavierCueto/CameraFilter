//
//  FilterService.swift
//  CameraFilter
//
//  Created by Javier Cueto on 13/01/22.
//

import UIKit
import CoreImage
import RxSwift

class FilterService {
    // MARK: - Properties
    private var context: CIContext
    
    // MARK: - Life cycle
    
    init() {
        self.context = CIContext()
    }
    
    // MARK: - Helpers
    
    func applyFilter(to inputImage: UIImage) -> Observable<UIImage> {
        return Observable<UIImage>.create { observer in
            self.applyFilter(to: inputImage) { filteredImage in
                observer.onNext(filteredImage)
            }
            return Disposables.create()
        }
    }
    
    private func applyFilter(to inputImage: UIImage, completion: @escaping ((UIImage) -> ())) {
        let filter = CIFilter(name: "CICMYKHalftone")!
        filter.setValue(5.0, forKey: kCIInputWidthKey)
        
        if let sourceImage = CIImage(image: inputImage) {
            filter.setValue(sourceImage, forKey: kCIInputImageKey)
            if let cgimg = self.context.createCGImage(filter.outputImage!, from: filter.outputImage!.extent) {
                let processedImage = UIImage(cgImage: cgimg, scale: inputImage.scale, orientation: inputImage.imageOrientation)
                completion(processedImage)
            }
        }
    }
    // MARK: - Actions
    
    // MARK: - Extension
}
