//
//  ViewController.swift
//  SearchFlickerImages
//
//  Created by Patel, V. (Vilasini) on 3/11/21.
//

import UIKit
import Combine

private enum DefaultViewStatus {
    case show
    case hide
    case defaultState
}

class PhotosViewController: UIViewController {
    
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var searchPhotos: UISearchBar!
    @IBOutlet weak var defaultLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let itemsPerRow: CGFloat = 3
    var subscriptions = Set<AnyCancellable>()
    let photosViewModel = PhotosViewModel()
    private let reuseIdentifier = "FlickerPhotoCell"
    private let sectionInsets = UIEdgeInsets(
        top: 0,
        left: 0,
        bottom: 0,
        right: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultViewRequireTo(display: DefaultViewStatus.defaultState)
        handleFlickerPhotosSubscription()
    }
    
    private func defaultViewRequireTo(display: DefaultViewStatus) {
        switch display {
        case .defaultState:
            self.activityIndicator.isHidden = self.defaultLabel.isHidden == true
        case .hide:
            if(self.photosViewModel.flickerPhotos.value.count == 0){
                self.defaultLabel.isHidden = false
            }
            self.activityIndicator.isHidden = true
        case .show:
            self.defaultLabel.isHidden = true
            self.activityIndicator.isHidden = false
        }
    }
    
    private func handleFlickerPhotosSubscription() {
        self.photosViewModel.flickerPhotos.sink { [unowned self] (_) in
            self.activityIndicator.stopAnimating()
            defaultViewRequireTo(display: DefaultViewStatus.hide)
            self.photosCollectionView.reloadData()
        }.store(in: &subscriptions)
    }
    
    override func viewWillLayoutSubviews() {
       super.viewWillLayoutSubviews()
       self.photosCollectionView.collectionViewLayout.invalidateLayout()
    }
}

extension PhotosViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosViewModel.flickerPhotos.value.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier,
            for: indexPath) as! FlickerPhotoCell
        let photoValue = photosViewModel.flickerPhotos.value[indexPath.row]
        let viewModel = FlickerPhotoCellViewModel(flickerPhoto: photoValue)
        cell.configureCell(viewModel: viewModel)
        return cell
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(itemsPerRow - 1))
        
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(itemsPerRow))
        
        return CGSize(width: size, height: size)
        
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return sectionInsets.left
    }
}

extension PhotosViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            return
        }
        self.photosViewModel.searchText.send(searchText)
        searchBar.resignFirstResponder()
        defaultViewRequireTo(display: DefaultViewStatus.show)
    }
}
