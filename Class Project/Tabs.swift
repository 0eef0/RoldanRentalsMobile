//
//  Tabs.swift
//  Class Project
//
//  Created by Ethan Roldan on 10/29/24.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct Tabs: View {
    @Binding var loggedIn:Bool
    @Binding var email:String
    
    var body: some View {
        NavigationView {
            TabView {
                Home()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                
                CalendarView(email: $email)
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("Calendar")
                    }
                
                Weather()
                    .tabItem {
                        Image(systemName: "cloud.sun.fill")
                        Text("Weather")
                    }
                
                Reserve(email: $email)
                    .tabItem {
                        Image(systemName: "book.fill")
                        Text("Reserve")
                    }
            }
            .accentColor(.purple)
            .navigationBarItems(trailing: logoutButton)
        }
    }
    
    var logoutButton: some View {
        Button("Logout") {
            loggedIn = false
            try! Auth.auth().signOut()
        }
        .foregroundColor(.purple)
    }
}
