//
//  LandmarkSearchCardDetailView.swift
//  Tripo
//
//  Created by Leonid on 09.08.2023.
//

import SwiftUI


struct LandmarkSearchCardDetailView : View {
    
    private var viewModel : PlanManualCreateViewModel?
    private var card : LandmarkSearchDetailCard?
    
    @State private var chosen : Bool = false
    
    
    init(viewModel: PlanManualCreateViewModel, card: LandmarkSearchDetailCard){
        self.viewModel = viewModel
        self.card = card
        
    }
    

    var body : some View {
        Toggle(isOn: $chosen){
            Button("") {
                if let card = self.card {
                    viewModel?.chooseLandmarkForPlan(card: card)
                }
            }
        }.toggleStyle(.switch)
    }
}
