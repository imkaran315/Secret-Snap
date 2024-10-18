//
//  HomeCollectionViewCell.swift
//  Secret Snap
//
//  Created by Karan Verma on 14/09/24.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "HomeCollectionViewCell"
    
// MARK: - IB outlets
    
    @IBOutlet weak var thumbnailImgView: UIImageView!
    @IBOutlet weak var fileNamelbl: UILabel!
    
    @IBOutlet weak var thumbnailInfoLayer: UIView!
    @IBOutlet weak var optionsBtn: UIButton!
    
// MARK: - Properties
    
    var mediaAsset : MediaAsset? = nil{
        didSet{
            configure()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnailInfoLayer.isHidden = true
    }

// MARK: - IB Actions
    
    @IBAction func optionsBtnPressed(_ sender: Any) {
        print("Options")
    }
}

extension HomeCollectionViewCell {
    private func configure(){
        print("configure")
        self.layer.cornerRadius = 4
        
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor // Light shadow color
        self.layer.shadowOpacity = 0.5 // Lower opacity for a softer shadow
        self.layer.shadowRadius = 6 // Increase radius for a more diffuse shadow
        self.layer.shadowOffset = CGSize(width: 0, height: 2) // Slight offset
           
        
        if let imageData = PHPickerManager.shared.getFileFromDocumentsDirectory(fileName: mediaAsset?.filePath ?? ""){
            self.thumbnailImgView.image = UIImage(data: imageData)
        }
        
        fileNamelbl.text = mediaAsset?.assetIdentifier ?? ""
    }
}
