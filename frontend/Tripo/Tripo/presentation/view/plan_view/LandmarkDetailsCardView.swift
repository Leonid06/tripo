//
//  LandmarkDetailsCardView.swift
//  Tripo
//
//  Created by Leonid on 07.08.2023.
//

import SwiftUI


struct LandmarkDetailsCardView : View {
    
    var name : String?
    var description : String?
    
    init(name : String, description :String){
        self.name = name
        self.description = description
    }
    var body : some View {
        EmptyView()
    }
}

//struct LandmarksDetailsCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlanView()
//    }
//}
