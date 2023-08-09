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
        if let name = viewModel.landmark?.name, let description = viewModel.landmark?.landmarkDescription {
            LandmarkDetailsView(name: name, description: description)
                .onAppear {
                    if let remoteId = remoteId {
                        viewModel.fetchLandmarkByRemoteId(remoteId: remoteId)
                    }
                }
        }
    }
}
