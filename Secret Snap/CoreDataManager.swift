//
//  CoreDataManager.swift
//  Secret Snap
//
//  Created by Karan Verma on 14/09/24.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {

    static let shared = CoreDataManager()

    private init(){}
    
    let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistenContainer

    // Save media asset with file path and type
    
    func saveMediaAsset(_ mediaAsset: MediaAsset) {
        let context = persistentContainer.viewContext
        let mediaAssetEntity = MediaAssetEntity(context: context)

        mediaAssetEntity.filePath = mediaAsset.filePath
        mediaAssetEntity.assetIdentifier = mediaAsset.assetIdentifier
        mediaAssetEntity.creationDate = mediaAsset.creationDate
        mediaAssetEntity.type = mediaAsset.type.rawValue
        mediaAssetEntity.duration = mediaAsset.duration ?? 0

        saveContext()
    }

    // Fetch all media assets
    func fetchAllMediaAssets() -> [MediaAsset] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<MediaAssetEntity> = MediaAssetEntity.fetchRequest()

        do {
            let mediaAssetEntities = try context.fetch(fetchRequest)
            return mediaAssetEntities.compactMap { entity in
                guard let filePath = entity.filePath else {
                    return nil
                }
                return MediaAsset(
                    filePath: filePath,
                    assetIdentifier: entity.assetIdentifier,
                    type: MediaType(rawValue: entity.type ?? "photo") ?? .photo,
                    creationDate: entity.creationDate ?? Date(),
                    duration: entity.duration
                )
            }
        } catch {
            print("Failed to fetch media assets: \(error)")
            return []
        }
    }

    func deleteAllMediaAssets() {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = MediaAssetEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            print("All media assets deleted!")
        } catch {
            print("Failed to delete media assets: \(error)")
        }
    }
    
    private func saveContext() {
        let context = persistentContainer.viewContext
        do {
            try context.save()
            print("Media asset saved!")
        } catch {
            print("Failed to save media asset: \(error)")
        }
    }
}
