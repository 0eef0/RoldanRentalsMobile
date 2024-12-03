//
//  Booking.swift
//  Class Project
//
//  Created by Ethan Roldan on 11/30/24.
//

import FirebaseCore

struct Booking:Identifiable {
    var id = UUID()
    var email:String
    var dates:[Timestamp]
}
