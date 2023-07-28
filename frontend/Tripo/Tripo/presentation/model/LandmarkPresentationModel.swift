//
//  LandmarkModel.swift
//  Tripo
//
//  Created by Leonid on 28.07.2023.
//

import Foundation


protocol LandmarkPresentationUnitProtocol {
    var name : String? { get set}
    var remoteId : String? {get set}
}

struct LandmarkShortPresentationUnit  : LandmarkPresentationUnitProtocol {
    var name : String?
    var visitDate : Date?
    var remoteId : String?
}


struct LandmarkSearchShortPresentationUnit : LandmarkPresentationUnitProtocol {
    var name: String?
    var remoteId: String?
    
    
}

struct LandmarkPresentationUnit : LandmarkPresentationUnitProtocol {
    var name : String?
    var visitDate : Date?
    var description : String?
    var type : String?
    var remoteId : String?
}
