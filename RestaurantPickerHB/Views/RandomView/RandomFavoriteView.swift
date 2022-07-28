//
//  RandomFavoriteView.swift
//  RestaurantPickerHB
//
//  Created by Regina Paek on 7/15/22.
//
//VIEW FOR GETTING RANDOM FAVORITE RESTAURANT 

import SwiftUI

struct RandomFavoriteView: View {
    @State var viewSelection: Int? = nil
    @State var isClicked: Bool = true
    @State var starsClicked = true
    
    @EnvironmentObject var viewModel: RestaurantViewModel
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(entity: RestaurantModel.entity(), sortDescriptors: [], animation: .easeInOut)
    var restaurantModels: FetchedResults<RestaurantModel>
    var restaurants: [Restaurant] {
        restaurantModels.map(Restaurant.init(model:))
    }
    
    @ObservedObject var locationManager = LocationManager()
    
    @ViewBuilder var body: some View {
        if let randomFavorite = restaurantModels.randomElement() {
            ZStack{
                if starsClicked == true  {
                    StarsView()
                }
                else {
                    StarsView()
                }
                
                VStack {
                    Text("RANDOM FAVORITE IS:")
                        .font(Font.custom("VT323-Regular", size:40))
                        .bold()
                        .padding()
                    
                    VStack(alignment: .center){
                        AsyncImage(url: URL(string: randomFavorite.imageUrl ?? "none")) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }.frame(width: 210, height: 210)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.black, lineWidth: 5))
                        Text(randomFavorite.name ?? "none")
                            .font(.system(size: 25))
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                        HStack {
                        Text(randomFavorite.category ?? "none")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("·")
                            .foregroundColor(.secondary)
                        Text(randomFavorite.price ?? "none")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("·")
                            .foregroundColor(.secondary)
                        }
                        HStack {
                            switch randomFavorite.rating {
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
                            Text(randomFavorite.reviewCount ?? "none")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        HStack {
                            Text("📞")
                            Link(randomFavorite.phone ?? "none", destination: URL(string: "tel:\(randomFavorite.phone ?? "none")")!)
                        }
                        .padding(.bottom, 5)
                        Button{
                            locationManager.locationString = randomFavorite.displayAddress ?? "none"
                            locationManager.openMapWithAddress()
                            
                        } label: {
                            HStack {
                                Text("📍")
                                Text(randomFavorite.displayAddress ?? "none")
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
                        Button( action: {
                            Task {
                                starsClicked.toggle()
                                self.isClicked.toggle()
                                if isClicked == false {
                                    getRandomFavorite()
                                }
                            }
                        }) {
                            Text("PICK ANOTHER RESTAURANT")
                                .font(Font.custom("VT323-Regular", size:20))
                                .padding(15)
                                .background(Color.black)
                                .cornerRadius(20)
                                .shadow(radius: 8)
                                .foregroundColor(.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.purple, lineWidth: 5)
                                )
                        }
                        
                    } .onChange(of: isClicked) { newValue in
                        print("\(newValue)")
                    }
                } .transaction { transaction in
                    transaction.animation = nil
                }
            }
        } else {
            Text("You dont have any favorites!!")
                .font(Font.custom("VT323-Regular", size:30))
            
            NavigationLink(destination: RestaurantListView(), tag: 1, selection: $viewSelection) {
                Button(action:  {
                    self.viewSelection = 1
                }) {
                    VStack{
                        Text("Go Add some Favorites!!")
                            .font(Font.custom("VT323-Regular", size: 20))
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
            }
        }
    }
    
}

struct RandomFavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        RandomFavoriteView()
    }
}

extension RandomFavoriteView {
    
    func getRandomFavorite() -> Restaurant? {
        let randomFavorite = restaurants.randomElement()
        return randomFavorite
        
    }
}
