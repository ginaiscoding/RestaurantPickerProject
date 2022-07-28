//
//  StartView.swift
//  RestaurantPickerHB
//
//  Created by Regina Paek on 7/11/22.
//

import SwiftUI
import CoreLocationUI

struct StartView: View {
    @FetchRequest(entity: RestaurantModel.entity(), sortDescriptors: [], animation: .easeInOut)
    var restaurantModels: FetchedResults<RestaurantModel>
    @EnvironmentObject var viewModel: RestaurantViewModel
    
    @State var isAnimating: Bool = false
    @State var viewSelection: String? = nil
    @State var animationValue = false
    
    var animation: SwiftUI.Animation {
        .interpolatingSpring(stiffness: 2, damping: 0.5)
        .repeatForever()
        .delay(isAnimating ? .random(in: 0...0.5) : 0)
        .speed(isAnimating ? .random(in: 0...2) : 0)
    }
    
    var body: some View {
        
        NavigationView {
            GeometryReader { proxy in
                VStack {
                    ZStack {
                        
                        Group {
                            Image("grapes")
                                .position(x: .random(in: 0...proxy.size.width), y: .random(in: 0...proxy.size.height / 2))
                                .animation(animation, value: animationValue)
                            
                            Image("shrimp")
                                .position(x: .random(in: 0...proxy.size.width), y: .random(in: 0...proxy.size.height / 2))
                                .animation(animation, value: animationValue)
                                .task {
                                    animationValue.toggle()
                                    isAnimating.toggle()
                                }
                            Image("cupcake-2")
                                .position(x: .random(in: 0...proxy.size.width), y: .random(in: 0...proxy.size.height / 2))
                                .animation(animation, value: animationValue)
                                .task {
                                    animationValue.toggle()
                                    isAnimating.toggle()
                                }
                            
                            Image("pizza")
                                .position(x: .random(in: 0...proxy.size.width), y: .random(in: 0...proxy.size.height / 2))
                                .animation(animation, value: animationValue)
                                .task {
                                    animationValue.toggle()
                                    isAnimating.toggle()
                                }
                            Image("hotdog")
                                .position(x: .random(in: 0...proxy.size.width), y: .random(in: 0...proxy.size.height / 2))
                                .animation(animation, value: animationValue)
                                .task {
                                    animationValue.toggle()
                                    isAnimating.toggle()
                                }
                            // MARK: - APP TITLE
                            VStack{
                                HStack{
                                    Image("fork")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                    Text("Random Yum")
                                        .font(Font.custom("VT323-Regular", size:70))
                                        .fontWeight(.bold)
                                        .multilineTextAlignment(.center)
                                    Image("fork2")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                }
                                Text("An app that helps you pick a random restaurant when you cant decide!")
                                    .font(Font.custom("VT323-Regular", size:20))
                                    .multilineTextAlignment(.center)
                            }
                            .padding(20)
                            .background(Color.black.opacity(0.75))
                            .cornerRadius(20)
                            .foregroundColor(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.black, lineWidth: 8)
                            )
                            Image("drumsticks")
                                .position(x: .random(in: 0...proxy.size.width), y: .random(in: 0...proxy.size.height / 2))
                                .animation(animation, value: animationValue)
                                .task {
                                    animationValue.toggle()
                                    isAnimating.toggle()
                                }
                            Image("popsicle")
                                .position(x: .random(in: 0...proxy.size.width), y: .random(in: 0...proxy.size.height / 2))
                                .animation(animation, value: animationValue)
                                .task {
                                    animationValue.toggle()
                                    isAnimating.toggle()
                                }
                            Image("cheese")
                                .position(x: .random(in: 0...proxy.size.width), y: .random(in: 0...proxy.size.height / 2))
                                .animation(animation, value: animationValue)
                                .task {
                                    animationValue.toggle()
                                    isAnimating.toggle()
                                }
                        }
                        .frame(height: proxy.size.height / 2)
                        
                        Spacer()
                        
                    }
        // MARK: - Top Tool Bar Buttons
                    //search button
                    .toolbar{
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {viewModel.showRestaurantList.toggle() }) {
                                VStack{
                                Image(systemName: "magnifyingglass.circle.fill")
                                        .shadow(color: .gray, radius: 2, x: 3, y: 2)
                                Text("Search")
                                        .font(Font.custom("VT323-Regular", size: 15))
                                }
                            }
                        }
                    }//end of toolbar
                    .sheet(isPresented: $viewModel.showRestaurantList, onDismiss: nil){
                        RestaurantListView()
                    }
                    //favorites button
                    .toolbar{
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {viewModel.showFavorites.toggle() }) {
                                VStack {
                                Image(systemName: "heart.fill")
                                        .shadow(color: .gray, radius: 2, x: 3, y: 2)
                                    Text("Favorites")
                                        .font(Font.custom("VT323-Regular", size: 15))
                                }
                            }
                        }
                    }//end of toolbar
                    .sheet(isPresented: $viewModel.showFavorites, onDismiss: nil){
                        FavoritesListView()
                    }
                    
                    Spacer()
                    
                    // MARK: - RANDOM BUTTONS
                    VStack {
                        NavigationLink(destination: RandomRestaurantView(), tag: "first", selection: $viewSelection) {
                            Button(action: {
                                self.viewSelection = "first"
                                viewModel.getRandomRestaurant()
                            }) {
                                HStack {
                                    Text("📍")
                                    Text("Pick Random Restaurant From Current Location")
                                    Text("📍")
                                }
                                .font(Font.custom("VT323-Regular", size:25))
                                .padding(30)
                                .background(Color.black)
                                .cornerRadius(40)
                                .shadow(color: .gray, radius: 5, x: 10, y: 10)
                                .foregroundColor(.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(Color.purple, lineWidth: 5)
                                )
                            }
                        }
                        Spacer()
                            .frame(height: 35)
                        
                        NavigationLink(destination: RandomFavoriteView(), tag: "second", selection: $viewSelection) {
                            Button(action: {
                                self.viewSelection = "second"
                                
                            }) {
                                HStack{
                                    Text("💖")
                                    Text("Pick Random Restaurant from Favorites List")
                                    Text("💖")
                                }
                                .font(Font.custom("VT323-Regular", size:25))
                            }   .padding(30)
                                .background(Color.black)
                                .cornerRadius(40)
                                .shadow(color: .gray, radius: 5, x: 10, y: 10)
                                .foregroundColor(.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(Color.purple, lineWidth: 5)
                                )
                        }
                    }
                    .onAppear {
                        viewModel.requestPermission()
                        
                    }
                }
            }
        }
    }
    struct StartView_Previews: PreviewProvider {
        static var previews: some View {
            StartView()
                .environmentObject(RestaurantViewModel())
        }
    }
}


