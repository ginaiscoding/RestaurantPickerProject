//
//  FavoritesListView.swift
//  RestaurantPickerHB
//
//  Created by Regina Paek on 7/12/22.
//
import CoreData
import SwiftUI

struct FavoritesListView: View {
    
    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: RestaurantModel.entity(), sortDescriptors: [], animation: .easeInOut)
    
    var restaurantModels: FetchedResults<RestaurantModel>
    var restaurants: [Restaurant] {
        restaurantModels.map(Restaurant.init(model:))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
        Text("Favorite Restaurants")
                .font(.title)
            Divider()
            List(restaurants, id: \.id) { restaurant in
                RestaurantViewCell(restaurant: restaurant)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true){
                        Button("Delete", role: .destructive) {
                            if let id = restaurant.id {
                                deleteModel(for: id)
                            }
                        }
                    }
            }.listStyle(.plain)
            Spacer()
    }
  }
    func deleteModel(for id: String) {
        if let model = restaurantModels.first(where: { $0.id == id })
         {
             context.delete(model)
            do {
                try context.save()
            } catch { print(error.localizedDescription)}
         }
    }
}

struct FavoritesListView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesListView()
    }
}
