//
//  MediaAsset.swift
//  Secret Snap
//
//  Created by Karan Verma on 14/09/24.
//

import Foundation
import UIKit
import PhotosUI

struct MediaAsset {
    let filePath: String // Path where the media (image, video, live photo components) is saved
    let assetIdentifier: String? // Asset identifier (for fetching from Photos library)
    let type: MediaType // Enum to specify whether it's a photo, video, or live photo
    let creationDate: Date // Date when the media was created
    let duration: Double? // Duration (for videos)
}

enum MediaType: String {
    case photo = "photo"
    case video = "video"
    case livePhoto = "livePhoto"
}

