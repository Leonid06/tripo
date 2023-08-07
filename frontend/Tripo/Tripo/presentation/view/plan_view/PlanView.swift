//
//  PlanView.swift
//  Tripo
//
//  Created by Leonid on 07.08.2023.
//

import SwiftUI


struct PlanView : View {
    @StateObject var viewModel = PlanViewModel()

    var body : some View {
        return VStack {
            PlanDetailsCardView(name: viewModel.plan?.name, completed: viewModel.plan?.completed)
            
            ForEach(viewModel.landmarkDetailCards){ card in
                LandmarkDetailsCardView(name: card.name, description: card.description)
            }
        }
    }
}

struct PlanView_Previews: PreviewProvider {
    static var previews: some View {
        PlanView()
    }
}
