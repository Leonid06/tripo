//
//  PlanCreateViewModel.swift
//  Tripo
//
//  Created by Leonid on 27.07.2023.
//

import Foundation



class PlanCreateViewModel : ObservableObject {
    @Published var landmarks : Array<Landmark>?
    
    func fetchLandmarksByCurrentLocation(radius: Int){
        
    }
}
