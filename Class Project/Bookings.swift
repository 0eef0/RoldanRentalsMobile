//
//  Bookings.swift
//  Class Project
//
//  Created by Ethan Roldan on 11/30/24.
//

import Firebase

class Bookings: ObservableObject {
    @Published var bookings: [Booking] = []
    
    init() {
        fetchBookings()
    }
    
    func fetchBookings() {
        bookings.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("bookings")
        
        ref.getDocuments { snapshot, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    print("Error fetching documents: \(error!.localizedDescription)")
                    return
                }
                
                print("Getting docs")
                
                if let snapshot = snapshot {
                    for document in snapshot.documents {
                        let data = document.data()
                        
                        let email = data["email"] as? String ?? "Unknown"
                        let dates = data["dates"] as? [Timestamp] ?? []
                        
                        let booking = Booking(email: email, dates: dates)
                        self.bookings.append(booking)
                    }
                }
            }
        }
    }
    
    func addBooking(email:String, dates:[Date]) {
        let db = Firestore.firestore()
        let ref = db.collection("bookings").document(email)
        ref.setData([
            "email": email,
            "dates": dates
        ]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}

