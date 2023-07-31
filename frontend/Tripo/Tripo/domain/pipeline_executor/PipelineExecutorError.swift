//
//  PipelineExecutorError.swift
//  Tripo
//
//  Created by Leonid on 29.07.2023.
//

import Foundation


enum PipelineExecutorError : Error {
    case DatabaseClientInitializationFailed
    case NoValueByDefaultsKey(key : String)
    case InvalidDefaultsKey
    case InvalidValueByDefaultsKey(key : Any)
    case PipelineExecutionError(description: String)
    case DatabaseRequestFailed(error : Error)
    
}
