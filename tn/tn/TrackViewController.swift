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
class TrackViewController: UIViewController ,CLLocationManagerDelegate{
    @IBOutlet weak var viewMap: GMSMapView!
    var locationManager = CLLocationManager()
    var type :  String = ""
     var currentLocation: CLLocation?
     var mapView: GMSMapView!
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
        locationManager.requestAlwaysAuthorization()
              if Auth.auth().currentUser?.phoneNumber != nil {

              }
       locationManager.requestWhenInUseAuthorization()
       var currentLoc: CLLocation!
       if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
       CLLocationManager.authorizationStatus() == .authorizedAlways) {
          currentLoc = locationManager.location
           currentLocation = locationManager.location
       }
        
        
        
        let db = Firestore.firestore()
        db.collection("trips").whereField("phoneu",isEqualTo:UserDefaults.standard.string(forKey: "phone")).whereField("ip", isEqualTo: "true").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if querySnapshot!.documents.count > 0{
                    var d = querySnapshot!.documents.first?.data()["phonep"] as! String
                    db.collection("provider").whereField("phone", isEqualTo: d).getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                      
                        var docid = querySnapshot?.documents.first?.documentID
                        db.collection("provider").document(docid!)
                        .addSnapshotListener { documentSnapshot, error in
                          guard let document = documentSnapshot else {
                            print("Error fetching document: \(error!)")
                            return
                          }
                          guard let data = document.data() else {
                            print("Document data was empty.")
                            return
                          }
                          print("Current data: \(data)")
                            
                            
                            let camera2 = GMSCameraPosition.camera(withLatitude: data["lat"] as! CLLocationDegrees,
                                                                  longitude: data["long"]  as! CLLocationDegrees,
                                                                  zoom: self.zoomLevel)
                            self.mapView.camera = camera2
                            let position = CLLocationCoordinate2D(latitude: data["lat"]! as! CLLocationDegrees, longitude: data["long"]! as! CLLocationDegrees)
                                               let marker = GMSMarker(position: position)
                                               marker.title = self.type
                                               marker.userData = Auth.auth().currentUser?.phoneNumber
                                               marker.map = self.mapView
                                               marker.icon = UIImage(named: "car.png")
                        }
                        
                    }
                    }
                }
            }
        }

        let camera = GMSCameraPosition.camera(withLatitude: currentLoc!.coordinate.latitude,
                                              longitude: currentLoc!.coordinate.longitude,
                                                 zoom: zoomLevel)
           mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
           mapView.settings.myLocationButton = true
           mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
           mapView.isMyLocationEnabled = true
           view.addSubview(mapView)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "reserve" {
                let controller = segue.destination as! ReserveViewController
                controller.phone = self.phone
                controller.km = self.km
            controller.type = self.type
        }
    }
    
}
    
   
