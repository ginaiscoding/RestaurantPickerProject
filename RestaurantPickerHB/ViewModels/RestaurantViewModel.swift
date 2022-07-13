//
//  HomeViewModel.swift
//  RestaurantPickerHB
//
//  Created by Regina Paek on 7/11/22.
//

import Foundation
import Combine
import CoreLocation
import MapKit


final class RestaurantViewModel: ObservableObject {
    
    
    @Published var businesses = [Business]()
    @Published var location = ""
    @Published var showModal: Bool
    @Published var cityName = ""
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:40, longitude: 120), span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100))
   
    let manager = CLLocationManager()
    
    init() {
        showModal = manager.authorizationStatus == .notDetermined
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        region = .init()
        request()
    }
    
    
    func requestPermission() {
        manager.requestLocation()
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations location: [CLLocation]) {
            guard let latestLocation = location.first else {
                return
            }
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(center: latestLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        }
            
        }
    
    func request() {
        let live = YelpApiService.live
        
        live.request("food", .init(latitude: 37.77, longitude: -122.43), nil)
            .assign(to: &$businesses)
    }
//    func findLocation()  {
//
//
//    }
    
} // end of class


