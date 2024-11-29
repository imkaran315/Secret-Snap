//
//  ViewController.swift
//  Secret Snap
//
//  Created by Karan Verma on 07/09/24.
//

import UIKit


class HomeVC: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    var mediaAssets: [MediaAsset] = []{
        didSet{
            print("medAssets updated")
            collectionView.reloadData()
        }
    }
    
    var cellSize: CGSize {
        let width = (view.frame.width - 20) / 2
        return CGSize(width: width, height: width)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fetchData()
    }
    
    
    // MARK: - IBAction
    @IBAction func addBtnPressed(_ sender: Any) {
        print("add")
        HapticManager.shared.generateMediumImpactHaptic()
        self.presentPHPicker(selectionLimit: 10) { assets in
            self.mediaAssets.append(contentsOf: assets)
            for asset in assets {
                CoreDataManager.shared.saveMediaAsset(asset)
            }
            self.fetchData()
        }
    }
}

extension HomeVC{
//    private func showLockScreen(){
//        print("Show Lock Screen")
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LockScreenVC")
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true, completion: nil)
//    }
    
    private func fetchData(){
        print("fetch Data")
        DispatchQueue.main.async {
            self.mediaAssets = CoreDataManager.shared.fetchAllMediaAssets()
        }
    }
}

// MARK: - CollectionView Setup
extension HomeVC {
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = cellSize
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.sectionInset = .init(top: 10, left: 5, bottom: 10, right: 5)
        
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.register(UINib(nibName: HomeCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: "HomeCollectionViewCell")
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell else {return UICollectionViewCell()}
        let mediaAsset = mediaAssets[indexPath.row]
        
        cell.mediaAsset = mediaAsset
        cell.indexPath = indexPath
        cell.delegate = self
        
        return cell
    }
}

extension HomeVC : MediaCellDelegate{
    func openMediaAt(_ indexPath: IndexPath) {
        let vc = PreviewVC()
        vc.mediaAsset = mediaAssets[indexPath.row]
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}
