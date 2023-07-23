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
    
    @Field.Relationship("plans")
    var plans : Set<Plan>
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
    
    @Field.Relationship("landmarks", inverse: \.$plans)
    var landmarks : Set<Landmark>
    
    @Field.Relationship("users")
    var users : Set<User>
}

class User : CoreStoreObject {
    @Field.Stored("current_token")
    var current_token : String = ""
    
    @Field.Relationship("plans", inverse : \.$users)
    var plans : Set<Plan>
}
