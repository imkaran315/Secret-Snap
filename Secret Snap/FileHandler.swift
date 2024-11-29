//
//  FileManager.swift
//  Secret Snap
//
//  Created by Karan Verma on 28/11/24.
//


import UIKit
import AVKit

class FileHandler {
    static let shared = FileHandler()
    private init(){}
    
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
        let fileURL = getFileURL(fileName)
        do {
            let fileData = try Data(contentsOf: fileURL)
            return fileData
        } catch {
            print("Error reading file: \(error.localizedDescription)")
            return nil
        }
    }
    
    func getThumbnailOfVideo(_ fileName: String) async -> UIImage? {
        let fileURL = getFileURL(fileName)
        let asset = AVURLAsset(url: fileURL)
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        imgGenerator.appliesPreferredTrackTransform = true
        
        do {
            let (cgImg, _) = try await imgGenerator.image(at: CMTime(value: 1, timescale: 600))
            return UIImage(cgImage: cgImg)
        } catch let err {
            print(" ERROR: Could not generate CGImage from Asset.\(err.localizedDescription)")
            return nil
        }
    }
    
    func getVideoDuration(url: URL) -> Double {
        let asset = AVURLAsset(url: url)
        let duration = asset.duration
        let durationInSeconds = CMTimeGetSeconds(duration)
        
        print("Video duration: \(durationInSeconds) seconds")
        return durationInSeconds
    }
    
    func getFileURL(_ name: String) -> URL{
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent(name)
        return fileURL
    }
}
