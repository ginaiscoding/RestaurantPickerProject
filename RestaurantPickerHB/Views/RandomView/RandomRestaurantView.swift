//
//  RandomRestaurantView.swift
//  RestaurantPickerHB
//
//  Created by Regina Paek on 7/14/22.
//

import SwiftUI

struct RandomRestaurantView: View {
    
    @EnvironmentObject var viewModel: RestaurantViewModel
    @Environment(\.refresh) private var refresh: RefreshAction?
   
    var body: some View {
       Text("Random Restaurant is:")
            .font(Font.custom("VT323-Regular", size: 30))
            .bold()
        List(viewModel.randomRestaurant, id: \.id) { restaurant in
        RestaurantViewCell(restaurant: restaurant)
           
            }.listStyle(.plain)
            .font(Font.custom("VT323-Regular", size:20))
        
        Button( action: {
            Task {
                viewModel.getRandomRestaurant()
            }
                
            
        }) {
            Text("PICK ANOTHER RESTAURANT")
                .font(Font.custom("VT323-Regular", size:20))
                .padding(15)
                    .background(Color.black)
                    .cornerRadius(20)
                    .shadow(radius: 8)
                .foregroundColor(.white)
        }
        
    }
}

struct RandomRestaurantView_Previews: PreviewProvider {
    static var previews: some View {
        RandomRestaurantView()
    }
}

extension RandomFavoriteView {
    

}
