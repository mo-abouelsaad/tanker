//
//  HomeViewController.swift
//  tn
//
//  Created by Mohamed Aboelsaad on 5/4/20.
//  Copyright © 2020 Mohamed Aboelsaad. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import FirebaseAuth
import FirebaseFirestore
class HomeViewController: UIViewController ,CLLocationManagerDelegate , GMSMapViewDelegate{
    @IBOutlet weak var viewMap: GMSMapView!
    var locationManager = CLLocationManager()
    var type :  String = ""
     var currentLocation: CLLocation?
     var mapView: GMSMapView!
    var quantity : Double = 0
    var qty : Double = 0
     var placesClient: GMSPlacesClient!
     var zoomLevel: Float = 15.0
    var didFindMyLocation = false
    var phone : String = ""
    var km : Double = 0
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated);
    self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()              
              if Auth.auth().currentUser?.phoneNumber != nil {

              }
       locationManager.requestWhenInUseAuthorization()
       var currentLoc: CLLocation!
       if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
       CLLocationManager.authorizationStatus() == .authorizedAlways) {
          currentLoc = locationManager.location
           currentLocation = locationManager.location
       }
        let camera = GMSCameraPosition.camera(withLatitude: currentLoc!.coordinate.latitude,
                                              longitude: currentLoc!.coordinate.longitude,
                                                 zoom: zoomLevel)
           mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
           mapView.settings.myLocationButton = true
           mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
           mapView.isMyLocationEnabled = true
           view.addSubview(mapView)
        let db = Firestore.firestore()
        print(qty)
        if (type != "تنكر صرف"){
            print(self.type)
            db.collection("provider").whereField("online", isEqualTo: "online").whereField("cat", isEqualTo: self.type).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.quantity = (document.data()["qty"] as! NSString).doubleValue
                    var doc = document.data()["phone"] as! String
                    db.collection("trips").whereField("phonep", isEqualTo: doc).getDocuments() { (querySnapshot, err) in
                        if let err = err {
                        print("Error getting documents: \(err)")
                    }
                        if (querySnapshot?.documents.first?.data()["ip"] as? String == "true"){
                            return
                        }else if (self.quantity.isLess(than: self.qty)) {
                            return
                        }
                            else{
                            let position = CLLocationCoordinate2D(latitude: document.data()["lat"]! as! CLLocationDegrees, longitude: document.data()["long"]! as! CLLocationDegrees)
                               let marker = GMSMarker(position: position)
                               marker.title = self.type
                               marker.icon = UIImage(named: "car.png")
                               marker.userData = document.data()["phone"]!
                               marker.map = self.mapView
                               let coordinate₀ = CLLocation(latitude:  document.data()["lat"]! as! CLLocationDegrees, longitude: document.data()["long"]! as! CLLocationDegrees)
                        }
                    }
                   
                }
            }
            }
        }
    
            else {
                db.collection("provider").whereField("online", isEqualTo: "online").whereField("cat", isEqualTo: self.type).getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            var doc = document.data()["phone"] as! String
                            db.collection("trips").whereField("phonep", isEqualTo: doc).getDocuments() { (querySnapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            }
                                if querySnapshot?.documents.first?.data()["ip"] as! String == "true"{
                                    return
                                }else{
                                    let position = CLLocationCoordinate2D(latitude: document.data()["lat"]! as! CLLocationDegrees, longitude: document.data()["long"]! as! CLLocationDegrees)
                                       let marker = GMSMarker(position: position)
                                       marker.title = self.type
                                       marker.icon = UIImage(named: "car.png")
                                       marker.userData = document.data()["phone"]!
                                       marker.map = self.mapView
                                       let coordinate₀ = CLLocation(latitude:  document.data()["lat"]! as! CLLocationDegrees, longitude: document.data()["long"]! as! CLLocationDegrees)
                                }
                            }
                           
                        }
                    }
            }
        }
        self.mapView.delegate = self

    }
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let vc = ReserveViewController()
        let coordinate₀ = CLLocation(latitude:  marker.position.latitude as! CLLocationDegrees, longitude: marker.position.longitude as! CLLocationDegrees)
                           let distanceInMeters = currentLocation!.distance(from: coordinate₀)
        self.phone = marker.userData! as! String
        self.km = Double(distanceInMeters/1000)
        performSegue(withIdentifier: "reserve", sender: self)
        return true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "reserve" {
                var  controller = segue.destination as! ReserveViewController
                controller.phone = self.phone
                controller.km = self.km
                controller.type = self.type
                controller.qty = self.qty
        }
    }
    
}
    
   
