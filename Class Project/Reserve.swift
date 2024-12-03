//
//  Reserve.swift
//  Class Project
//
//  Created by Ethan Roldan on 11/28/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

struct Reserve: View {
    @EnvironmentObject var bookings: Bookings
    
    @State private var fromDate = Date()
    @State private var toDate = Date()
    @State private var errorMessage: String? = nil
    @State private var confirmationMessage: String? = nil
    
    @Binding var email: String
        
    var body: some View {
        VStack(spacing: 20) {
            Text("Book Your Stay")
                .font(.largeTitle)
                .padding()
            
            VStack(spacing: 15) {
                VStack(alignment: .leading) {
                    Text("From:")
                        .font(.headline)
                    DatePicker("Select Start Date", selection: $fromDate, in: Date()..., displayedComponents: .date)
                        .datePickerStyle(CompactDatePickerStyle())
                        .labelsHidden()
                        .padding(.horizontal)
                }
                
                VStack(alignment: .leading) {
                    Text("To:")
                        .font(.headline)
                    DatePicker("Select End Date", selection: $toDate, in: fromDate..., displayedComponents: .date)
                        .datePickerStyle(CompactDatePickerStyle())
                        .labelsHidden()
                        .padding(.horizontal)
                }
            }
            
            if let message = errorMessage {
                Text(message)
                    .foregroundColor(.red)
                    .font(.subheadline)
                    .padding(.top)
            } else if let message = confirmationMessage {
                Text(message)
                    .foregroundColor(.green)
                    .font(.subheadline)
                    .padding(.top)
            }
            
            Button("Book") {
                handleBooking()
            }
            .frame(width: 75, height: 10)
            .padding()
            .background(
                LinearGradient(gradient: Gradient(colors: [.purple, .orange]), startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .foregroundColor(.white)
            .cornerRadius(30)
        }
        .padding()
        .navigationBarTitle("Booking", displayMode: .inline)
    }
    
    func handleBooking() {
        errorMessage = nil
        confirmationMessage = nil
        
        if let existingBooking = bookings.bookings.first(where: { $0.email == email }) {
            errorMessage = "You already have a booking. You cannot make another one."
            return
        }
        
        for existingBooking in bookings.bookings {
            let existingBookingDates = existingBooking.dates.map { $0.dateValue() }
            if checkForOverlap(existingBookingDates: existingBookingDates) {
                errorMessage = "The selected dates overlap with an existing booking."
                return
            }
        }
        
        var currentDate = fromDate
        let calendar = Calendar.current
        
        var dates: [Date] = []
        
        while currentDate <= toDate {
            dates.append(currentDate)
            
            if let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) {
                currentDate = nextDate
            } else {
                break
            }
        }
        
        bookings.addBooking(email: email, dates: dates)
        
        confirmationMessage = "Your booking was successful! It may take a moment to reflect on the calendar."
    }
    
    func checkForOverlap(existingBookingDates: [Date]) -> Bool {
        for date in existingBookingDates {
            if (date >= fromDate && date <= toDate) ||
                (fromDate >= date && fromDate <= toDate) {
                return true
            }
        }
        return false
    }
}
