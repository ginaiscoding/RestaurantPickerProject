//
//  StartView.swift
//  RestaurantPickerHB
//
//  Created by Regina Paek on 7/11/22.
//

import SwiftUI

struct StartView: View {
    @State var isAnimating: Bool = true
    
    var animation: Animation {
        .interpolatingSpring(stiffness: 0.8, damping: 0.5)
            .repeatForever()
            .delay(isAnimating ? .random(in: 0...1) : 0)
            .speed(isAnimating ? .random(in: 0.5...1) : 0)
    }
    
    var body: some View {
        GeometryReader { proxy in
        VStack {
            ZStack {
                Image("pizza")
                    .position(x: .random(in: 0...proxy.size.width), y: .random(in: 0...proxy.size.height / 2))
                Image("hotdog")
                    .position(x: .random(in: 0...proxy.size.width), y: .random(in: 0...proxy.size.height / 2))
                Image("drumsticks")
                    .position(x: .random(in: 0...proxy.size.width), y: .random(in: 0...proxy.size.height / 2))
                Image("popsicle")
                    .position(x: .random(in: 0...proxy.size.width), y: .random(in: 0...proxy.size.height / 2))
                Image("cheese")
                    .position(x: .random(in: 0...proxy.size.width), y: .random(in: 0...proxy.size.height / 2))
                    
                    .animation(animation)
                VStack{
                    Text("Food Picker")
                        .font(Font.custom("VT323-Regular", size:50))
                        .padding(15)
                        .background(Color.secondary)
                        .foregroundColor(.white)
            }.frame(height: proxy.size.height / 3)
            
            }
            Spacer()
            
                    VStack {
                        
                            Button(action: {}) {
                                Text("Pick From Current Location")
                                    .font(Font.custom("VT323-Regular", size:20))
                            }   .padding(15)
                                .background(Color.black)
                                .cornerRadius(20)
                                .shadow(radius: 8)
                            .foregroundColor(.white)
                        
                        
                        Button(action: {}) {
                            Text("Pick from Favorites List")
                                .font(Font.custom("VT323-Regular", size:20))
                        }   .padding(15)
                            .background(Color.black)
                            .cornerRadius(20)
                            .shadow(radius: 8)
                        .foregroundColor(.white)
                        .padding()
                }
            }.onAppear {
                isAnimating.toggle()
            }
        }//end of VStack
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
