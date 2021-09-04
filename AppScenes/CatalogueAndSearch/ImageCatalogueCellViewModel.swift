//
//  ImageCellViewModel.swift
//  ObjectRecognition
//
//  Created by José Sancho on 18/4/21.
//

import Foundation

protocol ImageCatalogueCellViewDelegate: class {
    func imageLoaded(imageName: String)
}

class ImageCellViewModel {
    weak var viewDelegate: ImageCatalogueCellViewDelegate?
    var testImage: TestImageModel?
    
    
    init(image: TestImageModel) {
        self.testImage = image
    }
    
    func loadImageData() {
        
    }
}
