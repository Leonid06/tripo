//
//  HomePlanListView.swift
//  Tripo
//
//  Created by Leonid on 10.08.2023.
//

import SwiftUI

struct HomePlanListView : View {
    private var viewModel : HomeViewModel?
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body : some View {
        VStack {
            if let viewModel = viewModel {
                ForEach(viewModel.homePlanDetailCards){
                    card in
                    if let remoteId = card.remoteId {
                        NavigationLink {
                            PlanManualCreateView()
                        } label : {
                            Button {
                                
                            } label: {
                                PlanView(remoteId: remoteId)
                            }
                        }
                    }
                }
            }
            
        }
    }
}
