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
            .navigationBarTitle("Nearby", displayMode: .large)
            .font(Font.custom("VT323-Regular", size:20))
            .refreshable {
               viewModel.getRestaurants()
                print("refreshing")
                print(viewModel.restaurants)
            }
 
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {viewModel.showFavorites.toggle() }) {
                       Text("Favorites List")
                            .padding()
                           
                    }
                }
            }//end of toolbar
            .sheet(isPresented: $viewModel.showFavorites) {
                FavoritesListView()
            }
        } 
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantListView()
            .environmentObject(RestaurantViewModel())
    }
}


