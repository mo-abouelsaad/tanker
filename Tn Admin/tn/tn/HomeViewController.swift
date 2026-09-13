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
class HomeViewController: UIViewController ,CLLocationManagerDelegate{
    @IBOutlet weak var viewMap: GMSMapView!
    var locationManager = CLLocationManager()
     var currentLocation: CLLocation?
     var mapView: GMSMapView!
     var placesClient: GMSPlacesClient!
     var zoomLevel: Float = 15.0
	var type :  String = ""
    var didFindMyLocation = false
	override func viewWillAppear(_ animated: Bool) {
	super.viewWillAppear(animated);
	self.navigationController?.isNavigationBarHidden = false
	}
    override func viewDidLoad() {
        super.viewDidLoad()
       locationManager.requestAlwaysAuthorization()
       var currentLoc: CLLocation!
       if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
       CLLocationManager.authorizationStatus() == .authorizedAlways) {
          currentLoc = locationManager.location
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
	
	
	
	
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
 */
    
    
   
