//
//  RestaurantDetailView.swift
//  RestaurantPickerHB
//
//  Created by Regina Paek on 7/11/22.
//

import SwiftUI
import MapKit
import UIKit
import Foundation
import Combine

struct RestaurantListDetailView: View {
    @EnvironmentObject var viewModel: RestaurantViewModel
    @ObservedObject var locationManager = LocationManager()
    
    @State var restaurant: Restaurant
    
    var body: some View {
        
        VStack{
            Text(" ")
            AsyncImage(url: URL(string: restaurant.imageURL ?? "none")){ image in
                image.resizable()
            } placeholder: {
                Text("No Image Found..")
                    .background(Color.gray)
                
            }.frame(width: 210, height: 210)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.black, lineWidth: 5))
            
            VStack(alignment: .center, spacing: 2) {
                Group {
                    Text(restaurant.formattedName)
                        .font(.custom("VT323-Regular", size: 40))
                    HStack{
                        Text(restaurant.formattedCategory)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("·")
                            .foregroundColor(.secondary)
                        Text(restaurant.price ?? "none")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("·")
                            .foregroundColor(.secondary)
                    }
                    HStack{
                        reviewStars()
                        Text(restaurant.formattedReviewCount)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                Group {
                    HStack {
                        Text("📞")
                        Link("\(restaurant.formattedPhone)", destination: URL(string: "tel:\(restaurant.formattedPhoneCall)")!)
                        
                    } .padding(.bottom)
                    Button{
                        locationManager.locationString = restaurant.formattedAddress
                        locationManager.openMapWithAddress()
                        
                    } label: {
                        HStack{
                            Text("📍")
                            Text(restaurant.formattedAddress)
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(width: 200)
                        .multilineTextAlignment(.center)
                        .padding(.bottom)
                        
                    }
                    .alert(isPresented: $locationManager.invalid) {
                        Alert(title: Text("Important Message"), message: Text("Unable to find Address"), dismissButton: .default(Text("OK"), action: {
                            locationManager.invalid = false
                            locationManager.locationString = ""
                        }))
                    }
                    Divider()
                    
                    if !viewModel.reviews.isEmpty {
                        TabView{
                            
                            ForEach(viewModel.reviews, id: \.id) { reviews in
                                ReviewsCell(reviews: reviews)
                            }
                        } .tabViewStyle(.page)
                            .indexViewStyle(.page(backgroundDisplayMode: .always))
                    } else {
                        Text("no reviews")
                    }
                    
                }
                
                
                
            } 
            
        }
        
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
}
struct RestaurantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantListDetailView(restaurant: .init(rating: 4, id: nil, alias: nil, categories: nil, name: "Dumpling House", url: nil, location: nil, imageURL: "https://s3-media2.fl.yelpcdn.com/bphoto/DNfqq1zYxbJ-gsalml7wng/o.jpg", coordinates: nil, limit: 50, phone:"415-123-4567", displayPhone: "415-123-4567", photos: ["https://s3-media2.fl.yelpcdn.com/bphoto/DNfqq1zYxbJ-gsalml7wng/o.jpg","https://s3-media2.fl.yelpcdn.com/bphoto/DNfqq1zYxbJ-gsalml7wng/o.jpg","https://s3-media2.fl.yelpcdn.com/bphoto/DNfqq1zYxbJ-gsalml7wng/o.jpg"], reviewCount: 100, price: "$$$") )
            .environmentObject(RestaurantViewModel())
    }
}

extension RestaurantListDetailView {
    
    func reviewStars() -> Image {
        switch restaurant.formattedRating {
        case "3.0":
            return Image("regular_3")
        case "3.5":
            return Image("regular_3_half")
        case "4.0":
            return Image("regular_4")
        case "4.5":
            return Image("regular_4_half")
        case "5.0":
            return Image("regular_5")
        default:
            return Image("regular_0")
        }
    }
    
}
