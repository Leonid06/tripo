//
//  PipelineSchema.swift
//  Tripo
//
//  Created by Leonid on 29.07.2023.
//

import Foundation


struct PlanCreatePipelineSchema {
    var planName : String?
    var planDescription : String?
    var landmarks : Array<PlanCreatePipelineLandmarkSchema>?
}

struct PlanCreatePipelineLandmarkSchema {
    var name : String?
    var description : String?
    var remoteId : String? 
}
