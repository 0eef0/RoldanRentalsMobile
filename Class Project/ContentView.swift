//
//  ContentView.swift
//  Class Project
//
//  Created by Ethan Roldan on 10/29/24.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var loggedIn: Bool = false
    @State private var registering: Bool = false
    
    @State private var listenerHandle: AuthStateDidChangeListenerHandle? = nil
    
    var body: some View {
        VStack {
            if loggedIn {
                Tabs(loggedIn: $loggedIn, email: $email)
            } else if registering {
                Register(email: $email, registering: $registering)
            } else {
                ZStack {
                    Image(.IMG_4232)
                        .resizable()
                        .scaledToFill()
                        .frame(minWidth: 0)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Spacer()
                        
                        Text("Roldan Rentals")
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
                        
                        HStack {
                            Spacer()
                            
                            Button("Register") {
                                registering = true
                            }
                            .frame(width: 75, height: 10)
                            .padding()
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(30)
                            
                            Spacer()
                            
                            Button("Login") {
                                Task {
                                    print("Attempting login")
                                    do {
                                        try await login()
                                    } catch {
                                        print("Login failed: \(error)")
                                    }
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
        }
        .onAppear {
            if let currentUser = Auth.auth().currentUser {
                loggedIn = true
                email = currentUser.email!
                print("User already logged in: \(currentUser.email ?? "unknown")")
            } else {
                loggedIn = false
                print("No user logged in.")
            }

            listenerHandle = Auth.auth().addStateDidChangeListener { auth, user in
                if let user = user {
                    loggedIn = true
                    print("User logged in: \(user.email ?? "unknown")")
                } else {
                    loggedIn = false
                    print("User logged out.")
                }
            }
        }
        .onDisappear {
            if let handle = listenerHandle {
                Auth.auth().removeStateDidChangeListener(handle)
            }
        }
    }
    
    func login() async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            loggedIn = true
            print("Successfully logged in: \(result.user.email ?? "")")
        } catch {
            print("Failed to log in: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(Bookings())
}
