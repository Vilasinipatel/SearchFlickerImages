//
//  FlickerPhotoCell.swift
//  SearchFlickerImages
//
//  Created by Patel, V. (Vilasini) on 8/11/21.
//

import UIKit
import Combine

class FlickerPhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageTitle: UILabel!
    
    var subscriber: AnyCancellable?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        subscriber?.cancel()
        imageView?.image = nil
        imageTitle.text = ""
    }
    
    func configureCell(viewModel: FlickerPhotoCellViewModel) {
        imageTitle.text = viewModel.imageTitle
        if let imageURL = viewModel.imageUrl {
            subscriber = viewModel.flickerAPI.imageDownloadPublisher(for:imageURL, errorImage: UIImage()).assign(to: \.imageView.image, on: self)
        }
    }
}
