//
//  SlideMenuView.swift
//  FoodOrderFirebase
//
//  Created by 1 on 27/10/21.
//

import SwiftUI

struct SlideMenuView: View {
    
    @ObservedObject var homeModel: HomeViewModel
    
    var body: some View {
        VStack {
            NavigationLink(destination: CartView(homeModel: homeModel)) {
                
                    HStack(spacing: 15) {
                        Image(systemName: "cart")
                            .font(.title)
                            .foregroundColor(Color.pink)
                        
                        Text("Cart")
                            .fontWeight(.bold)
                            .foregroundColor(Color.black)
                        
                        Spacer(minLength: 0)
                    } //: HSTACK
                    .padding()
            } // ; link
            
            Spacer()
            
            HStack{
                Spacer()
                
                Text("Version 0.1")
                    .fontWeight(.bold)
                    .foregroundColor(Color.pink)
            } //: HSTACK
            .padding(10)

        } //: VSTACK
        .padding([.top, .trailing])
        .frame(width: UIScreen.main.bounds.width / 1.6)
        .background(Color.white.ignoresSafeArea())
    }
}

