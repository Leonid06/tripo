//
//  LoginView.swift
//  Tripo
//
//  Created by Leonid on 23.06.2023.
//

import SwiftUI

struct LoginView: View {

    @State private var email = ""
    @State private var password = ""
    
    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        VStack(spacing: 20) {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 200, height: 40)

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 200, height: 40)

            Button(action: {
                viewModel.sendlogInUserRequest(email: email, password: password)
            }) {
                Text("Login")
                    .frame(width: 100)
                    .foregroundColor(.white)
                    .padding(.horizontal, 50)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .cornerRadius(5)
            }
            Spacer()
        }
        .padding(.top, 100)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
