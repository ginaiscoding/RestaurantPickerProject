//
//  StarsView.swift
//  RestaurantPickerHB
//
//  Created by Regina Paek on 7/26/22.
//
//VIEW FOR THE ANIMATING STAR EXPLOSION

import SwiftUI

struct StarsView: View {
    
    @State var scale = 1.0
    
    var body: some View {
        
        
        Image("pixelstar")
            .resizable()
            .frame(width: 35, height: 35)
            .offset(x: 70, y: -100)
            .frame(width: 200, height: 200)
            .scaleEffect(scale)
    
        Image("pixelstar")
            .resizable()
            .frame(width: 35, height: 35)
            .offset(x: -70, y: -100)
            .frame(width: 200, height: 200)
            .scaleEffect(scale)
        
        //right star
        Image("pixelstar")
            .resizable()
            .frame(width: 60, height: 60)
            .offset(x: 100, y: -40)
            .frame(width: 200, height: 200)
            .scaleEffect(scale)
        
        //left star
        Image("pixelstar")
            .resizable()
            .frame(width: 60, height: 60)
            .offset(x: -100, y: -40)
            .frame(width: 200, height: 200)
            .scaleEffect(scale)
        
        //top star
        Image("pixelstar")
            .offset(x: -70, y: 100)
            .frame(width: 200, height: 200)
            .scaleEffect(scale)
        Image("pixelstar")
            .offset(x: 100, y: 40)
            .frame(width: 200, height: 200)
            .scaleEffect(scale)
        Image("pixelstar")
            .offset(x: -100, y: 40)
            .frame(width: 200, height: 200)
            .scaleEffect(scale)
        Image("pixelstar")
            .offset(x: 70, y: 100)
            .frame(width: 200, height: 200)
            .scaleEffect(scale)
        
            .onAppear {
                let baseAnimation = Animation.easeOut(duration:2)
                withAnimation(baseAnimation) {
                    scale = 5
                }
            }
    }
}

struct StarsView_Previews: PreviewProvider {
    static var previews: some View {
        StarsView()
    }
}
