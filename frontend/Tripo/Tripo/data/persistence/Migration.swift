//
//  migration.swift
//  Tripo
//
//  Created by Leonid on 24.07.2023.
//

import CoreStore


struct MigrationUtil {
    static let currentVersion = V1.self
}

protocol Version {
    static var dataStack : DataStack { get }
}

enum V1 : Version {
    static var dataStack = DataStack(
        CoreStoreSchema(
            modelVersion: "V1", entities: [
                Entity<Landmark>("landmark"),
                Entity<Plan>("plan"),
                Entity<User>("user"),
                Entity<PlanToLandmark>("plan_to_landmark"),
                Entity<PlanToUser>("plan_to_user")
                
            ]
        ),
        migrationChain: ["V1"]
    )
    class Landmark : CoreStoreObject {
        @Field.Stored("remote_id")
        var remoteId : String = ""
        
        @Field.Stored("name")
        var name : String = ""
        
        @Field.Stored("landmark_description")
        var landmarkDescription : String = ""
        
        @Field.Stored("type")
        var type : String = ""
        
        @Field.Relationship("plan_to_landmark", inverse: \.$landmark)
        var planToLandmark : Set<PlanToLandmark>
    }

    class Plan : CoreStoreObject {
        @Field.Stored("remote_id")
        var remoteId : String = ""
        
        @Field.Stored("name")
        var name : String = ""
        
        @Field.Stored("plan_description")
        var planDescription : String = ""
        
        @Field.Stored("type")
        var completed : Bool = false
        
        @Field.Relationship("plan_to_landmark", inverse: \.$plan)
        var planToLandmark : Set<PlanToLandmark>
        
        @Field.Relationship("plan_to_user", inverse: \.$plan)
        var planToUser : Set<PlanToUser>
    }

    class PlanToLandmark : CoreStoreObject {
        
        @Field.Relationship("plan")
        var plan : Plan?
        
        @Field.Relationship("landmark")
        var landmark : Landmark?
        
        @Field.Stored("visited")
        var visited : Bool = false
        
        @Field.Stored("visit_date", dynamicInitialValue: {Date()})
        var visitDate : Date
    }

    class PlanToUser : CoreStoreObject {
        @Field.Relationship("plan")
        var plan : Plan?
        
        @Field.Relationship("user")
        var user : User?
    }

    class User : CoreStoreObject {
        @Field.Stored("current_token")
        var currentToken : String = ""
        
        @Field.Relationship("plan_to_user", inverse: \.$user)
        var planToUser : Set<PlanToUser>
    }
}

enum V2 : Version {
    static var dataStack = DataStack(
        CoreStoreSchema(
            modelVersion: "V2", entities: [
                Entity<Landmark>("landmark"),
                Entity<Plan>("plan"),
                Entity<User>("user"),
                Entity<PlanToLandmark>("plan_to_landmark"),
                Entity<PlanToUser>("plan_to_user")
                
            ]
        ),
        migrationChain: ["V1", "V2"]
    )
    class Landmark : CoreStoreObject {
        
        @Field.Stored("identifier", dynamicInitialValue: {UUID()})
        var identifier : UUID
        @Field.Stored("remote_id")
        var remoteId : String = ""
        
        @Field.Stored("name")
        var name : String = ""
        
        @Field.Stored("landmark_description")
        var landmarkDescription : String = ""
        
        @Field.Stored("type")
        var type : String = ""
        
        @Field.Relationship("plan_to_landmark", inverse: \.$landmark)
        var planToLandmark : Set<PlanToLandmark>
    }

    class Plan : CoreStoreObject {
        @Field.Stored("identifier", dynamicInitialValue: {UUID()})
        var identifier : UUID
        
        @Field.Stored("remote_id")
        var remoteId : String = ""
        
        @Field.Stored("name")
        var name : String = ""
        
        @Field.Stored("plan_description")
        var planDescription : String = ""
        
        @Field.Stored("type")
        var completed : Bool = false
        
        @Field.Relationship("plan_to_landmark", inverse: \.$plan)
        var planToLandmark : Set<PlanToLandmark>
        
        @Field.Relationship("plan_to_user", inverse: \.$plan)
        var planToUser : Set<PlanToUser>
    }

    class PlanToLandmark : CoreStoreObject {
        
        @Field.Stored("identifier", dynamicInitialValue: {UUID()})
        var identifier : UUID
        
        @Field.Relationship("plan")
        var plan : Plan?
        
        @Field.Relationship("landmark")
        var landmark : Landmark?
        
        @Field.Stored("visited")
        var visited : Bool = false
        
        @Field.Stored("visit_date", dynamicInitialValue: {Date()})
        var visitDate : Date
    }

    class PlanToUser : CoreStoreObject {
        @Field.Stored("identifier", dynamicInitialValue: {UUID()})
        var identifier : UUID
        
        @Field.Relationship("plan")
        var plan : Plan?
        
        @Field.Relationship("user")
        var user : User?
    }

    class User : CoreStoreObject {
        @Field.Stored("identifier", dynamicInitialValue: {UUID()})
        var identifier : UUID
        
        @Field.Stored("current_token")
        var currentToken : String = ""
        
        @Field.Relationship("plan_to_user", inverse: \.$user)
        var planToUser : Set<PlanToUser>
    }
}

typealias Landmark = V2.Landmark
typealias Plan = V2.Plan
typealias User = V2.User
typealias PlanToLandmark = V2.PlanToLandmark
typealias PlanToUser = V2.PlanToUser
