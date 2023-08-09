//
//  PlanCreateViewItems.swift
//  Tripo
//
//  Created by Leonid on 09.08.2023.
//

import Foundation

struct LandmarkSearchDetailCard : Identifiable {
    var id  = UUID()
    var name : String?
    var landmarkDescription : String?
    var remoteId : String?
}

struct PlanManualCreateDetailCard : Identifiable {
    var id = UUID()
    var name : String?
    var description : String?
}
