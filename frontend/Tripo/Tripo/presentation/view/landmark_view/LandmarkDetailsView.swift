//
//  LandmarkDetailsView.swift
//  Tripo
//
//  Created by Leonid on 09.08.2023.
//

import SwiftUI


struct LandmarkDetailsView : View {
    
    var name : String?
    var description : String?
    
    init(name : String?, description : String?){
        guard let name = name, let description = description else {
            return
        }
        self.name = name
        self.description = description 
    }
    var body : some View {
        EmptyView()
    }
}
