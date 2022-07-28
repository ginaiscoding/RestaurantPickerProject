//
//  HomeView.swift
//  RestaurantPickerHB
//
//  Created by Regina Paek on 7/11/22.
//
// LIST OF RESTAURANTS NEAR CURRENT LOCATION

import SwiftUI

struct RestaurantListView: View {
    
    
    @EnvironmentObject var viewModel: RestaurantViewModel
    @FetchRequest(entity: RestaurantModel.entity(), sortDescriptors: [], animation: .easeInOut)
    var restaurantModels: FetchedResults<RestaurantModel>
    var body: some View {
        
        NavigationView{
            VStack{
                HStack{
                Text("Nearby Restaurants")
                    .font(Font.custom("VT323-Regular", size:35))
                    .fontWeight(.bold)
                    .padding()
                     Button(action: {
                         viewModel.showRestaurantList.toggle()
                    }){
                        Text("Done").bold()
                    } .padding(.leading)
                }
                List(viewModel.restaurants, id: \.id) { restaurant in
                    
                    RestaurantViewCell(restaurant: restaurant)
                    
                }
                .listStyle(.plain)
                .navigationBarTitle("")
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                .refreshable {
                    
                    viewModel.restaurants.shuffle()
                    
                }
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



