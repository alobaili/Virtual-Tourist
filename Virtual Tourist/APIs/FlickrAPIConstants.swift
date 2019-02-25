//
//  FlickrAPIConstants.swift
//  Virtual Tourist
//
//  Created by Abdulaziz AlObaili on 25/02/2019.
//  Copyright © 2019 Abdulaziz Alobaili. All rights reserved.
//

import Foundation

struct FlickrAPIConstants {
    
    static let baseURL = "https://api.flickr.com/services/rest/"
    
    struct ParameterKeys {
        static let method = "method"
        static let apiKey = "api_key"
        static let lat = "lat"
        static let lon = "lon"
        static let radius = "radius"
        static let radiusUnit = "radius_units"
        static let extras = "extras"
        static let format = "format"
        static let noJSONCallback = "nojsoncallback"
        static let page = "page"
        static let perPage = "per_page"
    }
    
    struct ParameterValues {
        static let apiKey = Keys.flickrAPIKey
        static let responseFormat = "json"
        static let disableJSONCallback = "1" // 1 means yes
        static let searchMethod = "flickr.photos.search"
        static let radius = "5"
        static let radiusUnit = "km"
        static let mediumURL = "url_m"
        static let randomInt = Int(arc4random_uniform(UInt32(50)))
        static let pageLimit = "10"
    }
    
    struct ResponseKeys {
        static let photos = "photos"
        static let photo = "photo"
        static let mediumURL = "url_m"
    }
}
