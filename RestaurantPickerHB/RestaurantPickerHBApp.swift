//
//  RestaurantPickerHBApp.swift
//  RestaurantPickerHB
//
//  Created by Regina Paek on 7/11/22.
//

import SwiftUI

@main
struct RestaurantPickerHBApp: App {
    let viewModel = RestaurantViewModel()
    var body: some Scene {
        WindowGroup {
            StartView()
                .environmentObject(viewModel)
                .environment(\.managedObjectContext, PersistentContainer.viewContext)
        }
    }
}
