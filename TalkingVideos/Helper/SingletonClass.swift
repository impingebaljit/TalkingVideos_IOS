//
//  SingletonClass.swift
//  Bluelight
//
//  Created by Nisha Gupta on 13/05/24.
//

import UIKit

class SingletonClass{
    
    static let shared = SingletonClass()
       var userId: String?
    var accessToken : String?
       private init() {}
    
}
