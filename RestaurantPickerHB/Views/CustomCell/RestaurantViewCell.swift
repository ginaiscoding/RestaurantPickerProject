//
//  RestaurantViewCell.swift
//  RestaurantPickerHB
//
//  Created by Regina Paek on 7/12/22.
//

import SwiftUI


struct RestaurantViewCell: View {
    
    @EnvironmentObject var viewModel: RestaurantViewModel
    @Environment(\.managedObjectContext) var context
    
    @State var isFavorited: Bool = false

    
    let restaurant: Restaurant
    
    var body: some View {
        HStack{
            AsyncImage(url: restaurant.formattedImageUrl){ image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 110, height: 110)
                .cornerRadius(10)
                .padding()
            
            VStack(alignment: .leading, spacing: 5) {
                Text(restaurant.formattedName)
                Text(restaurant.formattedCategory)
                    .foregroundColor(.gray)
            HStack {
                    Text(restaurant.formattedRating)
                        .font(.system(size: 15))
                    Image(systemName: "star.fill")
                        .resizable()
                        .frame(width:12,height:12)
                        .foregroundColor(.yellow)
            }
                        
            }.frame(width: 100, height: 100 )
            VStack {
                Button(action: {
                        self.isFavorited.toggle()
                    do {
                        try viewModel.saveFavorite(restaurant: restaurant, with: context)
                        print("Favorited")
                    } catch {
                        print(error.localizedDescription)
                    }
                            }) {
                        Image(systemName: self.isFavorited == false ? "heart" : "heart.fill")
                        }
                Text("Favorite")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }.frame(width: 90, height: 100, alignment: .trailing)
        }
    }
}

struct RestaurantViewCell_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantViewCell(restaurant: .init(rating: 4.5, id: nil, alias: nil, categories: nil, name: "Sweetgreen", url: nil, location: nil, imageURL: "https://s3-media1.fl.yelpcdn.com/bphoto/j_Ut4i4j2Q4d2TVEDPVt4g/o.jpg", coordinates: nil, limit: 50) )
    }
}
