//
//  FlickerPhotosService.swift
//  SearchFlickerImages
//
//  Created by Patel, V. (Vilasini) on 3/11/21.
//

import Foundation
import UIKit
import Combine

struct FlickerPhotoAPI {

    /// Calling flicker API to get list of photos detail based on searched keyword
    /// - Parameters:
    ///   - searchedText: Search text value which is entered in searchbar
    /// - Returns:
    ///   - AnyPublisher<PhotosList, FlickerError>: Publisher passes resulted photolist or error and completion value
    
        func photosPublisher(searchedText: String) -> AnyPublisher<PhotosList, FlickerError> {
                        
        guard let url = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(APIKeys.flickerAPI)&text=\(searchedText.trimmingCharacters(in: .whitespacesAndNewlines))&format=json&nojsoncallback=1") else
        {
            return Fail(error: FlickerError.invalidURL).eraseToAnyPublisher()
        }
            
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: PhotosList.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .mapError( FlickerError.map(_:))
            .eraseToAnyPublisher()
    }
    
    /// Downloading flicker image data, convert it into UIImage
    /// - Parameters:
    ///   - url: image url for individual photo which need to get downloaded
    ///   - errorImage: refer default image value (placeholder)
    /// - Returns:
    ///   - AnyPublisher<UIImage?, Never>: Publisher passes resulted UIimage and completion value
    
    func imageDownloadPublisher(for url: URL, errorImage: UIImage? = nil) -> AnyPublisher<UIImage?, Never> {
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard
                    let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200,
                    let image = UIImage(data: data)
                else {
                    throw FlickerError.unknownError
                }
                return image
            }
            .replaceError(with: errorImage)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
