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
                Text("Image unable to load")
                
            }
            .frame(width: 100, height: 100)
            .cornerRadius(10)
            .padding(10)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(restaurant.formattedName)
                    .font(Font.custom("VT323-Regular", size:20))
                HStack{
                    Text(restaurant.formattedCategory)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                    Text("·")
                        .foregroundColor(.secondary)
                    Text(restaurant.price ?? "none")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                    Text("·")
                        .foregroundColor(.secondary)
                }
                HStack {
                    //Text(restaurant.formattedRating)
                    reviewStars()
                    Text(restaurant.formattedReviewCount)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                }
                
            }.frame(width: 150, height: 100 )
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
            }.frame(width: 70, height: 80)
                .buttonStyle(BorderedButtonStyle())
            
        }
        .overlay(
            NavigationLink(destination:
                            RestaurantListDetailView( restaurant: .init(rating: restaurant.rating, id: nil, alias: nil, categories: restaurant.categories, name: restaurant.name, url: nil, location: .init(address1: restaurant.location?.address1, address2: nil, address3: nil, city: restaurant.location?.city, zipCode: restaurant.location?.zipCode, country: nil, state: nil, displayAddress: restaurant.location?.displayAddress), imageURL: restaurant.imageURL, coordinates: nil, limit: 50, phone: restaurant.phone, displayPhone: restaurant.formattedPhone, photos: restaurant.photos, reviewCount: restaurant.reviewCount, price: restaurant.price)), isActive: $showDetails) { EmptyView() }
        )
        .onTapGesture {
            
            viewModel.requestReviews(forID: restaurant.id ?? "none")
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
        RestaurantViewCell(restaurant: .init(rating: 4, id: nil, alias: nil, categories: nil, name: "Dumpling House", url: nil, location: nil, imageURL: "https://s3-media2.fl.yelpcdn.com/bphoto/DNfqq1zYxbJ-gsalml7wng/o.jpg", coordinates: nil, limit: 50, phone:"415-123-4567", displayPhone: "415-123-4567", photos: ["https://s3-media2.fl.yelpcdn.com/bphoto/DNfqq1zYxbJ-gsalml7wng/o.jpg","https://s3-media2.fl.yelpcdn.com/bphoto/DNfqq1zYxbJ-gsalml7wng/o.jpg"], reviewCount: 4, price: "$$$"))
            .environmentObject(RestaurantViewModel())
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
extension RestaurantViewCell {
    
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

