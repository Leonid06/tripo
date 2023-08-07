//
//  HomeView.swift
//  Tripo
//
//  Created by Leonid on 29.06.2023.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    var body: some View {
        Button(action: {
            viewModel.sendLogoutUserRequest()
        }) {
            Text("Log out")
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 2)
                }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
