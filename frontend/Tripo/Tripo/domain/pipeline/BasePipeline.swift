//
//  BasePipeline.swift
//  Tripo
//
//  Created by Leonid on 31.07.2023.
//

import Foundation
import Combine


class BasePipeline  {
    internal let defaultsService = DefaultsService()
    init() throws {
        
    }
    
    internal func doGetUserCurrentTokenTask(promise: @escaping Future<String, PipelineDefaultsError>.Promise){
        guard let key = EnvironmentVariables.JWT_KEYCHAIN_KEY as? String else {
            promise(Result.failure(PipelineDefaultsError.InvalidDefaultsKey))
            return
        }
        
        guard let token = defaultsService.getValueForKey(key) else {
            promise(Result.failure(PipelineDefaultsError.InvalidValueByDefaultsKey(key: key)))
            return
        }
        
        guard let downcastedToken = token as? String else {
            promise(Result.failure(PipelineDefaultsError.NoValueByDefaultsKey(key: key)))
            return
        }
        
        promise(Result.success(downcastedToken))
     
    }
}
