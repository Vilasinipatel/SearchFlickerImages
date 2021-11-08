//
//  URLExtension.swift
//  SearchFlickerImages
//
//  Created by Patel, V. (Vilasini) on 8/11/21.
//

import Foundation

extension String

{
   public var isValidUrl: Bool {
             let urlRegEx = "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
             return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: self)
         }
}
