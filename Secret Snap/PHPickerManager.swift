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
                        if let result = self?.saveImageToDocumentsDirectory(image: image, fileName: fileName), result == true{
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
                        if self.saveVideoToDocumentsDirectory(url: url){
                            
                            let fileName = url.lastPathComponent
                            let duration = self.getVideoDuration(url: url)
                            
                            let mediaAsset = MediaAsset(
                                filePath: fileName,
                                assetIdentifier: assetIdentifier,
                                type: .video,
                                creationDate: .now,
                                duration: duration
                            )
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
    
    func saveImageToDocumentsDirectory(image: UIImage, fileName: String) -> Bool {
        guard let data = image.jpegData(compressionQuality: 1.0) ?? image.pngData() else {
            return false
        }
        
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent(fileName)

        do {
            try data.write(to: fileURL)
            print("Image saved successfully at: \(fileURL.path)")
            return true
        } catch {
            print("Error saving image: \(error.localizedDescription)")
            return false
        }
    }

    func saveVideoToDocumentsDirectory(url: URL) -> Bool {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileNameWithExtension = url.lastPathComponent
        let destinationURL = documentsURL.appendingPathComponent(fileNameWithExtension)
        
        do {
            try fileManager.copyItem(at: url, to: destinationURL)
            print("Video saved successfully at: \(destinationURL.path)")
            return true
        } catch {
            print("Error saving video: \(error.localizedDescription)")
            return false
        }
    }

    func getFileFromDocumentsDirectory(fileName: String) -> Data? {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent(fileName)
        
        do {
            let fileData = try Data(contentsOf: fileURL)
            return fileData
        } catch {
            print("Error reading file: \(error.localizedDescription)")
            return nil
        }
    }
    
    func getVideoDuration(url: URL) -> Double {
        let asset = AVAsset(url: url)
        let duration = asset.duration
        let durationInSeconds = CMTimeGetSeconds(duration)
        
        print("Video duration: \(durationInSeconds) seconds")
        return durationInSeconds
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
