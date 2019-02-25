//
//  FlickrAPI.swift
//  Virtual Tourist
//
//  Created by Abdulaziz AlObaili on 25/02/2019.
//  Copyright © 2019 Abdulaziz Alobaili. All rights reserved.
//

import Foundation


class FlickrAPI {
    
    //Shared instance
    static let shared = FlickrAPI()
    private init() {}
    
    // Shared session
    var session = URLSession.shared
    
    func getNewPhotoCollection(pin: Pin, completion: @escaping ([String]?) -> Void) {
        var resultURLArray: [String] = []
        
        let parameters = [
            FlickrAPIConstants.ParameterKeys.method : FlickrAPIConstants.ParameterValues.searchMethod,
            FlickrAPIConstants.ParameterKeys.apiKey : FlickrAPIConstants.ParameterValues.apiKey,
            FlickrAPIConstants.ParameterKeys.lat : pin.latitude,
            FlickrAPIConstants.ParameterKeys.lon : pin.longitude,
            FlickrAPIConstants.ParameterKeys.radius : FlickrAPIConstants.ParameterValues.radius,
            FlickrAPIConstants.ParameterKeys.radiusUnit : FlickrAPIConstants.ParameterValues.radiusUnit,
            FlickrAPIConstants.ParameterKeys.extras : FlickrAPIConstants.ParameterValues.mediumURL,
            FlickrAPIConstants.ParameterKeys.format : FlickrAPIConstants.ParameterValues.responseFormat,
            FlickrAPIConstants.ParameterKeys.noJSONCallback : FlickrAPIConstants.ParameterValues.disableJSONCallback,
            FlickrAPIConstants.ParameterKeys.page : FlickrAPIConstants.ParameterValues.randomInt
            ] as [String : AnyObject]
        let url = URL(string: "\(FlickrAPIConstants.baseURL)\(escapedParameters(parameters))")!
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil {
                // there was data returned
                if let data = data {
                    
                    let parsedResult: [String:AnyObject]!
                    do {
                        parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
                    } catch {
                        print("Could not parse the data as JSON: '\(data)'")
                        return
                    }
                    
                    if let photosDictionary = parsedResult[FlickrAPIConstants.ResponseKeys.photos] as? [String : AnyObject], let photoArray = photosDictionary[FlickrAPIConstants.ResponseKeys.photo] as? [[String : AnyObject]] {
                        
                        for photo in photoArray {
                            if let imageURLString = photo[FlickrAPIConstants.ResponseKeys.mediumURL] as? String {
                                resultURLArray.append(imageURLString)
                            }
                        }
                    }
                }
            }
        }
        
        task.resume()
        
        completion(resultURLArray)
    }
    
    private func escapedParameters(_ parameters: [String : AnyObject]) -> String {
        if parameters.isEmpty {
            return ""
        } else {
            var keyValuePairs = [String]()
            
            for (key, value) in parameters {
                // make sure that it's a string value
                let stringValue = "\(value)"
                
                // escape it
                let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                
                // append it
                keyValuePairs.append(key + "=" + "\(escapedValue!)")
            }
            
            return "?\(keyValuePairs.joined(separator: "&"))"
        }
    }
}
