//
//  PipelineExecutor+Group.swift
//  Tripo
//
//  Created by Leonid on 14.08.2023.
//

import Foundation
import Combine

extension PlanManualCreateViewPipelineExecutor {
    internal func getSaveEntitiesGroup(pipeline : PlanManualCreatePipeline, planName: String?, planDescription: String?, landmarks : Array<PlanCreatePipelineLandmarkSchema>?) ->
    AnyPublisher<BasePipeline.PipelineDatabaseTaskOutput, PipelineJobError> {
        let retrieveUserTokenJob = pipeline.getRetrieveUserTokenJob()
        
        let group = retrieveUserTokenJob.flatMap {
            output in
            let defaultsTaskOutput = output as BasePipeline.PipelineDefaultsTaskOutput
            
            switch defaultsTaskOutput {
            case .userCurrentToken(let token):
                return pipeline.getSavePlanInDatabaseJob(userToken: token, planName: planName,
                    planDescription: planDescription,
                    landmarks: landmarks)
                .eraseToAnyPublisher()
            case .Void:
                return Fail(error: PipelineJobError.WrapError(error: PipelineOutputError.PipelineJobInvalidOutput(description: "invalid defaults job output")))
                    .eraseToAnyPublisher()
            }
        }
        .collect()
        .eraseToAnyPublisher()
        .flatMap {
            outputs in
            
            
            let outputArray = outputs as Array<PipelineOutput>


            var planIdentifier : UUID?
            var landmarkIdentifiers = Array<UUID>()
            var userToken : String?

            outputArray.forEach { output in
                if let output = output as? BasePipeline.PipelineDefaultsTaskOutput {
                    switch output {
                    case .userCurrentToken(let token):
                        userToken = token
                    default:
                        return
                    }
                }
                if let output = output as? BasePipeline.PipelineDatabaseTaskOutput {
                    switch output {
                    case .PlanUUID(let identifier):
                        planIdentifier = identifier
                    case .LandmarkUUID(let identifier):
                        landmarkIdentifiers.append(identifier)
                    default:
                        return
                    }
                }
            }
            
            return self.getExecuteSecondaryDatabaseBusiness(
                pipeline: pipeline,
                planName: planName,
                planDescription: planDescription,
                landmarks: landmarks,
                userToken: userToken,
                planIdentifier: planIdentifier,
                landmarkIdentifiers: landmarkIdentifiers)
            
        }
        return group.eraseToAnyPublisher()
    }
    

    private func getExecuteSecondaryDatabaseBusiness(
        pipeline: PlanManualCreatePipeline,
        planName: String?,
        planDescription: String?,
        landmarks : Array<PlanCreatePipelineLandmarkSchema>?,
        userToken: String?,
        planIdentifier: UUID?,
        landmarkIdentifiers: Array<UUID>)  -> AnyPublisher<BasePipeline.PipelineDatabaseTaskOutput, PipelineJobError> {
            
        let subgroup = pipeline.getSaveRelationshipsInDatabaseJob(userToken: userToken, planIdentifier: planIdentifier, landmarkIdentifiers: landmarkIdentifiers)
            .flatMap {
                _ in
                return pipeline.getMakePlanCreateNetworkCallsJob(planName: planName, planDescription: planDescription, landmarks: landmarks)
            }.flatMap {
                output in
                let databaseTaskOutput = output as BasePipeline.PipelineNetworkTaskOutput
                switch databaseTaskOutput {
                case .PlanRemoteId(let remoteId):
                    return pipeline.getAssignRemoteIdToPlanJob(identifier: planIdentifier, remoteId: remoteId)
                default:
                    return Fail(error: PipelineJobError.WrapError(error: PipelineOutputError.PipelineJobInvalidOutput(description: "invalid Make Plan Create Network Calls Job output")))
                        .eraseToAnyPublisher()
                }
            }
        return subgroup.eraseToAnyPublisher()
    }

}
