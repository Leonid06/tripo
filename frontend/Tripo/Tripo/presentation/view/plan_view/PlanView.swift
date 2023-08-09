//
//  PlanView.swift
//  Tripo
//
//  Created by Leonid on 07.08.2023.
//

import SwiftUI


struct PlanView : View {
    @StateObject var viewModel = PlanViewModel()
    private var remoteId : String?
    
    
    init(remoteId: String) {
        self.remoteId = remoteId
    }
  

    var body : some View {
        NavigationStack {
            VStack {
                PlanDetailsCardView(name: viewModel.planDetailCard?.name, completed: viewModel.planDetailCard?.completed)
                
                ForEach(viewModel.landmarkDetailCards){ card in
                    if let name = card.name, let description = card.landmarkDescription, let remoteId = card.remoteId {
                        NavigationLink {
                            LandmarkView(remoteId: remoteId)
                        } label: {
                            LandmarkDetailsCardView(name: name, description: description)
                        }
                        
                    }
                }
            }.onAppear {
                if let remoteId = remoteId {
                    viewModel.fetchPlanByRemoteId(remoteId: remoteId)
                }
            }
        }
        
    }
}

//struct PlanView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlanView()
//    }
//}
