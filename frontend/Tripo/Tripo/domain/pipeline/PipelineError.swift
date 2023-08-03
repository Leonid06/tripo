//
//  PipelineExecutorError.swift
//  Tripo
//
//  Created by Leonid on 29.07.2023.
//

import Foundation


protocol PipelineError : Error {}


enum PipelineJobError : PipelineError {
    case WrapError(error: PipelineError)

}

enum PipelineOutputError : PipelineError {
    case PipelineJobInvalidOutput(description: String)
}


enum PipelineDefaultsError : PipelineError {
    case InvalidUpstreamTaskOutput(description :String)
    case NoValueByDefaultsKey(key : String)
    case InvalidDefaultsKey
    case InvalidValueByDefaultsKey(key : Any)
  
}

enum PipelineDatabaseError : PipelineError {
    case InvalidUpstreamTaskOutput(description :String)
    case DatabaseRequestFailed(error : Error)
    case InvalidDatabaseResponse
    case InvalidObjectSchema(description: String)
    
    enum PipelineDatabaseInstantiationError : PipelineError {
        case InvalidDatabaseStorageProvided(url : URL)
        case InternalDatabaseErrorHappened(error : Error)
        case UnknownDatabaseErrorHappened
    }
}
