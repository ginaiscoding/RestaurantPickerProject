//
//  HomeView.swift
//  RestaurantPickerHB
//
//  Created by Regina Paek on 7/11/22.
//

import SwiftUI

struct RestaurantListView: View {
   
    @ObservedObject var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.businesses, id: \.id) { business in
                    Text(business.name ?? "no name")
                }
            }
            .listStyle(.plain)
            .navigationTitle(Text("SF"))
            .font(Font.custom("VT323-Regular", size:20))
           // .searchable(text: $viewModel.searchText)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "plus")
                }
            }
            .onAppear(perform: $viewModel.request)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantListView()
    }
}
