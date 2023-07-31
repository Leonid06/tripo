//
//  PipelineExecutorError.swift
//  Tripo
//
//  Created by Leonid on 29.07.2023.
//

import Foundation


protocol PipelineError : Error {
    
}

enum PipelineWrapperError : PipelineError {
    case WrapError(error: PipelineError)
}

enum PipelineDefaultsError : PipelineError {
    
    case NoValueByDefaultsKey(key : String)
    case InvalidDefaultsKey
    case InvalidValueByDefaultsKey(key : Any)
  
}

enum PipelineDatabaseError : PipelineError {
    case DatabaseRequestFailed(error : Error)
    case InvalidObjectSchema(description: String)
    
    enum PipelineDatabaseInstantiationError : PipelineError {
        case InvalidDatabaseStorageProvided(url : URL)
        case InternalDatabaseErrorHappened(error : Error)
        case UnknownDatabaseErrorHappened
    }
}
