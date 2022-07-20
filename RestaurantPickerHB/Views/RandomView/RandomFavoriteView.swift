//
//  RandomFavoriteView.swift
//  RestaurantPickerHB
//
//  Created by Regina Paek on 7/15/22.
//

import SwiftUI

struct RandomFavoriteView: View {
    
    @FetchRequest(entity: RestaurantModel.entity(), sortDescriptors: [], animation: .easeInOut)
    
    var restaurantModels: FetchedResults<RestaurantModel>
    
    var body: some View {
        Text("Random Favorite Restaurant")
    }
}

struct RandomFavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        RandomFavoriteView()
    }
}
