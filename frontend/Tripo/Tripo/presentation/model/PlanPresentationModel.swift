//
//  PlanPresentationModel.swift
//  Tripo
//
//  Created by Leonid on 28.07.2023.
//

import Foundation


protocol PlanPresentationUnitProtocol {
    var name : String? {get set}
}


struct PlanCreatePresentationUnit : PlanPresentationUnitProtocol {
    var name : String?
    var description : String?
}


