//
//  homViewController.swift
//  tn
//
//  Created by Mohamed Aboelsaad on 5/9/20.
//  Copyright © 2020 Mohamed Aboelsaad. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import GooglePlaces
import  FirebaseFirestore
class homViewController: UIViewController,UITableViewDataSource,UITableViewDelegate ,UITabBarDelegate{
    @IBOutlet weak var tabl: UITableView!


    @IBOutlet weak var tab: UITabBar!
    var arr  = [Tanker]()
    var type :  String = ""
    var imgarr :[String] = ["water.png","sarf.png","diesel.png"]
    var currentLocation: CLLocation?
    var locationManager = CLLocationManager()
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated);
    self.navigationController?.isNavigationBarHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let db = Firestore.firestore()
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        UserDefaults.standard.set(["Arabic (Kuwait)"], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        let defaults = UserDefaults.standard
        self.tabl.separatorStyle = UITableViewCell.SeparatorStyle.none
        tab.delegate = self
        db.collection("trips").whereField("phoneu",isEqualTo:defaults.string(forKey: "phone")).whereField("ip", isEqualTo: "true").getDocuments() { (querySnapshot, err) in
                          if let err = err {
                              print("Error getting documents: \(err)")
                          } else {
                              if (querySnapshot?.documents.count)!  > 0{
                                  DispatchQueue.main.async {
                                  self.performSegue(withIdentifier: "track", sender: self)

                                            }
                              }
                          }
                      }
        db.collection("cat")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    var i = 0
                    for document in querySnapshot!.documents {
                        self.arr.append(Tanker(name: document.data()["name"]! as! String,img: self.imgarr[i]))
                            i+=1;
                    }
                    self.tabl.dataSource=self
                    self.tabl.delegate=self
                    self.tabl.reloadData()                }
        }

        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier : "Cell") as! tankersTableViewCell
        cell.img.image = UIImage(named: arr[indexPath.row].img)
        cell.lbl.text=arr[indexPath.row].name

        
        return cell
    }
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.type = "تنكر ماء"
            self.performSegue(withIdentifier: "qty", sender: self)
        }
        else if indexPath.row == 1{
            self.type = "تنكر صرف"
            self.performSegue(withIdentifier: "map", sender: self)
            
        }
        else if indexPath.row == 2{
            self.type = "تنكر ديزل"

            self.performSegue(withIdentifier: "qty", sender: self)
            
        }
    }
        

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "map" {
                let controller = segue.destination as! HomeViewController
                controller.type = self.type
                   }
        else if segue.identifier == "qty" {
        let controller = segue.destination as! qtyViewController
         controller.type = self.type
           }
    }
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {

        if item.tag == 1 {
            UserDefaults.standard.removeObject(forKey: "phone")
            UserDefaults.standard.removeObject(forKey: "login")
            self.performSegue(withIdentifier: "logout", sender: self)
        }
        else if item.tag == 2 {
            self.performSegue(withIdentifier: "about", sender: self)

        }
        else if item.tag == 3 {
            self.performSegue(withIdentifier: "orders", sender: self)

        }
        else if item.tag == 4 {
            self.performSegue(withIdentifier: "update", sender: self)

        }
        else if item.tag == 5 {
            self.performSegue(withIdentifier: "support", sender: self)

        }
    }
}
extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

