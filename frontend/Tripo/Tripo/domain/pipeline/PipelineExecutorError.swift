//
//  PipelineExecutorError.swift
//  Tripo
//
//  Created by Leonid on 31.07.2023.
//

import Foundation


enum PipelineExecutorError : Error {
    case PipelineNotInitialized
    case PipelineExecutionFailed(error : PipelineWrapperError)
}
