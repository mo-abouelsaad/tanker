//
//  updateTableViewCell.swift
//  tn
//
//  Created by Mohamed Aboelsaad on 5/10/20.
//  Copyright © 2020 Mohamed Aboelsaad. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import GooglePlaces
import  FirebaseFirestore
class updateUIViewController: UIViewController {
    @IBOutlet weak var btn: UIButton!
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated);
    self.navigationController?.isNavigationBarHidden = false
    }
    @IBOutlet weak var email: UITextField!
    var currentLoc: CLLocation!
       var locationManager = CLLocationManager()
        var currentLocation: CLLocation?
    override func viewDidLoad() {
        super.viewDidLoad()
        btn.layer.cornerRadius = 10
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.black.cgColor

    }

    
  @IBAction func upld(_ sender: Any) {
        let db = Firestore.firestore()
              locationManager.requestWhenInUseAuthorization()
              if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
              CLLocationManager.authorizationStatus() == .authorizedAlways) {
                 currentLoc = locationManager.location
              }
              let defaults = UserDefaults.standard
            db.collection("user").whereField("phone", isEqualTo:defaults.string(forKey: "phone"))
                                         .getDocuments() { (querySnapshot, err) in

                                                 if querySnapshot!.documents !=  nil{
                                                     var id = querySnapshot!.documents.first?.documentID
                                                     if(id != nil){
                                                         let sfReference = db.collection("user").document(id!)
                                                         sfReference.updateData( [
                                                    "email": self.email.text!,"long" : self.currentLoc.coordinate.longitude,"lat" :self.currentLoc.coordinate.latitude],completion: nil)
                        let alert = UIAlertController(title: "Alert", message: "your Personal Info Updated Successfully ", preferredStyle: .alert)

                                                         alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                                         self.present(alert, animated: true)
                                                     }else{
                                                         
                                                         let sfReference = db.collection("user")
                                                                                                    sfReference.addDocument(data: [                  "email": self.email.text!,
                                                                                                    "phone" :  defaults.string(forKey: "phone")
                                                                                                     ,"lat" : self.currentLoc.coordinate.latitude
                                                              ])
                                                         let alert = UIAlertController(title: "Alert", message: "your Personal Info Inserted Successfully ", preferredStyle: .alert)
                                                                             alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                                         self.present(alert, animated: true)

                                                     }
                                             }
                  }
    }
}
