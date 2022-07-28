//
//  FavoritesCell.swift
//  RestaurantPickerHB
//
//  Created by Regina Paek on 7/15/22.
//

import SwiftUI
import CoreData

struct ReviewsCell: View {
    
    @EnvironmentObject var viewModel: RestaurantViewModel
    @Environment(\.managedObjectContext) var context
    
    @State var reviews: Reviews
    
    var body: some View {
        HStack(spacing: 20){
            AsyncImage(url: reviews.formattedImageUrl){ image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Text("No Image Found..")
                    .background(Color.gray)
            }
            .frame(width: 110, height: 110)
            .cornerRadius(100)
            
            
            VStack(alignment: .leading, spacing: 5) {
                Text(reviews.formattedName)
                Text(reviews.text ?? "none")
                    .font(.system(size: 12))
                
                HStack {
                    if reviews.formattedRating == "1" {
                        Image("regular_1")
                        
                    }
                    if reviews.formattedRating == "2" {
                        Image("regular_2")
                        
                    }
                    if reviews.formattedRating == "3" {
                        Image("regular_3")
                        
                    }
                    if reviews.formattedRating == "4" {
                        Image("regular_4")
                        
                    }
                    if reviews.formattedRating == "5" {
                        Image("regular_5")
                    }
                }
            }.frame(width: 175, height: 100 )
            
        }
    }
}

struct ReviewsCell_Previews: PreviewProvider {
    static var previews: some View {
        ReviewsCell(reviews: .init(user: .init(name: "Jane Doe", imageURL: "https://s3-media3.fl.yelpcdn.com/photo/iwoAD12zkONZxJ94ChAaMg/o.jpg"), rating: 4, text: "This was a great place to eat yum yum blah blah oh my long review heheheehhe", timeCreated: nil, id: nil))
            .environmentObject(RestaurantViewModel())
    }
}
