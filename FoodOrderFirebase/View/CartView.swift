//
//  CartView.swift
//  FoodOrderFirebase
//
//  Created by 1 on 27/10/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct CartView: View {
    
    @ObservedObject var homeModel: HomeViewModel
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 26, weight: .heavy))
                        .foregroundColor(.pink)
                    
                } //: Button
                Text("My Cart")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
                
                Spacer()
            } //: HSTACK
            .padding()
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(homeModel.cartItems) { cart in
                     // Cart Item View...
                        
                        HStack(spacing: 15) {
                            WebImage(url: URL(string: cart.item.item_image))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 130, height: 130)
                                .cornerRadius(15)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text(cart.item.item_name)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                                
                                Text(cart.item.item_details)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.gray)
                                    .lineLimit(2)
                                
                                HStack(spacing: 15) {
                                    Text(homeModel.getPrice(value: Float(cart.item.item_cost)))
                                        .font(.title2)
                                        .fontWeight(.heavy)
                                    
                                    Spacer(minLength: 0)
                                    
                                    // Add Sub Button..
                                    Button {
                                        if cart.quantity > 1 {
                                            homeModel.cartItems[homeModel.getIndex(item: cart.item, isCartIndex: true)].quantity -= 1
                                        }
                                    } label: {
                                        Image(systemName: "minus")
                                            .font(.system(size: 16, weight: .heavy))
                                            .foregroundColor(.black)
                                    } // button

                                    
                                    Text("\(cart.quantity)")
                                        .fontWeight(.heavy)
                                        .foregroundColor(.black)
                                        .padding(.vertical, 5)
                                        .padding(.horizontal, 10)
                                        .background(Color.black.opacity(0.06))
                                    
                                    Button {
                                        homeModel.cartItems[homeModel.getIndex(item: cart.item, isCartIndex: true)].quantity += 1
                                    } label: {
                                        Image(systemName: "plus")
                                            .font(.system(size: 16, weight: .heavy))
                                            .foregroundColor(.black)
                                    } // button
                                } //: HSTACK
                            } //: STACK
                        } //: HSTACK
                        .padding()
                        .contextMenu {
                        // for Deteting order
                            Button(action: {
                                // deleting item from cart
                                let index = homeModel.getIndex(item: cart.item, isCartIndex: true)
                                let itemIndex = homeModel.getIndex(item: cart.item, isCartIndex: false)
                                
                                homeModel.items[itemIndex].isAdded = false
                                homeModel.filtered[itemIndex].isAdded = false
                                 
                                homeModel.cartItems.remove(at: index)
                                
                            }, label: {
                                Text("Remove")
                            })
                        } // contextMenu
                    }  //: LOOP
                } //: LAZY VSTACK
            } //: SCROLL
            
            // Bottom View
            VStack {
                HStack {
                   Text("Total")
                        .fontWeight(.heavy)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(homeModel.calculateTotalPrice())
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                } //: HSTACK
                .padding([.top, .horizontal])
                
                Button {
                    homeModel.updataOrder()
                } label: {
                    Text(homeModel.ordered ? "Cancel Order" : "Check out")
                        .font(.title2)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 30)
                        .background(
                            Color.pink
                        )
                        .cornerRadius(15)
                }
            } //: VSTACK
            .background(Color.white)
            
        } //: VSTACK
        
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}
