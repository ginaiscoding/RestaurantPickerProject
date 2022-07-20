//
//  LocationManager.swift
//  RestaurantPickerHB
//
//  Created by Regina Paek on 7/19/22.
//

import UIKit
import MapKit
import CoreLocation
import Combine
import SwiftUI

class LocationManager: NSObject, ObservableObject {
    lazy var geoCoder = CLGeocoder()
    @EnvironmentObject var viewModel: RestaurantViewModel
    
    @Published var locationString = ""
    @Published var invalid: Bool = false
    
    
    func openMapWithAddress() {
        
        geoCoder.geocodeAddressString(locationString) { placemarks, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.invalid = true
                }
                print(error)
            }
            guard let placemark = placemarks?.first else {
                return
            }
            guard let lat = placemark.location?.coordinate.latitude else { return }
            guard let long = placemark.location?.coordinate.longitude else { return }
            
            let coordinates = CLLocationCoordinate2DMake(lat, long)
           
            let place = MKPlacemark(coordinate: coordinates)
            
            let mapItem = MKMapItem(placemark: place)
            mapItem.name = self.locationString
            mapItem.openInMaps()
        }
    }
    
}
