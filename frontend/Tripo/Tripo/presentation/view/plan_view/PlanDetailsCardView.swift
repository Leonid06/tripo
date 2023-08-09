//
//  PlanDetailsCardView.swift
//  Tripo
//
//  Created by Leonid on 07.08.2023.
//

import SwiftUI


struct PlanDetailsCardView : View {
    
    var name : String?
    var completed : Bool?
    
    init(name : String?, completed : Bool?){
        guard let name = name, let completed = completed else {
            return
        }
        self.name = name
        self.completed = completed
        
    }
    var body : some View {
        return EmptyView()
    }
}

//struct PlanDetailsCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlanView()
//    }
//}
