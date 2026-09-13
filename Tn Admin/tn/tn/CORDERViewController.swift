//
//  CORDERViewController.swift
//  
//
//  Created by moham on 5/18/20.
//

import UIKit
import CoreLocation
import FirebaseFirestore
import Firebase
class CORDERViewController: UIViewController,CLLocationManagerDelegate {
	var locationManager = CLLocationManager()
	var currentLocation: CLLocation = CLLocation()
	@IBOutlet weak var end: UIButton!
	
	
	@IBOutlet weak var co: UIButton!
	var usermobile = ""
	var km : Double = 0
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated);
		self.navigationController?.isNavigationBarHidden = false
		        let db = Firestore.firestore()
				db.collection("trips").whereField("ip",isEqualTo: "true").whereField("phonep", isEqualTo: UserDefaults.standard.string(forKey: "phone")).getDocuments() { (querySnapshot, err) in
						   if let err = err {
							   print("Error getting documents: \(err)")
						   } else {
							let d = querySnapshot!.documents.first!
							var longu   =  d.data()["longu"]!
							self.usermobile   =  d.data()["phoneu"]! as! String
							var latu = d.data()["latu"]!
							let coordinate₀ = CLLocation(latitude:  latu as! CLLocationDegrees, longitude: longu as! CLLocationDegrees)
							let distanceInMeters = self.currentLocation.distance(from: coordinate₀)
							self.km = Double(distanceInMeters/1000)
							if self.km <= 5 {
								
								self.end.alpha = 1
							}
								
					}
				}

	}
    override func viewDidLoad() {
        super.viewDidLoad()
		if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
		CLLocationManager.authorizationStatus() == .authorizedAlways) {
		   currentLocation = locationManager.location!
		}
		co.layer.cornerRadius = 10
		co.layer.borderWidth = 1
		co.layer.borderColor = UIColor.purple.cgColor
		end.layer.cornerRadius = 10
		end.layer.borderWidth = 1
		end.layer.borderColor = UIColor.purple.cgColor
		locationManager.delegate = self
		locationManager.requestAlwaysAuthorization()
		locationManager.startUpdatingLocation()
		locationManager.startMonitoringSignificantLocationChanges()
        locationManager.allowsBackgroundLocationUpdates = true
		

        }
    
    
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .authorizedAlways {
			
		}
	}
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let location = locations.last {
			print("New location is \(location)")
			let db = Firestore.firestore()
			db.collection("provider").whereField("phone",isEqualTo: UserDefaults.standard.string(forKey: "phone") ).getDocuments() { (querySnapshot, err) in
			if let err = err {
				print("Error getting documents: \(err)")
			} else {
				var did = querySnapshot?.documents.first?.documentID
				let sfReference = db.collection("provider").document(did!)
				sfReference.updateData( [ "long": location.coordinate.longitude,"lat" : location.coordinate.latitude])
		}
	}
		}
	}
	
	
	@IBAction func showroute(_ sender: Any) {
		let db = Firestore.firestore()
		db.collection("trips").whereField("ip",isEqualTo: "true").whereField("phonep", isEqualTo: UserDefaults.standard.string(forKey: "phone")).getDocuments() { (querySnapshot, err) in
				   if let err = err {
					   print("Error getting documents: \(err)")
				   } else {
					let d = querySnapshot!.documents.first!
					var longu : String = String(describing: d.data()["longu"]!)
					var latu = String(describing: d.data()["latu"]!)
					let long = String(format: "%f",self.currentLocation.coordinate.longitude)
					let lat = String(format: "%f",self.currentLocation.coordinate.latitude)
					let directionsRequest = "https://www.google.com/maps/dir/"+lat+","+long+"/"+latu+","+longu+"/"
					let directionsURL = URL(string: directionsRequest)!
				    UIApplication.shared.open(directionsURL, options: [:], completionHandler: nil)
						
			}
		}
		
	}
	
	
	@IBAction func EndOrder(_ sender: Any) {
		let db = Firestore.firestore()
		  db.collection("user").whereField("phone", isEqualTo:usermobile).getDocuments() { (querySnapshot, err) in

									   if querySnapshot!.documents !=  nil{
										   var id = querySnapshot!.documents.first?.data()["token"]
			  
			  
			  let url = URL(string: "https://www.5dmtk.sky-tech-eg.com/firebase/notificationuser")!
			  var request = URLRequest(url: url)
			  request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
			  request.httpMethod = "POST"

										  var bodyData = "token="+String(id! as! String)
										  request.httpBody = bodyData.data(using: String.Encoding.utf8);
										  let task = URLSession.shared.dataTask(with: request) { data, response, error in
				  guard let data = data,
					  let response = response as? HTTPURLResponse,
					  error == nil else {                                              // check for fundamental networking error
					  print("error", error ?? "Unknown error")
					  return
				  }

				  guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
					  print("statusCode should be 2xx, but is \(response.statusCode)")
					  print("response = \(response)")
					  return
				  }

				  let responseString = String(data: data, encoding: .utf8)
				  print("responseString = \(responseString)")
			  }

			  task.resume()
		   let alert = UIAlertController(title: "Alert", message: "تم انهاء الطلب بنجاح", preferredStyle: .alert)
		   alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
		   self.present(alert, animated: true)
		  }
			  }
		
		 db.collection("trips").whereField("ip", isEqualTo:"true").getDocuments() { (querySnapshot, err) in
			var doc = querySnapshot?.documents.first?.documentID
			db.collection("trips").document(doc!).updateData([ "ip": "false"],completion: nil)
			let alert = UIAlertController(title: "Alert", message: "Order has been ended successfully", preferredStyle: .alert)

											 alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
		}
	}
	
	
}
