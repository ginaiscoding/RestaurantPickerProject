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


class RestaurantViewModel: ObservableObject {
    
    
    @Published var restaurants = [Restaurant]()
    @Published var cityName = ""
    @Published var region = MKCoordinateRegion()
    @Published var showFavorites = false
    @Published var favoriteRestaurants = [Restaurant]()
    @Published var randomRestaurant = [Restaurant]()
    
    var longitude: Double = 0.0
    var latitude: Double = 0.0
    
    let manager = CLLocationManager()
    
    
    
    init() {
        getRestaurants()
        
//        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [self] (nil) in
//            self.getRandomRestaurant()
//            }
    }
    
    
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
       
    }
    
    func getRestaurants() {
        let live = YelpApiService.live
        live.request("food", .init(latitude: latitude, longitude: longitude), "\(5000)", 4, true, 50)
            .assign(to: &$restaurants)
       
    }
    
    func getRandomRestaurant() {
        let restaurants = restaurants
        let random = restaurants.randomElement()
        randomRestaurant.append(random!)
        print("2.Random Restaurant is \(String(describing: random))")
    }
    
    func getRandomFavorite() {
    
    }
    
   // MARK: - LOCATION MANAGER
    func locationManager(_ manager: CLLocationManager, didUpdateLocations location: [CLLocation]) {
        guard let latestLocation: CLLocationCoordinate2D = manager.location?.coordinate else { return }

        longitude = latestLocation.longitude
        latitude = latestLocation.latitude
        print("Location is \(latestLocation)")
        
       // let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(center: latestLocation, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        }
//        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) -> Void in
//            var placeMark: CLPlacemark!
//            placeMark = placemarks?[0]
//
//            if let cityName = placeMark.locality {
//                print("City name is \(cityName)")
//                }
//        }
    }
            


// MARK: - Core Data
    
    func updateFavorite(restaurant: Restaurant, isFavorited: Bool) {
        let context = PersistentContainer.newBackgroundContext()
        context.perform {
            if isFavorited {
                self.deleteFavorite(restaurant: restaurant, with: context)
            } else {
                self.saveFavorite(restaurant: restaurant, with: context)
            }
        }
    }
    
    func saveFavorite(restaurant: Restaurant, with context: NSManagedObjectContext) {
        let model = RestaurantModel(context: context)
        model.restaurantId = restaurant.id
        model.imageUrl = restaurant.imageURL
        model.name = restaurant.name
        model.category = restaurant.formattedCategory
        model.rating = restaurant.formattedRating
        model.isFavorited = true
        do {
                try context.save()
        } catch {
            print(error)
        }
    }
    
    func deleteFavorite(restaurant: Restaurant, with context: NSManagedObjectContext) {
        
       //when deleting,fetch created model, do NOT create new model.
        let restaurantToDeleteRequest: NSFetchRequest<RestaurantModel> = RestaurantModel.fetchRequest()
                                                            //%K= first argument(keypath), %@= second argument only if String
        restaurantToDeleteRequest.predicate = NSPredicate(format: "%K = %@", #keyPath(RestaurantModel.restaurantId), restaurant.id ?? "")
        if let restaurantToDelete = try? context.fetch(restaurantToDeleteRequest).first {
            context.delete(restaurantToDelete)
        }
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
} // end of class
