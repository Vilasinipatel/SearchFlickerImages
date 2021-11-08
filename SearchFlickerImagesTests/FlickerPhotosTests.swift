//
//  FlickerPhotosTests.swift
//  SearchFlickerImagesTests
//
//  Created by Patel, V. (Vilasini) on 8/11/21.
//

import XCTest

class FlickerPhotosTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testPhotosList_CanCreateInstance() {
        
        let flickerPhoto_one = FlickerPhoto(id: "1",
                                         secret: "45defb1a0e",
                                         server: "51660421966",
                                         farm: 66,
                                         title: "Test image one")
        
        XCTAssertNotNil(flickerPhoto_one)
        
        let flickerPhoto_two = FlickerPhoto(id: "2",
                                         secret: "46defb1a0e",
                                         server: "51670421966",
                                         farm: 67,
                                         title: "Test image two")
        
        XCTAssertNotNil(flickerPhoto_two)
        
        let photos = FlickerPhotos(photo: [flickerPhoto_one, flickerPhoto_two])
        
        XCTAssertNotNil(photos)

        let photoList = PhotosList(photos: photos)
        
        XCTAssertNotNil(photoList)

    }

    func testFlickerPhoto_ShouldPassIfValidURLString() {
        
        let flickerPhoto = FlickerPhoto(id: "4",
                                         secret: "46drfb1a0e",
                                         server: "51666421966",
                                         farm: 68,
                                         title: "Test image three")
        
        
        
        
        let imageUrl = flickerPhoto.flickrImageURL()?.absoluteString
        
        XCTAssertTrue((imageUrl?.isValidUrl) != nil)
        
    }
    
    func testFlickerPhoto_ShouldPassIfInValidURLString() {
        
        let flickerPhoto = FlickerPhoto(id: "3",
                                         secret: "46drfb1a0e",
                                         server: "[51666421966]",
                                         farm: 68,
                                         title: "Test image three")
        
        let imageUrl = flickerPhoto.flickrImageURL()?.absoluteString
        
        XCTAssertFalse((imageUrl?.isValidUrl) != nil)
        
    }

    
    
    

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
