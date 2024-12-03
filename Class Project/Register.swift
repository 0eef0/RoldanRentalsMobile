//
//  Register.swift
//  Class Project
//
//  Created by Ethan Roldan on 10/29/24.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct Register: View {
    @Binding var email: String
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String = ""
    
    @Binding var registering: Bool
    
    var body: some View {
        ZStack {
            Image(.IMG_4232)
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                Text("Register")
                    .font(.largeTitle)
                    .foregroundStyle(Color.white)
                
                TextField("Email", text: $email, prompt: Text("Email").foregroundColor(.white))
                    .frame(height: 40)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding([.horizontal], 4)
                    .background(Color.black.opacity(0.3))
                    .foregroundStyle(Color.white)
                    .cornerRadius(30)
                    .overlay(RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.gray, lineWidth: 1))
                    .padding([.horizontal], 24)
                
                SecureField("Password", text: $password, prompt: Text("Password").foregroundColor(.white))
                    .frame(height: 40)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding([.horizontal], 4)
                    .background(Color.black.opacity(0.3))
                    .foregroundStyle(Color.white)
                    .cornerRadius(30)
                    .overlay(RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.gray, lineWidth: 1))
                    .padding([.horizontal], 24)
                
                SecureField("Confirm Password", text: $confirmPassword, prompt: Text("Confirm Password").foregroundColor(.white))
                    .frame(height: 40)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding([.horizontal], 4)
                    .background(Color.black.opacity(0.3))
                    .foregroundStyle(Color.white)
                    .cornerRadius(30)
                    .overlay(RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.gray, lineWidth: 1))
                    .padding([.horizontal], 24)
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.top, 4)
                        .padding([.horizontal], 24)
                }
                
                HStack {
                    Spacer()
                    
                    Button("Cancel") {
                        registering = false
                    }
                    .frame(width: 75, height: 10)
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(30)
                    
                    Spacer()
                    
                    Button("Register") {
                        if validateInputs() {
                            registering = false
                            register()
                        }
                    }
                    .frame(width: 75, height: 10)
                    .padding()
                    .background(
                        LinearGradient(gradient: Gradient(colors: [.purple, .orange]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .foregroundColor(.white)
                    .cornerRadius(30)
                    
                    Spacer()
                }
                
                Spacer()
            }
            .background(Color.black.opacity(0.3))
            .cornerRadius(10)
            .frame(maxHeight: 300)
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 200, trailing: 20))
        }
    }
    
    func validateInputs() -> Bool {
        errorMessage = ""
        
        if(password.isEmpty || confirmPassword.isEmpty || email.isEmpty) {
            errorMessage = "Please fill in all fields"
            return false
        }
        
        if password != confirmPassword {
            errorMessage = "Passwords do not match."
            return false
        }
        
        if !isValidEmail(email) {
            errorMessage = "Please enter a valid email address."
            return false
        }
        
        checkIfEmailExists(email)
        
        return true
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func checkIfEmailExists(_ email: String) {
        Auth.auth().fetchSignInMethods(forEmail: email) { (methods, error) in
            if let error = error {
                errorMessage = "Error checking email: \(error.localizedDescription)"
                print("Error checking email: \(error.localizedDescription)")
                return
            }
            if let methods = methods, methods.count > 0 {
                errorMessage = "This email is already registered."
            }
        }
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
                print("Registration error: \(errorMessage)")
                return
            }
            
            print("User registered successfully!")
        }
    }
}
