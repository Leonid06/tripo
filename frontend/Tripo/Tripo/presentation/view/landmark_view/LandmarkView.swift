//
//  LandmarkView.swift
//  Tripo
//
//  Created by Leonid on 09.08.2023.
//

import SwiftUI

struct LandmarkView : View {
    
    private var remoteId : String?
    
    
    init(remoteId: String) {
        self.remoteId = remoteId
    }
  
    @StateObject var viewModel = LandmarkViewModel()
    var body : some View {
        VStack {
            if let card = viewModel.landmarkDetailCard {
                LandmarkDetailsView(card: card)
                    .onAppear {
                        if let remoteId = remoteId {
                            viewModel.fetchLandmarkDetailCardByRemoteId(remoteId: remoteId)
                        }
                    }
            }
            
        }.onAppear {
            if let remoteId = remoteId {
                viewModel.fetchLandmarkDetailCardByRemoteId(remoteId: remoteId)
            }
            
        }
        
    }
}
