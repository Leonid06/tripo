//
//  File.swift
//  Tripo
//
//  Created by Leonid on 26.06.2023.
//

import Foundation
import Alamofire

struct RequestDetails {
    var method : HTTPMethod
    var route : String
    var format : String
    var head : String?
    var port : String?
    var parameters : [String : [String]]?
    var headers : HTTPHeaders?
}
