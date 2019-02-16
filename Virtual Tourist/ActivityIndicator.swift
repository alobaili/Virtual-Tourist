//
//  ActivityIndicator.swift
//  Virtual Tourist
//
//  Created by Abdulaziz AlObaili on 16/02/2019.
//  Copyright © 2019 Abdulaziz Alobaili. All rights reserved.
//

import UIKit

struct ActivityIndicator {
    
    private static var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    static func startActivityIndicator(view:UIView){
        activityIndicator.center = view.center
        activityIndicator.frame = view.frame
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .whiteLarge
        activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    
    static func stopActivityIndicator(){
        activityIndicator.stopAnimating()
    }
    
}
