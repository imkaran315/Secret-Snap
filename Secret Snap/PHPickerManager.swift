//
//  PHPickerViewController.swift
//  Secret Snap
//
//  Created by Karan Verma on 14/09/24.
//

import PhotosUI
import UIKit

class PHPickerManager: PHPickerViewControllerDelegate {
    
    static let shared = PHPickerManager()
    
    private var completion: (([MediaAsset]) -> Void)?
    
    func presentPicker(from viewController: UIViewController, completion: @escaping ([MediaAsset]) -> Void) {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.selectionLimit = 30
        configuration.filter = .any(of: [.images, .videos]) // Allow images, videos, and live photos
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.completion = completion
        viewController.present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        var newAssets: [MediaAsset] = []
        let dispatchGroup = DispatchGroup()

        for result in results {
            dispatchGroup.enter()
            
            let assetIdentifier = result.assetIdentifier
            
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                // Handle Images
                result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
                    if let image = object as? UIImage {
                        let fileName = UUID().uuidString + ".jpg"
                        let result = FileHandler.shared.saveImageToDocumentsDirectory(image: image, fileName: fileName)
                        
                        if result == true{
                            let mediaAsset = MediaAsset(
                                filePath: fileName,
                                assetIdentifier: assetIdentifier,
                                type: .photo,
                                creationDate: .now,
                                duration: nil
                            )
                            newAssets.append(mediaAsset)
                        }
                        
                    }
                    dispatchGroup.leave()
                }
            } else if result.itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                // Handle Videos
                result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { (url, error) in
                    if let url = url {
                        // Save the video and fetch duration
                        if FileHandler.shared.saveVideoToDocumentsDirectory(url: url){
                            
                            let fileName = url.lastPathComponent
                            let duration = FileHandler.shared.getVideoDuration(url: url)
                            
                            let mediaAsset = MediaAsset(
                                filePath: fileName,
                                assetIdentifier: assetIdentifier,
                                type: .video,
                                creationDate: .now,
                                duration: duration
                            )
                            print(mediaAsset.self)
                            newAssets.append(mediaAsset)
                        }
                    }
                    dispatchGroup.leave()
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            picker.dismiss(animated: true)
            self.completion?(newAssets)
        }
    }
    
    
}
// MARK: - UIViewController Extension

extension UIViewController {
    func presentPHPicker(selectionLimit: Int = 0, completion: @escaping ([MediaAsset]) -> Void) {
        PHPickerManager.shared.presentPicker(from: self, completion: completion)
    }
}

//enum FileError: Error {
//    case conversionFailed
//    case saveFailed(Error)
//    case readFailed(Error)
//}
