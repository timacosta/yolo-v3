//
//  ImageCellViewModel.swift
//  yolo-v3
//
//  Created by Tim Acosta on 29/8/21.
//

import Foundation

protocol ImageCellViewDelegate: AnyObject {
    func didLoadImage(with name: String)
}

class ImageCellViewModel {
    weak var viewDelegate: ImageCellViewDelegate?
    var testImage: TestImageModel?
    
    init(image: TestImageModel) {
        testImage = image
        if let name = testImage?.name {
            viewDelegate?.didLoadImage(with: name)
        }
    }
}
