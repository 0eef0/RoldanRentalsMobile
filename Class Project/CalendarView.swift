//
//  Calendar.swift
//  Class Project
//
//  Created by Ethan Roldan on 11/28/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

struct CalendarDay: Identifiable {
    let id = UUID()
    let date: Date
    let availabilityStatus: AvailabilityStatus
}

enum AvailabilityStatus {
    case available
    case unavailable
    case reserved
}

struct CalendarView: View {
    @EnvironmentObject var bookings: Bookings
    @State private var days: [CalendarDay] = []
    @State private var isLoading = true
    
    @Binding var email: String
    
    var body: some View {
        VStack {
            Text("1 Year Availability")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            VStack(alignment: .leading) {
                VStack {
                    HStack {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 20, height: 20)
                        Text("Available")
                    }
                    HStack {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 20, height: 20)
                        Text("Unavailable")
                    }
                    HStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 20, height: 20)
                        Text("Your Reservation")
                    }
                }
                .padding(.horizontal)
            }
            
            if isLoading {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else {
                List(days) { calendarDay in
                    HStack {
                        Text(dateFormatter.string(from: calendarDay.date))
                            .padding()
                        Spacer()
                        Circle()
                            .fill(circleColor(for: calendarDay.availabilityStatus))
                            .frame(width: 20, height: 20)
                    }
                }
                .navigationTitle("Next 60 Days")
                .scrollContentBackground(.hidden)
            }
        }
        .onAppear {
            updateDays()
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    private func updateDays() {
        DispatchQueue.global(qos: .userInitiated).async {
            var updatedDays: [CalendarDay] = []
            
            print("User Email: \(email)")
            
            updatedDays = (0..<365).map { dayOffset in
                var date = Calendar.current.date(byAdding: .day, value: dayOffset, to: Date())!
                date = Calendar.current.startOfDay(for: date)
                
                var status: AvailabilityStatus = .available
                
                for booking in bookings.bookings {
                    if booking.email == email {
                        for timestamp in booking.dates {
                            let bookingDate = timestamp.dateValue()
                            
                            if Calendar.current.isDate(bookingDate, inSameDayAs: date) {
                                status = .reserved
                                break
                            }
                        }
                    } else {
                        for timestamp in booking.dates {
                            let bookingDate = timestamp.dateValue()
                            
                            if Calendar.current.isDate(bookingDate, inSameDayAs: date) {
                                status = .unavailable
                                break
                            }
                        }
                    }
                    
                    if status == .reserved {
                        break
                    }
                    
                    if status == .unavailable {
                        break
                    }
                }
                
                return CalendarDay(date: date, availabilityStatus: status)
            }
            
            DispatchQueue.main.async {
                self.days = updatedDays
                self.isLoading = false
            }
        }
    }
    
    private func circleColor(for status: AvailabilityStatus) -> Color {
        switch status {
        case .available:
            return .green
        case .unavailable:
            return .red
        case .reserved:
            return .blue
        }
    }
}
