//
//  ViewController.swift
//  PhotoLibrary
//
//  Created by Eugene Berezin on 11/28/20.
//

import UIKit
import Photos

class ViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, UIImage>!
    let segmentedControl = UISegmentedControl(items: ["All", "Favorites"])
    let segmentedControlSizes = UISegmentedControl(items: ["Large", "Small", "Medium"])
    let tempArr = Array(arrayLiteral: UIImage())
    var photos = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureCollectionView()
        configureDataSource()
        updateData(on: photos)
        requestAuthorizationAndFetchPhotos()
        
    }
    
    func requestAuthorizationAndFetchPhotos() {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                self.fetchPhotos()
            default:
                print("Not authorosed")
                
            }
        }
    }
    
    func fetchPhotos() {
        let imgManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        if fetchResult.count > 0 {
            for i in 0 ..< fetchResult.count {
                imgManager.requestImage(for: fetchResult.object(at: i), targetSize: CGSize(width: 100, height: 200), contentMode: .aspectFit, options: requestOptions) { (image, _) in
                    if let image = image {
                        self.photos.append(image)
                        DispatchQueue.main.async {
                            self.updateData(on: self.photos)
                        }
                    }
                }
            }
        } else {
            
        }
            
        
    }
    
    func configureUI() {
        title = "Photos"
        view.backgroundColor = .systemBackground
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createThreeColumFloLayout(in: view))
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControlSizes.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        view.addSubview(segmentedControl)
        view.addSubview(collectionView)
        view.addSubview(segmentedControlSizes)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.cellID)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: segmentedControlSizes.topAnchor),
            segmentedControlSizes.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            segmentedControlSizes.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            segmentedControlSizes.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    


}

extension ViewController: UICollectionViewDelegate {
   private func createThreeColumFloLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding:CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth / 3
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)

        return flowLayout
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, UIImage>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, photo) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.cellID, for: indexPath) as! PhotoCell
            cell.imageView.image = self.photos[indexPath.item]
            print(self.photos)
            return cell
            
        })
    }
    
    func updateData(on photos: [UIImage]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, UIImage>()
        snapshot.appendSections([.main])
        snapshot.appendItems(photos)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
        
        
    }
    
}

