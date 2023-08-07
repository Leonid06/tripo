//
//  BasePipeline.swift
//  Tripo
//
//  Created by Leonid on 29.07.2023.
//

import Foundation
import Combine

class BasePipelineExecutor {
    
    enum PipelineExecutionProduct<Output, Failure> {
        case Success(output : Output)
        case Failure(failure: Failure)
    }
    
    init() throws {
        
    }
}
