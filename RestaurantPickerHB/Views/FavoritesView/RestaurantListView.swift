//
//  HomeView.swift
//  RestaurantPickerHB
//
//  Created by Regina Paek on 7/11/22.
//

import SwiftUI

struct RestaurantListView: View {
   
    @EnvironmentObject var viewModel: RestaurantViewModel
    @FetchRequest(entity: RestaurantModel.entity(), sortDescriptors: [], animation: .easeInOut)
    
    var restaurantModels: FetchedResults<RestaurantModel>
 
    
    
    var body: some View {
        NavigationView {
            
            List(viewModel.restaurants, id: \.id) { restaurant in
                RestaurantViewCell(restaurant: restaurant)
                
                }
            
            .listStyle(.plain)
            .navigationTitle(Text("Nearby \(viewModel.cityName)"))
            .font(Font.custom("VT323-Regular", size:20))
 
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {viewModel.showFavorites.toggle() }) {
                       Text("Favorites List")
                            .padding()
                            .shadow(color: .gray, radius: 20, x: -20, y: -20)
                            .overlay( RoundedRectangle(cornerRadius: 25).stroke(Color.blue, lineWidth: 5))
                    }
                }
            }//end of toolbar
            .sheet(isPresented: $viewModel.showFavorites) {
                FavoritesListView()
            }
        } 
    }
  
}

//.onappear to compare favorites in coredata with fetched restaurants from yelp. if favorite restaurant exists, (restaurant.name) then change value to true
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantListView()
            .environmentObject(RestaurantViewModel())
    }
}
