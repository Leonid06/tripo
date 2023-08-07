//
//  PlanViewModels.swift
//  Tripo
//
//  Created by Leonid on 07.08.2023.
//

import Foundation


struct PlanDetailsCard : Identifiable {
    var id = UUID()
    var name : String?
    var completed : Bool?
}

struct LandmarkDetailsCard : Identifiable {
    var id = UUID()
    var name :  String?
    var description : String? 
}

