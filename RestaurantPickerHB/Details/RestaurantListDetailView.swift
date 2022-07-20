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

struct RestaurantListDetailView: View {
    @EnvironmentObject var viewModel: RestaurantViewModel
    @ObservedObject var locationManager = LocationManager()
    
    let restaurant: Restaurant
    
    var body: some View {
        VStack{
            AsyncImage(url: restaurant.formattedImageUrl){ image in
            image.resizable()
        } placeholder: {
            Text("No Image Found..")
                .background(.gray)
        }.frame(width: 210, height: 210)
                .cornerRadius(10)
                .padding()
        VStack(alignment: .leading, spacing: 2) {
            Group {
                Text(restaurant.formattedName)
                    .font(.custom("VT323-Regular", size: 30))
                Text("\(restaurant.formattedRating) ⭐️")
                    .font(.system(size: 15))
            }
            Group {
                HStack {
                    Text("📞")
                    Link("\(restaurant.formattedPhone)", destination: URL(string: "tel:415-123-4567")!)
                }
                Button{
                    locationManager.locationString = restaurant.formattedAddress
                    locationManager.openMapWithAddress()
                   
                } label: {
                    Text("📍 \(restaurant.formattedAddress)")
                }
                .alert(isPresented: $locationManager.invalid) {
                    Alert(title: Text("Important Message"), message: Text("Unable to find Address"), dismissButton: .default(Text("OK"), action: {
                        locationManager.invalid = false
                        locationManager.locationString = ""
                    }))
                }
            }
        }
        }
        }
//    func openMap(Address: String){
//
//        UIApplication.shared.openURL(NSURL(string: "https://maps.apple.com/?address=\(Address)")! as URL)
//
//   }
  
}
struct RestaurantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantListDetailView(restaurant: .init(rating: 4, id: nil, alias: nil, categories: nil, name: "Dumpling House", url: nil, location: nil, imageURL: "https://s3-media2.fl.yelpcdn.com/bphoto/DNfqq1zYxbJ-gsalml7wng/o.jpg", coordinates: nil, limit: 50, phone:"415-123-4567", displayPhone: "415-123-4567") )
    }
    }

