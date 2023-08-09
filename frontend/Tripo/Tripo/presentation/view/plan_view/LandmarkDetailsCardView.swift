//
//  LandmarkDetailsCardView.swift
//  Tripo
//
//  Created by Leonid on 07.08.2023.
//

import SwiftUI


struct LandmarkDetailsCardView : View {
    
    private var name : String?
    private var description : String?
    
    init(card: LandmarkDetailsCard){
        if let name = card.name, let description = card.landmarkDescription {
            self.name = name
            self.description = description
        }
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
