//
//  PhoneAuthView.swift
//  Mapzin
//
//  Created by Amir Malamud on 02/05/2024.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct PhoneAuthView: View {
    @State private var phoneNumber = ""
    @State private var verificationID = ""
    @State private var code = ""
    @State private var isCodeSent = false
    @State private var errorMessage = ""
    @State private var isAuthenticated = false

    var body: some View {
        VStack {
            if !isAuthenticated {
                if !isCodeSent {
                    Text("Enter your phone number")
                    TextField("Phone number", text: $phoneNumber)
                        .keyboardType(.phonePad)
                        .padding()
                    Button("Send Code") {
                        sendVerificationCode()
                    }
                } else {
                    Text("Enter the verification code")
                    TextField("Code", text: $code)
                        .keyboardType(.numberPad)
                        .padding()
                    Button("Verify") {
                        verifyCode()
                    }
                }
            } else {
                Text("You are authenticated!")
            }

            if !errorMessage.isEmpty {
                Text(errorMessage).foregroundColor(.red)
            }
        }
        .padding()
    }

    private func sendVerificationCode() {
        let phone = "+1" + phoneNumber // Adjust the country code as needed
        PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { verificationID, error in
            if let error = error {
                errorMessage = error.localizedDescription
                return
            }
            if let verificationID = verificationID {
                self.verificationID = verificationID
                isCodeSent = true
            }
        }
    }

    private func verifyCode() {
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: code
        )
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                errorMessage = error.localizedDescription
                return
            }
            isAuthenticated = true
        }
    }
}

struct PhoneAuthView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneAuthView()
    }
}
