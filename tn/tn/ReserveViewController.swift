//
//  ReserveViewController.swift
//  tn
//
//  Created by moham on 5/16/20.
//  Copyright © 2020 Mohamed Aboelsaad. All rights reserved.
//
import UIKit
import Firebase
import GoogleMaps
import GooglePlaces
import  FirebaseFirestore
class ReserveViewController: UIViewController {
    
    @IBOutlet weak var phonenum: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var qty2: UILabel!
    var qty : Double = 0
    var type :  String = ""
    var prce : Double = 0
    @IBOutlet weak var price: UILabel!
    var currentLoc: CLLocation!
         var locationManager = CLLocationManager()
          var currentLocation: CLLocation?
    var phone : String = ""
    var km : Double = 0
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated);
    self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(qty)
        let db = Firestore.firestore()
        if(km<1){
            km = 1
        }else{
            km = round(km)
            
        }
       
        db.collection("provider").whereField("phone", isEqualTo: phone).getDocuments() { (querySnapshot, err) in
                   if let err = err {
                       print("Error getting documents: \(err)")
                   } else {
                    var doc =  querySnapshot!.documents.first!.data()
                    var nm = String(doc["fname"] as! String)+String(doc["lname"] as! String)
                    self.name.text = "Service Provider name :\(nm)"
                    self.phonenum.text = self.phone
                    if self.type == "تانكر ماء"{
                        self.prce =  (self.qty*5) + (self.km*250)
                        self.price.text = "هي"+String(self.prce/1000)
                    self.qty2.text = String(format:"%.1f",self.qty)+" L."
                        
                    }
                    else if self.type == "تانكر ديزل"{
                        self.prce =  (self.qty*120) + (self.km*250)
                        self.price.text = "تكلفة الطلب"+String(self.prce/1000)
                        self.qty2.text = String(format:"%.1f",self.qty)+" L."
                    }
                    else {
                        self.prce = 18000+(self.km*250)
                        self.price.text = "تكلفة الطلب "+String(self.prce/1000)
                        //self.qty.text = String(self.step.value)+"L."
                    }
                   }
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

    @IBAction func changes(_ sender: Any) {
                           if self.type == "تانكر ماء"{
                            prce =  (qty*5) + (self.km*250)
                           self.price.text = "تكلفة الطلب هي"+String(prce/1000)
                           }
                           else if self.type == "تانكر ديزل"{
                                prce =  (qty*120) + (self.km*250)
                               self.price.text = "تكلفة الطلب"+String(prce/1000)
                           }
                           else {
                                prce = 18000+(self.km*250)
                               self.price.text = "تكلفة الطلب "+String(prce/1000)
                               //self.qty.text = String(self.step.value)+"Litre"
                           }
    }
    
    @IBAction func order(_ sender: Any) {
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
                                        ,"phonep" :phonenum.text
                                        ,"day" :Date()
                                        ,"ip" :"true",
                                        "price": prce])
        
        db.collection("provider").whereField("phone", isEqualTo:phonenum.text).getDocuments() { (querySnapshot, err) in

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
    let alert = UIAlertController(title:"order", message: "Order Completed", preferredStyle: .actionSheet)
     alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
     self.present(alert, animated: true)
    }
        }
    }
    
    
    @IBAction func payonline(_ sender: Any) {
        performSegue(withIdentifier: "payonline", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "payonline" {
                var  controller = segue.destination as! PayViewController
                controller.phone = self.phone
                controller.km = self.km
                controller.type = self.type
                controller.prce = self.prce
    }
    }
}
