//
//  Class_ProjectApp.swift
//  Class Project
//
//  Created by Ethan Roldan on 10/29/24.
//

import SwiftUI
import SwiftData

import Firebase

@main
struct Class_ProjectApp: App {
    @StateObject var bookings = Bookings()
    
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(bookings)
        }
    }
}
