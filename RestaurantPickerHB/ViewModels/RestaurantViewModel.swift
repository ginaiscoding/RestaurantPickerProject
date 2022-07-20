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
import SwiftUI


class RestaurantViewModel: ObservableObject {
    
    
    @Published var restaurants = [Restaurant]()
    @Published var cityName = ""
    @Published var region = MKCoordinateRegion()
    @Published var showFavorites = false
    @Published var randomFavoriteRestaurant = [Restaurant]()
    @Published var randomRestaurant = [Restaurant]()
    @Published var longitude: Double = 0.0
    @Published var latitude: Double = 0.0
    
    let manager = CLLocationManager()
    
    let context = PersistentContainer.viewContext
    
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
        live.request("food", .init(latitude: latitude, longitude: longitude), 4.0, true, 50)
            .assign(to: &$restaurants)
       
    }
   
    func getRandomRestaurant() {
        let restaurants = restaurants
        let random = restaurants.randomElement()
        randomRestaurant.append(random!)
        if randomRestaurant.count > 1 {
        randomRestaurant.remove(at: 0)
        }
        print("2.Random Restaurant is \(String(describing: random))")
    }
    
    func getRandomFavorite() {
       // let fetchRequest = NSFetchRequest<RestaurantModel>(entityName: "RestaurantModel")
        @FetchRequest(entity: RestaurantModel.entity(), sortDescriptors: [], animation: .easeInOut)
        
        var restaurantModels: FetchedResults<RestaurantModel>
//        do {
//            let fetchRequestCount = try? context.count(for: fetchRequest)
//        fetchRequest.fetchOffset = Int.random(in: 0...(fetchRequestCount ?? 0))
//        fetchRequest.fetchLimit = 1
//
//        do {
//            let randomFavorite = try context.fetch(fetchRequest)
//            //randomFavoriteRestaurant.append(randomFavorite)
//            print("RANDOM FAVORITE IS \(randomFavorite)")
//        } catch {
//            print(error)
//
//        }
//        } catch {
//            print(error)
//        }
//        let randomFave = restaurantModels.randomElement()
//        print("RANDOM FAVE IS \(String(describing: randomFave))")
       
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
