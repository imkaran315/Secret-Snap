//
//  HomeCollectionViewCell.swift
//  Secret Snap
//
//  Created by Karan Verma on 14/09/24.
//

import UIKit

protocol MediaCellDelegate : AnyObject{
    func openMediaAt(_ indexPath: IndexPath)
}

class HomeCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "HomeCollectionViewCell"
    
// MARK: - IB outlets
    
    @IBOutlet weak var thumbnailImgView: UIImageView!
    @IBOutlet weak var fileNamelbl: UILabel!
    
    @IBOutlet weak var thumbnailInfoLayer: UIView!
    @IBOutlet weak var optionsBtn: UIButton!
    weak var delegate : MediaCellDelegate?
    
// MARK: - Properties
    
    var mediaAsset : MediaAsset? = nil{
        didSet{
            configure()
            fileName = mediaAsset?.filePath ?? ""
        }
    }
    
    var fileName = ""
    var indexPath : IndexPath?
    
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
           
        
        if mediaAsset?.type == .video{
            // Get thumbnail made from video
            Task{
                let thumbnail = await FileHandler.shared.getThumbnailOfVideo(fileName)
                self.thumbnailImgView.image = thumbnail
            }
        }
        else{
            // Add image as thumbnail itself
            Task{
                if let imageData = FileHandler.shared.getFileFromDocumentsDirectory(fileName:fileName ){
                    self.thumbnailImgView.image = UIImage(data: imageData)
                }
            }
        }
        fileNamelbl.text = mediaAsset?.assetIdentifier ?? ""
    }
}

extension HomeCollectionViewCell{
//    override var isSelected: Bool{
//        didSet {
//            // Visual feedback on selection
//            UIView.animate(withDuration: 0.2) {
//                self.transform = self.isSelected ?
//                    CGAffineTransform(scaleX: 0.95, y: 0.95) :
//                    .identity
//                
//                self.layer.shadowOpacity = self.isSelected ? 0.3 : 0.5
//                self.thumbnailInfoLayer.isHidden = !self.isSelected
//            }
//        }
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.2) {
            self.transform = .identity
        }
        delegate?.openMediaAt(indexPath!)
    }
}
