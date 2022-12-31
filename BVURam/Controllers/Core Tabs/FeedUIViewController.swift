//
//  CameraViewController.swift
//  BVURam
//
//  Created by Vardhan Chopada on 12/22/22.
//

import UIKit

struct VideoModel {
   let caption: String
   let username: String
   let audioTrackName: String
   let videoFileName: String
   let videoFileFormat: String
}

class FeedUIViewController: UIViewController {
    
   
    
    private var collectionView: UICollectionView?
    
    private var data = [VideoModel]()

    override func viewDidLoad() {
        
        for _ in 0..<10 {
            let model = VideoModel(caption: "Bark Bark", username: "@yomama", audioTrackName: "bitches", videoFileName: "video1", videoFileFormat: "mp4")
            data.append(model)
        }
        
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
       
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width, height: view.frame.size.height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView?.contentInsetAdjustmentBehavior = .never
        collectionView?.register(FeedVideoCollectionViewCell.self, forCellWithReuseIdentifier: FeedVideoCollectionViewCell.identifier)
        collectionView?.isPagingEnabled = true
        collectionView?.dataSource = self
        view.addSubview(collectionView!)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
}

extension FeedUIViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = data[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedVideoCollectionViewCell.identifier, for: indexPath) as! FeedVideoCollectionViewCell
        cell.configure(with: model)
        return cell
    }
}
