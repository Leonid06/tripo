//
//  AuthenticationView.swift
//  Tripo
//
//  Created by Leonid on 29.06.2023.
//

import SwiftUI


struct AuthenticationView: View {
    let viewModel = AuthenticationStateViewModel()

    var body : some View {
        switch viewModel.state {
        case .authenticated:
            HomeView()
        case .loggedOut:
            LoginView()
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
       AuthenticationView()
    }
}
