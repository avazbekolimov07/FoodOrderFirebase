//
//  HomeViewModel.swift
//  FoodOrderFirebase
//
//  Created by 1 on 27/10/21.
//

import SwiftUI
import CoreLocation
import Firebase

// Fetching User Location
class HomeViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var locationManager = CLLocationManager()
    @Published var search = ""
    
    // Location Details...
    @Published var userLocation: CLLocation!
    @Published var userAddress = ""
    @Published var noLocation = false
     
    // Slide Menu...
    @Published var showSlideMenu = false
    
    // Items Data...
    @Published var items = [Item]()
    @Published var filtered = [Item]()
    
    // Card Data...
    @Published var cartItems = [Cart]()
    @Published var ordered = false
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // checking Location Access
        
        switch manager.authorizationStatus { // manager from property of func
        case .authorizedWhenInUse:
            print("authoried")
            self.noLocation = false
            manager.requestLocation() // manager from property of func
        case .denied:
            print("denied")
            self.noLocation = true
        default:
            print("unknown")
            self.noLocation = false
            // Direct Call
            locationManager.requestWhenInUseAuthorization() // CLLocationManager()
            // Modeifying info.plist
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Reading User Location and Extracting Details...
        self.userLocation = locations.last // location from property of func [CLLocation] and userLocation is CLLocation type
        extractLocation()
        // after extracting location logging in...
        login()
    }
    
    func extractLocation() {
        CLGeocoder().reverseGeocodeLocation(self.userLocation) { result, error in
            guard let safeData = result else {return}
            
            var address = ""
            
            // getting area and locality name...
            address += safeData.first?.name ?? ""
            address += ", "
            address += safeData.first?.locality ?? ""
            
            self.userAddress = address
        } // CLGeocoder() {}
    } // function for extracting location
    
    // Anynomus login for Reading Database...
    func login() {
        Auth.auth().signInAnonymously { result, error in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            // After logging in Fetching Data
            self.fetchData()
            
            print("Success = \(result!.user.uid)")
        } // authentication
    } // login func
    
    // Fetching Items Data
    func fetchData() {
        let db = Firestore.firestore()
        db.collection("Items").getDocuments { snapshot, error in
            guard let itemData = snapshot else {return}
            self.items = itemData.documents.compactMap({ docSnapshot -> Item? in
                let id = docSnapshot.documentID
                let name = docSnapshot.get("item_name") as! String
                let cost = docSnapshot.get("item_cost") as! NSNumber
                let retings = docSnapshot.get("item_retings") as! String
                let image = docSnapshot.get("item_image") as! String
                let details = docSnapshot.get("item_details") as! String
                
                return Item(id: id, item_name: name, item_cost: cost, item_details: details, item_image: image, item_retings: retings)
            })
            
            self.filtered = self.items
        } // compact map
    } // fetching data func
    
    func filterData() {
        withAnimation(.linear) {
            self.filtered = self.items.filter{
                return $0.item_name.lowercased().contains(self.search.lowercased())
            }
        }
    } // filtering func
    
    // Add to Card Function
    func addToCart(item: Item) {
        // checking it is added...
        
        self.items[getIndex(item: item, isCartIndex: false)].isAdded = !item.isAdded
        
        // updating filtered array also for search bar results...
        let filteredIndex = self.filtered.firstIndex { item1 -> Bool in
            return item.id == item1.id
        } ?? 0

        self.filtered[filteredIndex].isAdded = !item.isAdded
        
        if item.isAdded {
            // removing from list...
            self.cartItems.remove(at: getIndex(item: item, isCartIndex: true))
            return
        }
        // else adding...
        self.cartItems.append(Cart(item: item, quantity: 1))
        
    } //  adding to cart func
    
    func getIndex(item: Item, isCartIndex: Bool) -> Int {
        let index = self.items.firstIndex { item1 -> Bool in
            return item.id == item1.id
        } ?? 0
        
        let cartIndex = self.cartItems.firstIndex { item1 -> Bool in
            return item.id == item1.item.id
        } ?? 0
        
        return isCartIndex ? cartIndex : index
    } // getiIndex func
    
    func calculateTotalPrice() -> String {
        var price: Float = 0
        
        cartItems.forEach{ item in
            price += Float(item.quantity) * Float(truncating: item.item.item_cost)
        }
        
        return getPrice(value: price)
    } // calculate Price func
    
    func getPrice(value: Float) -> String {
        let format = NumberFormatter()
        format.numberStyle =  .currency
        
        return format.string(from: NSNumber(value: value)) ?? ""
    } // get Price func
    
    // Writing Oder Data Into Firestore
    func updataOrder() {
        let db = Firestore.firestore()
        
        if ordered {
            ordered = false
            db.collection("Users").document(Auth.auth().currentUser!.uid).delete { error in
                if error != nil {
                    self.ordered = true
                }
            }
            return
        }
        
        // creating array of dictionary of food details...
        var details : [[String: Any]] = []
        cartItems.forEach{ cart in
            details.append([
                "item_name" : cart.item.item_name,
                "item_quantity": cart.quantity,
                "item_cost": cart.item.item_cost,
            ])
        }
        
        ordered = true
        
        db.collection("Users").document(Auth.auth().currentUser!.uid).setData([
           "ordered_food" : details,
           "total_cost" : calculateTotalPrice(),
           "location" : GeoPoint(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        ]) { error in
            if error != nil {
                self.ordered = false
                return
            }
            print("Success")
        }
    }
} //: Class
