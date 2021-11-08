//
//  FlickerError.swift
//  SearchFlickerImages
//
//  Created by Patel, V. (Vilasini) on 3/11/21.
//

import Foundation

enum FlickerError: Error {
    case statusCode
    case invalidURL
    case unknownError

static func map(_ error: Error) -> FlickerError {
    return (error as? FlickerError) ?? .unknownError
}
}

