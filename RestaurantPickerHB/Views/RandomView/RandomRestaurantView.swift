//
//  RandomRestaurantView.swift
//  RestaurantPickerHB
//
//  Created by Regina Paek on 7/14/22.
//
//VIEW FOR GETTING RANDOM RESTAURANT NEAR YOU

import SwiftUI

struct RandomRestaurantView: View {
    
    @ObservedObject var locationManager = LocationManager()
    @EnvironmentObject var viewModel: RestaurantViewModel
    @State var starsClicked = true
    
    var body: some View {
        
        ZStack{
            if starsClicked == true  {
            StarsView()
            }
            else {
                StarsView()
            }
            VStack {
                VStack{
                    Text("RANDOM RESTAURANT IS:")
                        .font(Font.custom("VT323-Regular", size:40))
                        .bold()
                }
                
                if let random = viewModel.restaurants.randomElement() {
                    VStack{
                        AsyncImage(url: random.formattedImageUrl) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }.frame(width: 210, height: 210)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.black, lineWidth: 5))
                        Text(random.name ?? "none")
                            .font(.system(size: 25))
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                        HStack{
                        Text(random.formattedCategory)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            Text("·")
                                .foregroundColor(.secondary)
                            Text(random.price ?? "none")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("·")
                                .foregroundColor(.secondary)
                        }
                        HStack {
                            switch random.formattedRating {
                            case "3.0":
                                Image("regular_3")
                            case "3.5":
                                Image("regular_3_half")
                            case "4.0":
                                Image("regular_4")
                            case "4.5":
                                Image("regular_4_half")
                            case "5.0":
                                Image("regular_5")
                            default:
                                Image("regular_0")
                            }
                            
                            Text(random.formattedReviewCount)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        HStack {
                            Text("📞")
                            Link(random.displayPhone ?? "none", destination: URL(string: "tel:\(random.formattedPhoneCall)")!)
                        }
                        .padding(.bottom, 5)
                        Button{
                            locationManager.locationString = random.formattedAddress
                            locationManager.openMapWithAddress()
                            
                        } label: {
                            HStack {
                                Text("📍")
                                Text(random.formattedAddress)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .frame(width: 200)
                            }
                        }
                        .alert(isPresented: $locationManager.invalid) {
                            Alert(title: Text("Important Message"), message: Text("Unable to find Address"), dismissButton: .default(Text("OK"), action: {
                                locationManager.invalid = false
                                locationManager.locationString = ""
                            }))
                        }
                    }
                }
                
                Button( action: {
                
                    Task {
                        starsClicked.toggle()
                        viewModel.getRandomRestaurant()
                       
                    }
                    
                }) {
                    Text("PICK ANOTHER RESTAURANT")
                        .font(Font.custom("VT323-Regular", size:20))
                        .padding(15)
                        .background(Color.black)
                        .cornerRadius(20)
                        .shadow(color: .gray, radius: 5, x: 10, y: 10)
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.purple, lineWidth: 5)
                        )
                }
              
            } .transaction { transaction in
                transaction.animation = nil
            }
        }
    } 
}

struct RandomRestaurantView_Previews: PreviewProvider {
    static var previews: some View {
        RandomRestaurantView()
            .environmentObject(RestaurantViewModel())
    }
}

