//
//  RestaurantViewCell.swift
//  RestaurantPickerHB
//
//  Created by Regina Paek on 7/12/22.
//

import SwiftUI
import CoreData

struct RestaurantViewCell: View {
    
    @EnvironmentObject var viewModel: RestaurantViewModel
    @FetchRequest(entity: RestaurantModel.entity(), sortDescriptors: [], animation: .easeInOut)
    
    var restaurantModels: FetchedResults<RestaurantModel>
    
    //  same as  @Environment(\.managedObjectContext) var context
    let context = PersistentContainer.viewContext
    
    @State var isFavorited: Bool = false
    
    let restaurant: Restaurant
    
    var body: some View {
        HStack{
            AsyncImage(url: restaurant.formattedImageUrl){ image in
                image.resizable()
            } placeholder: {
                Text("No Image Found..")
                    .background(.gray)
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
            //Favorites Button
            VStack {
                Button(action: {
                      
                    viewModel.updateFavorite(restaurant: restaurant, isFavorited: self.isFavorited)
                    self.isFavorited.toggle()

                    
                            }) {
                        Image(systemName: self.isFavorited == false ? "heart" : "heart.fill")
                                .foregroundColor(.red)
                                
                        Text(self.isFavorited == false ? "Favorite" : "Favorited")
                                .font(.system(size: 10))
                                .foregroundColor(.secondary)
                            }
               
            }.frame(width: 90, height: 100, alignment: .trailing)
        }
            //         .onAppear {
//            if restaurant.name ?? "" == restaurantModels {
//                isFavorited = true
//            }
//        }
    }
}

struct RestaurantViewCell_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantViewCell(restaurant: .init(rating: 4.5, id: nil, alias: nil, categories: nil, name: "Sweetgreen", url: nil, location: nil, imageURL: "https://s3-media1.fl.yelpcdn.com/bphoto/j_Ut4i4j2Q4d2TVEDPVt4g/o.jpg", coordinates: nil, limit: 50) )
    }
}
