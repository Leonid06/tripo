//
//  CreateBlockView.swift
//  Tripo
//
//  Created by Leonid on 09.08.2023.
//

import SwiftUI


struct PlanManualCreateBlockView : View {
    
    private var viewModel : PlanManualCreateViewModel?
    @State private var nameTextFieldInput = ""
    
    init(viewModel: PlanManualCreateViewModel){
        self.viewModel = viewModel
        
    }
    

    var body : some View {
        VStack {
            TextField("", text: $nameTextFieldInput)
            Toggle(isOn: viewModel?.$creationAllowed){
                Button {
                    if !nameTextFieldInput.isEmpty {
                        viewModel?.createPlanWith(PlanDetailsCard(
                            name: nameTextFieldInput
                        ), and: viewModel?.landmarkChosenSearchDetailCards)
                    }
                } label: {
          
                }
            }.toggleStyle(.switch)
        }
        
    }
}
