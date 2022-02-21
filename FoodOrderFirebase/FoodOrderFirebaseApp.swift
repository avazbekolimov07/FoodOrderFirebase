//
//  FoodOrderFirebaseApp.swift
//  FoodOrderFirebase
//
//  Created by 1 on 27/10/21.
//

import SwiftUI
import Firebase

@main
struct FoodOrderFirebaseApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
