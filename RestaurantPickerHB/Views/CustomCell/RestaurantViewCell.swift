//
//  RestaurantViewCell.swift
//  RestaurantPickerHB
//
//  Created by Regina Paek on 7/12/22.
//

import SwiftUI
import CoreData

struct RestaurantViewCell: View {
    
    @State var showDetails = false
    @State var isFavorited: Bool = false
    @EnvironmentObject var viewModel: RestaurantViewModel
    
    @FetchRequest(entity: RestaurantModel.entity(), sortDescriptors: [], animation: .easeInOut)
    var restaurantModels: FetchedResults<RestaurantModel>
    //  same as  @Environment(\.managedObjectContext) var context
    let context = PersistentContainer.viewContext
    
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
                    .font(Font.custom("VT323-Regular", size:20))
                Text(restaurant.formattedCategory)
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
                HStack {
                    Text(restaurant.formattedRating)
                        .font(.system(size: 15))
                    Image(systemName: "star.fill")
                        .resizable()
                        .frame(width:12,height:12)
                        .foregroundColor(.yellow)
                }
                
            }.frame(width: 100, height: 110 )
            //Favorites Button
            VStack {
                Button(action: {
                    
                    viewModel.updateFavorite(restaurant: restaurant, isFavorited: self.isFavorited)
                    self.isFavorited.toggle()
                    
                    
                }, label: {
                    VStack {
                        Image(systemName: self.isFavorited == false ? "heart" : "heart.fill")
                            .foregroundColor(.red)
                    
                    
                        Text(self.isFavorited == false ? "Favorite" : "Favorited")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                    }
                })
            }.frame(width: 100, height: 100)
            .buttonStyle(BorderedButtonStyle())
            
            
        }
        .overlay(
            NavigationLink(destination:
                            RestaurantListDetailView( restaurant: .init(rating: restaurant.rating, id: nil, alias: nil, categories: nil, name: restaurant.name, url: nil, location: .init(address1: restaurant.location?.address1, address2: nil, address3: nil, city: restaurant.location?.city, zipCode: restaurant.location?.zipCode, country: nil, state: nil, displayAddress: restaurant.location?.displayAddress), imageURL: restaurant.imageURL, coordinates: nil, limit: 50, phone: restaurant.phone, displayPhone: restaurant.formattedPhone)), isActive: $showDetails) { EmptyView() }
        )
        .onTapGesture {
            self.showDetails = true
        }
      
        .onAppear {
            if checkIfExists(restaurantID: restaurant.id ?? "none", name: restaurant.name ?? "none") == true {
                isFavorited = true
            }
        }
}

}
struct RestaurantViewCell_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantViewCell(restaurant: .init(rating: 4, id: nil, alias: nil, categories: nil, name: "Dumpling House", url: nil, location: nil, imageURL: "https://s3-media2.fl.yelpcdn.com/bphoto/DNfqq1zYxbJ-gsalml7wng/o.jpg", coordinates: nil, limit: 50, phone:"415-123-4567", displayPhone: "415-123-4567"))
    }
}

extension RestaurantViewCell {
    
    func checkIfExists(restaurantID: String, name: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RestaurantModel")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "restaurantID == %@", restaurantID)
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let count = try context.count(for: fetchRequest)
            if count > 0 {
                return true
            } else {
                return false
            }
        } catch {
            print(error)
            return false
        }
    }
}
