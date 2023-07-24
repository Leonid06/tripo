//
//  model.swift
//  Tripo
//
//  Created by Leonid on 23.07.2023.
//

import CoreStore

class Landmark : CoreStoreObject {
    @Field.Stored("remote_id")
    var remoteId : String = ""
    
    @Field.Stored("name")
    var name : String = ""
    
    @Field.Stored("description")
    var description : String = ""
    
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
    
    @Field.Stored("description")
    var description : String = ""
    
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
    
    @Field.Relationship("planToUser", inverse: \.$user)
    var planToUser : Set<PlanToUser>
}
