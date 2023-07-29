//
//  PlanCreatePipeline.swift
//  Tripo
//
//  Created by Leonid on 29.07.2023.
//

import Foundation

class PlanCreatePipelineExecutor : BasePipelineExecutor {
    private var landmarkHTTPService = LandmarkHTTPService()
    private var databaseClient : PlanDatabaseClient?
    
    override init() throws  {
        do {
            try super.init()
            databaseClient = try PlanDatabaseClient(version: MigrationUtil.currentVersion)
        }catch DatabaseClientError.differentStorageExistsAtUrl(let url) {
            print("Different storage exists at URL : \(url)")
            throw PipelineExecutorError.databaseClientInitializationFailed
            
        }catch DatabaseClientError.internalError(let error) {
            print("Internal database client error happened : \(error)")
            throw PipelineExecutorError.databaseClientInitializationFailed
        }catch DatabaseClientError.unknownError {
            print("unknown database client error happened")
            throw PipelineExecutorError.databaseClientInitializationFailed
         
        }catch {
            print("unknown error happened")
            throw PipelineExecutorError.databaseClientInitializationFailed
        }
    }

    
    func executeCreatePlanPipeline(pipelineSchema: PlanCreatePipelineSchema){
        
    }
}
