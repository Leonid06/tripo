//
//  PlanManualCreateView.swift
//  Tripo
//
//  Created by Leonid on 09.08.2023.
//

import SwiftUI

struct PlanManualCreateView : View {
    @StateObject var viewModel = PlanManualCreateViewModel()
    

    var body : some View {
        NavigationStack {
            VStack {
                LandmarkSearchView(viewModel: viewModel)
                ForEach(viewModel.landmarkSearchDetailCards){
                    card in
                    LandmarkSearchCardDetailView(viewModel: viewModel, card: card)
                }
                PlanManualCreateBlockView(viewModel: viewModel)
            }.onAppear {
               
            }
        }
        
    }
}
