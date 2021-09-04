//
//  ImageDetailViewController.swift
//  yolo-v3
//
//  Created by Tim Acosta on 29/8/21.
//

import UIKit
import AVFoundation
import Vision

class ImageDetailViewController: UIViewController {
    @IBOutlet weak var detailImageView: UIImageView?
    @IBOutlet weak var objectsLabel: UILabel!
    
    let viewModel: ImageDetailViewModel
    
    init(viewModel: ImageDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        viewModel.predict()
    }

    private func configureViewController() {
        title = "Image detection"
        detailImageView?.image = UIImage(data: viewModel.imageData)
    }
    
    func visualizeObservations(observations: [VNDetectedObjectObservation], objectsName: String) {
        DispatchQueue.main.async {
            guard let image = self.detailImageView?.image else { return }
            
            let imageSize = image.size
            var imageTransform = CGAffineTransform.identity.scaledBy(x: 1, y: -1).translatedBy(x: 0, y: -imageSize.height)
            imageTransform = imageTransform.scaledBy(x: imageSize.width, y: imageSize.height)
            UIGraphicsBeginImageContextWithOptions(imageSize, true, 0)
           
            let graphicsContext = UIGraphicsGetCurrentContext()
            image.draw(in: CGRect(origin: .zero,
                                  size: imageSize))
            graphicsContext?.saveGState()
            graphicsContext?.setLineJoin(.round)
            graphicsContext?.setLineWidth(6.0)
            graphicsContext?.setFillColor(red: 1, green: 1, blue: 0, alpha: 0.3)
            graphicsContext?.setStrokeColor(UIColor.blue.cgColor)
            
            observations.forEach { (observation) in
            
                let observationBounds = observation.boundingBox.applying(imageTransform)
                graphicsContext?.addRect(observationBounds)
            }
            if objectsName.count == 0 {
                self.objectsLabel.text = "No element detected"
            } else {
                self.objectsLabel.text = objectsName
            }
            graphicsContext?.drawPath(using: CGPathDrawingMode.fillStroke)
            graphicsContext?.restoreGState()
            
            let drawnImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            self.detailImageView?.image = drawnImage
        }
    }
    
}

extension ImageDetailViewController: ImageDetailViewDelegate {
    func didPredict(observations: [VNDetectedObjectObservation], objectsName: String) {
        visualizeObservations(observations: observations, objectsName: objectsName)
    }
}


