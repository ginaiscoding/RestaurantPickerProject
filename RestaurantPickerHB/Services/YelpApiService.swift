//
//  YelpApiService.swift
//  RestaurantPickerHB
//
//  Created by Regina Paek on 7/11/22.
//

import Foundation
import CoreLocation
import Combine

let apiKey = "RY-b8erXE6U0l0HMrGr3-6U2tnB1EnGCBZ_NpJRRFEG9Cb9L56w2NdhoZD7Cvg4s0UjPnh7EPwdyQz__kVT0q2BEscYvMAAzbCk55oaviVzVDYnsub-2QyhhA2HMYnYx"

struct YelpApiService {
    
    var request: (String, CLLocation, String?, Double?, Bool, Int) -> AnyPublisher<[Restaurant], Never>
   
}

extension YelpApiService {
    static let live = YelpApiService { term, location, radius, rating, opennow, limit in
        
        var urlComponents = URLComponents(string: "https://api.yelp.com")!
        urlComponents.path = "/v3/businesses/search"
        urlComponents.queryItems = [
            .init(name: "term", value: term),
            .init(name: "longitude", value: String(location.coordinate.longitude)),
            .init(name: "latitude", value: String(location.coordinate.latitude)),
            .init(name: "radius", value: radius),
            .init(name: "rating", value: String(rating ?? 4)),
            .init(name: "open_now", value: String(true)),
            .init(name: "limit", value: String(limit)),
           
            
        ]
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        //Url request and return
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: SearchResult.self, decoder: JSONDecoder())
            .map(\.businesses)
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
      
    }
}


// MARK: - Search Result
struct SearchResult: Codable {
    let businesses: [Restaurant]
}
// MARK: - Restaurant struct
struct Restaurant: Codable {

   
    let rating: Double?
    let id, alias: String?
    let categories: [Category]?
    let name: String?
    let url: String?
    let location: Location?
    let imageURL: String?
    let coordinates: Coordinates?
    let limit: Int?
   
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
        case rating
        case id, alias
        case categories
        case name
        case url
        case location
        case coordinates
        case limit
      
    }
}

// MARK: - Category
struct Category: Codable {
    let alias, title: String?
}

// MARK: - Coordinates
struct Coordinates: Codable {
    let latitude, longitude: Double?
    
}
// MARK: - Location
struct Location: Codable {
    let city, country, address2, address3: String?
    let state, address1, zipCode: String?
    
    enum CodingKeys: String, CodingKey{
        case city, country, address2, address3, state, address1
        case zipCode = "zip_code"
    }
}

extension Restaurant {
    
    var formattedName: String {
        name ?? "none"
    }
    var formattedRating: String {
        String(format: "%.1f", rating ?? 0.0)
    }
    var formattedCategory: String {
        categories?.first?.title ?? "none"
    }
    var formattedImageUrl: URL? {
        if let imageUrl = imageURL {
            return URL(string: imageUrl)
        }
        return nil
          
    }
}

extension Restaurant {
    init(model: RestaurantModel) {
        self.init(rating: Double(model.rating ?? "%.1f"), id: model.restaurantId, alias: nil, categories: [.init(alias: nil, title: model.category)], name: model.name, url: nil, location: nil, imageURL: model.imageUrl, coordinates: nil, limit: nil)
    }
}

