//
//  ContentView.swift
//  FoodOrderFirebase
//
//  Created by 1 on 27/10/21.
//

import SwiftUI



struct ContentView: View {
    
    var body: some View {
        NavigationView {
            HomeView()
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
