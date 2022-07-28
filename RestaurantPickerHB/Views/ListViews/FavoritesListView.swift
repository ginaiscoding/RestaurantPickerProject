//
//  FavoritesListView.swift
//  RestaurantPickerHB
//
//  Created by Regina Paek on 7/12/22.
//
//LIST OF FAVORITED RESTAURANTS 


import CoreData
import SwiftUI


struct FavoritesListView: View {
    @State var showFavorites = false
    
    @EnvironmentObject var viewModel: RestaurantViewModel
    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: RestaurantModel.entity(), sortDescriptors: [], animation: .easeInOut)
    var restaurantModels: FetchedResults<RestaurantModel>
    var faveRestaurants: [Restaurant] {
        restaurantModels.map(Restaurant.init(model:))
    }
    
    var body: some View {
        HStack{
        Text("Favorites List")
            .font(Font.custom("VT323-Regular", size:40))
                    .fontWeight(.bold)
                    .padding()
        Button(action: {
            viewModel.showFavorites.toggle()
       }){
           Text("Done").bold()
       } .padding(.leading)
        }
        VStack(alignment: .leading, spacing: 10) {
         
               
            List(faveRestaurants, id: \.id) { restaurant in
                FavoritesViewCell(restaurant: restaurant)
                }.listStyle(.plain)
        }
    }
}

struct FavoritesListView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesListView()
    }
}
