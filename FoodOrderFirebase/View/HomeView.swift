//
//  HomeView.swift
//  FoodOrderFirebase
//
//  Created by 1 on 27/10/21.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var homeModel = HomeViewModel()
    
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                HStack(spacing: 15) {
                    
                    Button {
                        withAnimation(.easeIn) {
                            homeModel.showSlideMenu.toggle()
                        }
                    } label: {
                        Image(systemName: "line.horizontal.3")
                            .font(.title)
                            .foregroundColor(Color.pink)
                    }

                    Text(homeModel.userLocation == nil ? "Locating..." : "Devilver To")
                        .foregroundColor(.black)
                    Text(homeModel.userAddress)
                        .font(.caption)
                        .fontWeight(.heavy)
                        .foregroundColor(Color.pink)
                    
                    Spacer(minLength: 0)
                } //: HSTACK
                .padding([.horizontal, .top])
                
                Divider()
                
                HStack(spacing: 15) {
                    
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundColor(.gray)
                    
                    TextField("Search", text: $homeModel.search)
                    
                } //: HSTACK
                .padding(.horizontal)
                .padding(.top, 10)
                
                Divider()
                
                if homeModel.items.isEmpty {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            ForEach(homeModel.filtered) { item in
                                // Item View..
                                
                                ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
                                    
                                    ItemView(item: item)
                                        .frame(width: UIScreen.main.bounds.width - 30)
                                    
                                    HStack {
                                        Text("FREE DELIVERY")
                                            .foregroundColor(.white)
                                            .padding(.vertical, 10)
                                            .padding(.horizontal)
                                            .background(Color.pink)
                                        Spacer(minLength: 0)
                                        Button {
                                            homeModel.addToCart(item: item)
                                        } label: {
                                            Image(systemName: item.isAdded ? "checkmark" : "plus")
                                                .foregroundColor(.white)
                                                .padding(10)
                                                .background(item.isAdded ? Color.green : Color.pink)
                                                .clipShape(Circle())
                                        }
                                    } //: HSTACK
                                    .padding(.trailing, 10)
                                    .padding(.top, 10)
                                    
                                    
                                } //: ZSTACK
                            } //: LOOP
                        } //: VSTACK
                        .padding(.top, 10)
                    } //: SCROLL
                }
                
            } //: VSTACK
            
            // Slide Menu
            HStack {
                SlideMenuView(homeModel: homeModel)
                // Move Effect  from Left ...
                    .offset(x: homeModel.showSlideMenu ? 0 : -UIScreen.main.bounds.width / 1.6)
                
                Spacer(minLength: 0)
            } //: HSTACK
            .background(
                Color.black.opacity(homeModel.showSlideMenu ? 0.3 : 0).ignoresSafeArea()
                
                //Closing when Taps on outSide..
                    .onTapGesture {
                        homeModel.showSlideMenu.toggle()
                    }
            )
            
            // Non CLosaable Alert if Permission Denied...
            if homeModel.noLocation {
                Text("Please Enable Location Access In Settings To Further Move On!")
                    .foregroundColor(.black)
                    .frame(width: UIScreen.main.bounds.width - 100,
                      height: 120)
                    .background(Color.white)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.3).ignoresSafeArea())
            }
            
            
        } //: ZSTACK
        .onAppear {
            // calling location delegate
            homeModel.locationManager.delegate = homeModel
        } //: onAppear
        .onChange(of: homeModel.search) { newValue in
            // to avoid Continues Search requests...
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                if newValue == homeModel.search && homeModel.search != "" {
                    // Search Data
                    homeModel.filterData()
                }
            } // dispatchqueue
            if homeModel.search == "" {
                // Reset all data
                withAnimation(.linear) {
                    homeModel.filtered = homeModel.items
                }
            }
        } // onchange
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
