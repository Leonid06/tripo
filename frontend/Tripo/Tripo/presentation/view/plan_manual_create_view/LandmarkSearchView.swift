//
//  LandmarkSearchView.swift
//  Tripo
//
//  Created by Leonid on 09.08.2023.
//

import SwiftUI


struct LandmarkSearchView : View {
    
    private var viewModel : PlanManualCreateViewModel?
    
    
    init(viewModel: PlanManualCreateViewModel){
        self.viewModel = viewModel
    }
    

    var body : some View {
        Button {
            viewModel?.searchLandmarksByCurrentLocation()
        } label: {
        }
    }
}
