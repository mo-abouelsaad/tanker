//
//  PayViewController.swift
//  tn
//
//  Created by moham on 5/22/20.
//  Copyright © 2020 Mohamed Aboelsaad. All rights reserved.
//

import UIKit
import WebKit
import  CoreLocation
import FirebaseFirestore
class PayViewController: UIViewController , WKNavigationDelegate {
    var type :  String = ""
    var phone : String = ""
    var km : Double = 0
    var prce : Double = 0
    var currentLoc: CLLocation!
         var locationManager = CLLocationManager()
          var currentLocation: CLLocation?
    @IBOutlet weak var wkwebview: WKWebView!
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated);
    self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        var defaults = UserDefaults.standard
        wkwebview.navigationDelegate = self
        let db = Firestore.firestore()
        db.collection("user").whereField("phone", isEqualTo: defaults.string(forKey: "phone")!).getDocuments() { (querySnapshot, err) in
                           if let err = err {
                               print("Error getting documents: \(err)")
                           } else {
                             
                            let docid = querySnapshot?.documents.first?.data()
                            let name = String(String(docid!["fname"] as! String)+String(docid!["lname"] as! String))
                            let email = docid!["email"] as! String
                            let ph = docid!["phone"] as! String
                            var str = "https://paytn.sky-tech-eg.com/index.php?price="+String(format:"%.1f", self.prce/1000)+"&name="+name+"&email="+email+"&phone="+ph
                           
                            let  request = URLRequest(url: URL(string: str)!)
                            self.wkwebview.load(request)
            }
        }

    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if webView.url != nil {
            if (webView.url?.absoluteString.contains("https://paytn.sky-tech-eg.com/error.php"))!{
                           
                           let alert = UIAlertController(title: "Alert", message: "Order Failed", preferredStyle: .alert)
                           alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                           self.present(alert, animated: true)
                           
                       }else   if (webView.url?.absoluteString.contains("https://paytn.sky-tech-eg.com/success.php"))!{

                       let db = Firestore.firestore()
                           let sfReference = db.collection("trips")
                            locationManager.requestWhenInUseAuthorization()
                                   if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                                   CLLocationManager.authorizationStatus() == .authorizedAlways) {
                                      currentLoc = locationManager.location
                                       currentLocation = locationManager.location
                                   }
                           let defaults = UserDefaults.standard
                           sfReference.addDocument(data: [ "date":Date(),
                                                           "longu": currentLocation?.coordinate.longitude,
                                                           "latu": currentLocation?.coordinate.latitude,
                                                           "phoneu" :  defaults.string(forKey: "phone")
                            ,"phonep" :phone,"day" :Date(),
                                                            "ip" :"true"
                                                           ,"paytype" :"knet",
                                                           "price": prce])
                           
                           db.collection("provider").whereField("phone", isEqualTo:phone).getDocuments() { (querySnapshot, err) in

                                                    if querySnapshot!.documents !=  nil{
                                                        var id = querySnapshot!.documents.first?.data()["token"]
                           
                           
                           let url = URL(string: "https://www.5dmtk.sky-tech-eg.com/firebase/notification")!
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
                        let alert = UIAlertController(title: "Alert", message: "Your Order has been placed successfully ", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true)
                       }
                           }
                   }
                   return
           }    }
}
