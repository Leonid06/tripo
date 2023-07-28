//
//  PlanCreateViewModel.swift
//  Tripo
//
//  Created by Leonid on 27.07.2023.
//

import Foundation



class PlanCreateViewModel : BaseViewModel {
    @Published var fetchedLandmarks : Array<LandmarkSearchShortPresentationUnit>?
    @Published var fetchLandmarksRequestState : ViewModelState.fetchRequestState = .fetchInProgress
    private var landmarkHTTPService = LandmarkHTTPService()
    
    func fetchLandmarksByCurrentLocation(radius: Int){
        fetchLandmarksRequestState = .fetchInProgress
        landmarkHTTPService
            .sendSearchLandmarkByRadiusRequest(parameters: LandmarkSearchByRadiusParameters(latitude: "52.377956", longitude: "4.897070", radius: String(radius))){
                response, error in
                
                if let error = error {
                    self.fetchLandmarksRequestState = .fetchFailed
                    switch error {
                    case .createURLRequestFailed(let error):
                        print("Failed to create url request due to the following error raised : \(error)")
                    case .responseSerializationFailed(let reason):
                        print("Response serialization failed due to the following reason: \(reason)")
                    case .responseValidationFailed(let reason):
                        print("Response validation failed due to the following reason: \(reason)")
                    default:
                        print("fetch failed due to unknown  error : \(error)")
                    }
                }
                
                if let response = response {
                    self.fetchedLandmarks = self.mapLandmarkSearchByRadiusRequestResponseToLandmarkSearchShortPresentationUnits(response: response)
                    self.fetchLandmarksRequestState = .fetchNotRequested
                }
            }
    }
}
