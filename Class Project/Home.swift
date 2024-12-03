//
//  Home.swift
//  Class Project
//
//  Created by Ethan Roldan on 11/28/24.
//

import SwiftUI
import MapKit

struct Home: View {
    @State private var latitude: CLLocationDegrees = 0.0
    @State private var longitude: CLLocationDegrees = 0.0

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Welcome to Puerto Peñasco!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                Text("Discover a hidden paradise just 3.5 hours from Phoenix! Puerto Peñasco offers pristine beaches, thrilling adventures like snorkeling, fishing, and whale watching, plus incredible local eats and vibrant restaurants. Escape the ordinary and dive into the perfect blend of relaxation and excitement on the stunning Sea of Cortez!")
                    .font(.body)
                    .padding([.leading, .trailing])
                
                Image("IMG_4236")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
                Text("Indulge in luxury at our Puerto Peñasco condo, set in a five-star community with top-tier service, gourmet restaurants, a lazy river, and multiple pools. Relaxation and elegance await!")
                    .font(.body)
                    .padding([.leading, .trailing])
                
                Image("IMG_4233")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
                Text("Escape to paradise in Puerto Peñasco, where our cozy condo awaits just steps from the beach! Picture yourself unwinding on the balcony with breathtaking sunsets painting the sky, or strolling along sandy shores. With all the comforts of home and the beauty of the Sea of Cortez, your perfect getaway begins here.")
                    .font(.body)
                    .padding([.leading, .trailing, .bottom])
                
                Text("Good Eats!")
                    .font(.headline)
                
                Text("El Malecón, a vibrant waterfront area in many Latin American cities, is home to a variety of restaurants offering a mix of traditional and contemporary cuisine. Whether you're craving fresh seafood, ceviche, or local specialties, the restaurants along El Malecón deliver a delightful culinary experience with stunning views of the ocean or city skyline. Many places feature open-air patios, allowing diners to enjoy the breeze while savoring everything from casual street food to gourmet meals. The area is perfect for both a quick bite and a leisurely dining experience, making it a popular spot for locals and tourists alike. See all of the restaurants in the area below!")
                    .font(.body)
                    .padding([.leading, .trailing, .bottom])
                RestaurantMapView()
                    .edgesIgnoringSafeArea(.all)
                    .frame(height: 400)
            }
        }
    }
}

struct RestaurantMapView: View {
    @State private var region: MKCoordinateRegion
    @State private var annotations: [RestaurantAnnotation] = []
    
    init() {
        // 31.30323313179595, -113.54956828144056
        let centerCoordinate = CLLocationCoordinate2D(latitude: 31.30323313179595, longitude: -113.54956828144056)
        _region = State(initialValue: MKCoordinateRegion(
            center: centerCoordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
    }
    
    var body: some View {
        Map(
            coordinateRegion: $region,
            annotationItems: annotations
        ) { annotation in
            MapAnnotation(coordinate: annotation.coordinate) {
                VStack {
                    Text(annotation.name)
                        .font(.caption)
                        .padding(5)
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(8)
                        .shadow(radius: 5)
                    
                    Image(systemName: "pin.circle.fill")
                        .foregroundColor(.red)
                        .font(.title)
                }
            }
        }
        .onAppear {
            fetchNearbyRestaurants()
        }
    }
    
    private func fetchNearbyRestaurants() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "restaurant"
        request.region = region
        
        let search = MKLocalSearch(request: request)
        
        search.start { response, error in
            guard let response = response else {
                print("Error searching for restaurants: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let newAnnotations = response.mapItems.compactMap { item -> RestaurantAnnotation? in
                let annotation = RestaurantAnnotation(
                    id: item.placemark.coordinate.latitude + item.placemark.coordinate.longitude,
                    name: item.name ?? "Unknown",
                    coordinate: item.placemark.coordinate
                )
                return annotation
            }
            
            DispatchQueue.main.async {
                self.annotations = newAnnotations
            }
        }
    }
}

struct RestaurantAnnotation: Identifiable {
    var id: Double
    var name: String
    var coordinate: CLLocationCoordinate2D
}
