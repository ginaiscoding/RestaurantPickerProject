//
//  RandomRestaurantView.swift
//  RestaurantPickerHB
//
//  Created by Regina Paek on 7/14/22.
//

import SwiftUI

struct RandomRestaurantView: View {
    
    @EnvironmentObject var viewModel: RestaurantViewModel
    
   
    var body: some View {
       Text("random restaurant")
     
    }
}

struct RandomRestaurantView_Previews: PreviewProvider {
    static var previews: some View {
        RandomRestaurantView()
    }
}
