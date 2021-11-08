//
//  PhotosViewModel.swift
//  SearchFlickerImages
//
//  Created by Patel, V. (Vilasini) on 7/11/21.
//

import Foundation
import Combine

class PhotosViewModel {
    
    /// It is referring list of photos detail which we will get in API response
    let flickerPhotos = CurrentValueSubject<[FlickerPhoto], Never>([FlickerPhoto]())
    
    /// define searchText instance which is refering value from searchbar text
    let searchText = CurrentValueSubject<String, Never>("")
    
    let flickerAPI = FlickerPhotoAPI()
   private var subsciptions = Set<AnyCancellable>()
    
    init() {
        setupSearch()
    }
    /// Adding listener for searchText which will  execute whenever it publishes a new element
    func setupSearch() {
        searchText
            .removeDuplicates()
            .debounce(for: .milliseconds(100), scheduler: RunLoop.main)
            .map { [unowned self] (searchText) -> AnyPublisher<PhotosList, Never> in
                self.flickerAPI.photosPublisher(searchedText: searchText)
                    .catch { (error) in
                       Empty(completeImmediately: true)

                    }
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .sink { [unowned self] (photoList) in
                self.flickerPhotos.send(photoList.photos?.photo ?? [])
            }
            .store(in: &subsciptions)
    }
    
}
