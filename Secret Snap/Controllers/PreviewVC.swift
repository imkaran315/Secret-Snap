//
//  PreviewVC.swift
//  Secret Snap
//
//  Created by Karan Verma on 29/11/24.
//

import UIKit
import AVKit

class PreviewVC: UIViewController {
    
    var mediaAsset : MediaAsset?
    var imageView = UIImageView()
    var player : AVPlayer?
    var playerLayer : AVPlayerLayer?
    
    private let backButton : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        btn.tintColor = .white
        btn.alpha = 0.8
        return btn
    }()
    
    var mediaType : MediaType {
        if let mediaAsset{
            return mediaAsset.type
        }
        return .photo
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if mediaType == .video{
            setupPlayer()
        }
        else{
            setupImage()
        }
        setupUI()
    }
    
    private func setupUI(){
        view.backgroundColor = .black
        
        backButton.frame = CGRect(x: 10, y: 60, width: 30, height: 30)
        backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        view.addSubview(backButton)
    }
    
    @objc func handleBackButton(){
        HapticManager.shared.generateSoftImpactHaptic()
        self.dismiss(animated: true)
    }
    
    private func setupPlayer(){
        print("setup player")
        guard let mediaAsset else {return}
        let fileURL = FileHandler.shared.getFileURL(mediaAsset.filePath)
        
        player = AVPlayer(url: fileURL)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspect
        playerLayer?.frame = view.bounds
        
        if let playerLayer{
            view.layer.addSublayer(playerLayer)
        }
        
        imageView.isHidden = true
        playerLayer?.isHidden = false
        
        player?.play()
    }
    
    private func setupImage(){
        print("setup Image")
        guard let mediaAsset else {return}
        imageView.frame = view.bounds
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        imageView.isHidden = false
        playerLayer?.isHidden = true
        
        if let imageData = FileHandler.shared.getFileFromDocumentsDirectory(fileName: mediaAsset.filePath){
            self.imageView.image = UIImage(data: imageData)
        }
    }
    
    deinit {
        player?.pause()
        player = nil
        playerLayer?.removeFromSuperlayer()
    }
}


