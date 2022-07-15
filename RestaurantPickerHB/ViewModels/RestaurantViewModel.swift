//
//  HomeViewModel.swift
//  RestaurantPickerHB
//
//  Created by Regina Paek on 7/11/22.
//

import Foundation
import CoreLocation
import MapKit
import CoreData


final class RestaurantViewModel: ObservableObject {
    
    
    @Published var restaurants = [Restaurant]()
    @Published var cityName = ""
    @Published var region = MKCoordinateRegion()
    @Published var showFavorites = false
    @Published var favoriteRestaurants: [String] = []
    @Published var randomRestaurant: [String] = []
    
    var longitude: Double = 0.0
    var latitude: Double = 0.0
    
    let manager = CLLocationManager()
    
    var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RestaurantModel")
        container.loadPersistentStores { _, error in
            guard error == nil else {
                fatalError("Could not find core data!")
            }
        }
        return container
    }()
    
    init() {
        getRestaurants()
        
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [self] (nil) in
            self.getRandomRestaurant()
            print("Random Restaurant is \(self.randomRestaurant)")
        }
     
    }
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
       
    }
    
    func getRestaurants() {
        let live = YelpApiService.live
        live.request("food", .init(latitude: latitude, longitude: longitude), nil, 4, true, 50)
            .assign(to: &$restaurants)
        
    }
    
    func getRandomRestaurant()  {
        let restaurants = restaurants
        let random = restaurants.randomElement()
      
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations location: [CLLocation]) {
        guard let latestLocation: CLLocationCoordinate2D = manager.location?.coordinate else { return }

        longitude = latestLocation.longitude
        latitude = latestLocation.latitude
        
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
      
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) -> Void in
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            if let cityName = placeMark.locality {
                print("City name is \(cityName)")
                
            }
                    }
        print(location)
        print(longitude)
        print(latestLocation)
        }
            


// MARK: - Core Data

func saveFavorite(restaurant: Restaurant, with context: NSManagedObjectContext) throws {
    let model = RestaurantModel(context: context)
    model.id = restaurant.id
    model.imageUrl = restaurant.imageURL
    model.name = restaurant.name
    model.category = restaurant.formattedCategory
    model.rating = restaurant.formattedRating
    try context.save()
}
} // end of class
