//
//  YelpApiService.swift
//  RestaurantPickerHB
//
//  Created by Regina Paek on 7/11/22.
//

import Foundation
import CoreLocation
import Combine

let apiKey = "Need a Yelp Fusion Account for Api Key"

struct YelpApiService {
    
    var request: (Endpoint) -> AnyPublisher<[Restaurant], Never>
    var details: (Endpoint) -> AnyPublisher<Restaurant?, Never>
    var reviews: (Endpoint) -> AnyPublisher<[Reviews], Never>
}

extension YelpApiService {
    static let live = YelpApiService(request: { endpoint in
        
        //Url request and return [Restaurants]
        return URLSession.shared.dataTaskPublisher(for: endpoint.request)
            .map(\.data)
            .decode(type: SearchResult.self, decoder: JSONDecoder())
            .map(\.businesses)
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }, details: { endpoint in
        //URL request and return Restaurant
        return URLSession.shared.dataTaskPublisher(for: endpoint.request)
            .map(\.data)
            .decode(type: Restaurant?.self, decoder: JSONDecoder())
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }, reviews: { endpoint in
        return URLSession.shared.dataTaskPublisher(for: endpoint.request)
            .map(\.data)
            .decode(type: Review.self, decoder: JSONDecoder())
            .map(\.reviews)
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    })
}

enum Endpoint {
    case search(term: String, location: CLLocation, rating: Double?, openNow: Bool, limit: Int)
    case details(id: String)
    case reviews(id: String)
    
    var path: String {
        switch self {
        case .search:
            return "/v3/businesses/search"
        case .details(let id):
            return "/v3/businesses/\(id)"
        case .reviews(let id):
            return "/v3/businesses/\(id)/reviews"
        }
    }
    var queryItems: [URLQueryItem] {
        switch self {
        case .search(let term, let location, let rating, _, let limit):
            return [
                .init(name: "term", value: term),
                .init(name: "longitude", value: String(location.coordinate.longitude)),
                .init(name: "latitude", value: String(location.coordinate.latitude)),
                .init(name: "rating", value: String(rating ?? 4)),
                .init(name: "open_now", value: String(true)),
                .init(name: "limit", value: String(limit)),
            ]
        case .details:
            return []
        case .reviews:
            return []
        }
    }
    var request: URLRequest {
        var urlComponents = URLComponents(string: "https://api.yelp.com")!
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        return request
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
    let phone, displayPhone: String?
    let photos: [String]?
    let reviewCount: Int?
    let price: String?
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
        case rating
        case id, alias
        case categories
        case name
        case url, phone
        case displayPhone = "display_phone"
        case location
        case coordinates
        case limit
        case photos
        case reviewCount = "review_count"
        case price
    }
}
struct Review: Codable {
    let reviews: [Reviews]
}
// MARK: - Reviews
struct Reviews: Codable {
    
    let user: User?
    let rating: Int?
    let text: String?
    let timeCreated: String?
    let id: String?
    
    enum CodingKeys: String, CodingKey{
        case user
        case rating
        case text
        case timeCreated = "time_created"
        case id
    }
}

// MARK: - User
struct User: Codable {
    let name: String?
    let imageURL: String?
    
    enum CodingKeys: String, CodingKey{
        case name
        case imageURL = "image_url"
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
    let address1, address2, address3, city: String?
    let zipCode, country, state: String?
    let displayAddress: [String]?
    
    enum CodingKeys: String, CodingKey{
        case address1, address2, address3, city
        case zipCode = "zip_code"
        case country, state
        case displayAddress = "display_address"
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
    var images: [URL] {
        guard let photos = photos else { return [] }
        return photos.compactMap { URL.init(string: $0)} 
    }
    var formattedAddress: String {
        location?.displayAddress?.joined(separator: ",") ?? "none"
    }
    var formattedPhone: String {
        displayPhone ?? "none"
    }
    var formattedPhoneCall: String {
        displayPhone?.filter {!$0.isWhitespace} ?? "none"
    }
    var formattedReviewCount: String {
        String(reviewCount ?? 0)
    }
}

extension Reviews {
    
    var formattedName: String {
        user?.name ?? "none"
    }
    var formattedRating: String {
        String(rating ?? 0)
    }
    var formattedImageUrl: URL? {
        if let imageUrl = user?.imageURL {
            return URL(string: imageUrl)
        }
        return nil
    }
}

extension Restaurant {
    init(model: RestaurantModel) {
        self.init(rating: Double(model.rating ?? "%.1f"), id: model.restaurantId, alias: nil, categories: [.init(alias: nil, title: model.category)], name: model.name, url: nil, location: .init(address1: nil, address2: nil, address3: nil, city: nil, zipCode: nil, country: nil, state: nil, displayAddress: Array(arrayLiteral: model.displayAddress ?? "none")), imageURL: model.imageUrl, coordinates: nil, limit: nil, phone: String(model.phone?.filter {!$0.isWhitespace} ?? "none"), displayPhone: model.phone, photos: nil, reviewCount: Int(model.reviewCount ?? "0"), price: model.price)
        
        
    }
}

