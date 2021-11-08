//
//  FlickerPhotos.swift
//  SearchFlickerImages
//
//  Created by Patel, V. (Vilasini) on 3/11/21.
//

import Foundation

struct PhotosList: Codable {
    let photos: FlickerPhotos?
    enum CodingKeys: String, CodingKey {
        case photos
    }
}

struct FlickerPhotos: Codable {
    let photo: [FlickerPhoto]?
    
    enum CodingKeys: String, CodingKey {
        case photo
    }
}

struct FlickerPhoto: Codable {
    let id: String?
    let secret: String?
    let server: String?
    let farm: Int?
    let title: String?

enum CodingKeys: String, CodingKey {
    case id, secret, server, title
    case farm
}
    
    func flickrImageURL() -> URL? {
        guard let farm = self.farm,
              let server = self.server,
              let secret = self.secret,
        let id = self.id else {
           return nil
        }
        let urlString = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg"
        
        if urlString.isValidUrl {
            return URL(string: urlString)
        }
        return nil
    }
}
    

