//
//  FlickerPhotoCellViewModel.swift
//  SearchFlickerImages
//
//  Created by Patel, V. (Vilasini) on 7/11/21.
//

import Foundation
import Combine

class FlickerPhotoCellViewModel {
    
    var imageUrl: URL?
    var imageTitle: String = ""
    let flickerPhoto: FlickerPhoto
    let flickerAPI = FlickerPhotoAPI()
    
    init(flickerPhoto: FlickerPhoto) {
        self.flickerPhoto = flickerPhoto
        self.imageUrl = self.flickerPhoto.flickrImageURL()
        self.imageTitle = self.flickerPhoto.title ?? ""
    }
}
