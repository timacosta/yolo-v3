//
//  TestImageModel.swift
//  yolo-v3
//
//  Created by Tim Acosta on 29/8/21.
//

import Foundation

typealias TestImages = [TestImageModel]

struct TestImageModel {
    let name: String
    var recognizedObjects: String
    
    internal init(name: String, recognizedObjects: String) {
        self.name = name
        self.recognizedObjects = recognizedObjects
    }
   
}
