//
//  StartView.swift
//  RestaurantPickerHB
//
//  Created by Regina Paek on 7/11/22.
//

import SwiftUI
import CoreLocationUI

struct StartView: View {
    
    @EnvironmentObject var viewModel: RestaurantViewModel
    

    @State var isAnimating: Bool = false
    @State var viewSelection: String? = nil
  
    var animation: SwiftUI.Animation {
        .interpolatingSpring(stiffness: 0.7, damping: 0.5)
            .repeatForever()
            .delay(isAnimating ? .random(in: 0...1) : 0)
            .speed(isAnimating ? .random(in: 0.5...1) : 0)
    }
    
    var body: some View {
        NavigationView {
        GeometryReader { proxy in
        VStack {
            ZStack {
                Image("grapes")
                    .position(x: .random(in: 0...proxy.size.width), y: .random(in: 0...proxy.size.height / 2))
                    .animation(animation)
                Image("shrimp")
                    .position(x: .random(in: 0...proxy.size.width), y: .random(in: 0...proxy.size.height / 2))
                    .animation(animation)
                Image("cupcake-2")
                    .position(x: .random(in: 0...proxy.size.width), y: .random(in: 0...proxy.size.height / 2))
                    .animation(animation)
                Image("pizza")
                    .position(x: .random(in: 0...proxy.size.width), y: .random(in: 0...proxy.size.height / 2))
                    .animation(animation)
                Image("hotdog")
                    .position(x: .random(in: 0...proxy.size.width), y: .random(in: 0...proxy.size.height / 2))
                    .animation(animation)
                Image("drumsticks")
                    .position(x: .random(in: 0...proxy.size.width), y: .random(in: 0...proxy.size.height / 2))
                    .animation(animation)
                Image("popsicle")
                    .position(x: .random(in: 0...proxy.size.width), y: .random(in: 0...proxy.size.height / 2))
                    .animation(animation)
                Image("cheese")
                    .position(x: .random(in: 0...proxy.size.width), y: .random(in: 0...proxy.size.height / 2))
                    .animation(animation)
                
            }.frame(height: proxy.size.height / 3)
                VStack{
                    Text("Food Picker")
                        .font(Font.custom("VT323-Regular", size:50))
                        .padding(15)
                        .background(Color.secondary)
                        .foregroundColor(.white)
            }
                .toolbar{
                    ToolbarItem{
                        NavigationLink(destination: RestaurantListView(), tag: "third", selection: $viewSelection) {
                        Button(action:  {
                            self.viewSelection = "third"
                        }) {
                            Image(systemName: "magnifyingglass.circle.fill")
                    }
                    }
                }
                }
            Spacer()
            //Buttons
                   VStack {
            NavigationLink(destination: RandomRestaurantView(), tag: "first", selection: $viewSelection) {
                            Button(action: {
                                self.viewSelection = "first"
                                viewModel.getRandomRestaurant()
                            }) {
                                Text("Pick From Current Location")
                                    .font(Font.custom("VT323-Regular", size:20))
                                    .padding(15)
                                    .background(Color.black)
                                    .cornerRadius(20)
                                    .shadow(radius: 8)
                                    .foregroundColor(.white)
                        }
                
                                   
            NavigationLink(destination: RandomFavoriteView(), tag: "second",
                                      selection: $viewSelection) {
                            Button(action: {
                                self.viewSelection = "second"
                               
                            }) {
                            Text("Pick from Favorites List")
                            .font(Font.custom("VT323-Regular", size:20))
                        }   .padding(15)
                            .background(Color.black)
                            .cornerRadius(20)
                            .shadow(radius: 8)
                        .foregroundColor(.white)
                        .padding()
                        }
                   
                   }
            }.onAppear {
                isAnimating.toggle()
                viewModel.requestPermission()
                }
            }
        }
    }
}
struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}

}
