//
//  RegistrationView.swift
//  Tripo
//
//  Created by Leonid on 23.06.2023.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 20) {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 200, height: 40)

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 200, height: 40)

            Button(action: {
                Task {
                    AuthenticationHTTPService.shared.sendRegisterUserRequest(email: email, password: password)
                    
                }
            }) {
                Text("Register")
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

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
