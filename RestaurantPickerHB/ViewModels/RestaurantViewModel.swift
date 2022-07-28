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
import Combine

class RestaurantViewModel: ObservableObject {
    
    @Published var restaurant: Restaurant?
    @Published var restaurants = [Restaurant]()
    @Published var cityName = ""
    @Published var region = MKCoordinateRegion()
    @Published var showFavorites = false
    @Published var randomFavoriteRestaurant = [Restaurant]()
    @Published var randomRestaurant = [Restaurant]()
    @Published var longitude: Double = 0.0
    @Published var latitude: Double = 0.0
    @Published var reviews = [Reviews]()
    @Published var showRestaurantList = false
    
    
    let context = PersistentContainer.viewContext
    
    let manager = CLLocationManager()
    
    init() {
        
        requestRestaurants()
        reviews = []
        
    }
    
    
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    func requestRestaurants(service: YelpApiService = .live) {
        service.request(
            .search(
                term: "food",
                location: .init(latitude: latitude, longitude: longitude),
                rating: 4.0,
                openNow: true,
                limit: 50
            )
        )
        .assign(to: &$restaurants)
        print(restaurants)
        
    }
    
    func requestReviews(forID id: String)  {
        let live = YelpApiService.live
        
        let reviews = live.reviews(.reviews(id: id))
            .assign(to: &$reviews)
    }
    
    func getRandomRestaurant() {
        let random = restaurants.randomElement()
        randomRestaurant.append(random!)
        if randomRestaurant.count > 1 {
            randomRestaurant.remove(at: 0)
        }
        
    }
    
    
    // MARK: - LOCATION MANAGER
    func locationManager(_ manager: CLLocationManager, didUpdateLocations location: [CLLocation]) {
        guard let latestLocation: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        longitude = latestLocation.longitude
        latitude = latestLocation.latitude
        print("Location is \(latestLocation)")
        
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(center: latestLocation, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        }
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
        model.displayAddress = restaurant.formattedAddress
        model.phone = restaurant.formattedPhoneCall
        model.reviewCount = restaurant.formattedReviewCount
        model.price = restaurant.price
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



