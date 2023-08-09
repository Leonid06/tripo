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
                if let card = viewModel.planDetailCard {
                    PlanDetailsCardView(card: card)
                    
                    ForEach(viewModel.landmarkDetailCards){ card in
                    
                        NavigationLink {
                            if let remoteId = remoteId {
                                LandmarkView(remoteId: remoteId)
                            }
                        } label: {
                            LandmarkDetailsCardView(card: card)
                        }
                    }
                }
                
            }.onAppear {
                if let remoteId = remoteId {
                    viewModel.fetchPlanDetailCardByRemoteId(remoteId: remoteId)
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
