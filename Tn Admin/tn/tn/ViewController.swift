//
//  ViewController.swift
//  tn
//
//  Created by Mohamed Aboelsaad on 5/3/20.
//  Copyright © 2020 Mohamed Aboelsaad. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import GooglePlaces
import  FirebaseFirestore
class ViewController: UIViewController {
    var currentLoc: CLLocation!
       var locationManager = CLLocationManager()
        var currentLocation: CLLocation?
    @IBOutlet weak var fname: UITextField!
    @IBOutlet weak var lname: UITextField!
    @IBOutlet weak var phone: UITextField!
	@IBOutlet weak var btn: UIButton!
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated);
		self.navigationController?.isNavigationBarHidden = true
		
	}
    override func viewDidLoad() {
        super.viewDidLoad()
        let db = Firestore.firestore()
		let defaults = UserDefaults.standard
		if defaults.string(forKey: "login") != nil {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "home2", sender: self)

                  }
        }
        locationManager.requestWhenInUseAuthorization()
                    if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                    CLLocationManager.authorizationStatus() == .authorizedAlways) {
                       currentLoc = locationManager.location
                    }
	   btn.layer.cornerRadius = 10
	   btn.layer.borderWidth = 1
	   btn.layer.borderColor = UIColor.black.cgColor
    }


    @IBAction func signup(_ sender: Any) {
        let number = Int.random(in: 100000 ... 999999)
        var message = "your login code is \(number) for TN APP"
        var phon = "965"+phone.text!
        print(phon)
        let db = Firestore.firestore()
              locationManager.requestWhenInUseAuthorization()
              if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
              CLLocationManager.authorizationStatus() == .authorizedAlways) {
                 currentLoc = locationManager.location
              }
        db.collection("provider").whereField("phone", isEqualTo: phone.text!)
                                         .getDocuments() { (querySnapshot, err) in

                                                 if querySnapshot!.documents !=  nil{
                                                     var id = querySnapshot!.documents.first?.documentID
                                                     if(id != nil){
                                                         let sfReference = db.collection("provider").document(id!)
                                                         sfReference.updateData( [ "fname": self.fname.text!,
                                                        "lname": self.lname.text!,"long" : self.currentLoc.coordinate.longitude,"lat" :self.currentLoc.coordinate.latitude,
                                                        "authtoken":number
                                                         ],completion: nil)
                                                     }else{
                                                         
                                                         let sfReference = db.collection("provider")
                                                                                                    sfReference.addDocument(data: [ "fname": self.fname.text!,
                                                                                                    "lname": self.lname.text!,
                                                                                                    "phone" :  self.phone.text!
                                                                                                     ,"lat" : self.currentLoc.coordinate.latitude,
                                                                                                    "authtoken":number])

                                                    }
                                                     }
                                             }
                       
                            let url = URL(string: "https://www.5dmtk.sky-tech-eg.com/sms")!
                            var request = URLRequest(url: url)
                            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                            request.httpMethod = "POST"

                       let bodyData = "message="+message+"&phone="+phon
                                                        request.httpBody = bodyData.data(using: String.Encoding.utf8);
                                                        let task = URLSession.shared.dataTask(with: request) { data, response, error in
                                guard let data = data,
                                    let response = response as? HTTPURLResponse,
                                    error == nil else {                                              // check for fundamental networking error
                                    print("error", error ?? "Unknown error")
                                    return
                                }

                                guard (200 ... 299) ~= response.statusCode
                                    else {                    // check for http errors
                                    print("statusCode should be 2xx, but is \(response.statusCode)")
                                    print("response = \(response)")
                                    return
                                }
                            }

                            task.resume()
                         let defaults = UserDefaults.standard
        defaults.set(phone.text!, forKey: "phone")
        performSegue(withIdentifier: "code", sender: self)
                  }
         

}

