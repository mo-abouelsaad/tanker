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
class updateViewController: UIViewController,CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var lname: UITextField!
    
	@IBOutlet weak var co: UIButton!
	@IBOutlet weak var picker: UIPickerView!
	
    @IBOutlet weak var emai: UITextField!
	
	
	@IBOutlet weak var qty: UIPickerView!
	var pickerData2:[String] = ["10000","5000","3000","اختر"]

    var currentLoc: CLLocation!
	var pickerData:[String] = ["اختر","تانكر ماء", "تانكر صرف", "تانكر ديزل",]
    var locationManager = CLLocationManager()
     var currentLocation: CLLocation?
	override func viewWillAppear(_ animated: Bool) {
	super.viewWillAppear(animated);
	self.navigationController?.isNavigationBarHidden = false
	}
    override func viewDidLoad() {
        super.viewDidLoad()
		self.picker.setValue(UIColor.white, forKeyPath: "textColor")
		self.qty.setValue(UIColor.white, forKeyPath: "textColor")

        self.picker.delegate = self
        self.picker.dataSource = self
		self.qty.delegate = self
        self.qty.dataSource = self
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")

			   //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
			   //tap.cancelsTouchesInView = false
		co.layer.cornerRadius = 10
		co.layer.borderWidth = 1
		co.layer.borderColor = UIColor.purple.cgColor
			   view.addGestureRecognizer(tap)
        // Input the data into the array
        
        
    }
    @IBAction func ddd(_ sender: Any) {
        let db = Firestore.firestore()
        locationManager.requestWhenInUseAuthorization()
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
        CLLocationManager.authorizationStatus() == .authorizedAlways) {
           currentLoc = locationManager.location
        }
		db.collection("provider").whereField("phone", isEqualTo:UserDefaults.standard.string(forKey: "phone"))
                            .getDocuments() { (querySnapshot, err) in

                                    if querySnapshot!.documents !=  nil{
                                        var id = querySnapshot!.documents.first?.documentID
                                        if(id != nil){
                                            let sfReference = db.collection("provider").document(id!)
                                            sfReference.updateData(["email": self.emai.text!,"long" : self.currentLoc.coordinate.longitude,"lat" : self.currentLoc.coordinate.latitude,
												"cat" : self.pickerData[self.picker.selectedRow(inComponent: 0)],
														"token" : UserDefaults.standard.string(forKey: "token"),"qty":self.pickerData2[self.qty.selectedRow(inComponent:0)]])
           let alert = UIAlertController(title: "Alert", message: "your Personal Info Updated Successfully ", preferredStyle: .alert)

                                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                            self.present(alert, animated: true)
                                        }else{
											let defaults = UserDefaults.standard
                                            let sfReference = db.collection("provider")
                                                                                       sfReference.addDocument(data: [
                                                                                       "email": self.emai.text!,
																					   "cat" : self.picker.selectedRow(inComponent: 0),
                                                                                       "approve": "N",
																					   "phone" :  defaults.string(forKey: "phone")
																						,"lat" : self.pickerData[self.picker.selectedRow(inComponent: 0)],
																						"token" : UserDefaults.standard.string(forKey: "token")
																						,"qty" :self.pickerData2[self.qty.selectedRow(inComponent: 0)]
																					])
                                            let alert = UIAlertController(title: "Alert", message: "your Personal Info Inserted Successfully ", preferredStyle: .alert)
                                                                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                            self.present(alert, animated: true)

                                        }
                                }
        }
    }
	func numberOfComponents(in pickerView: UIPickerView)-> Int{
		   return 1
	   }
	   
	   // The number of rows of data
	   func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int)->Int{
		var data : Int = 0
		if pickerView.tag == 1{
		   data = pickerData.count
		}else if pickerView.tag == 2 {
			data = pickerData2.count
		}
		return data
	}
	   
	   // The data to return fopr the row and component (column) that's being passed in
	   func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		var data : String = ""
		if pickerView.tag == 1{
		    data =  pickerData[row]
		}else if pickerView.tag == 2{
			 data =  pickerData2[row]
		}
		return data
	}
     @objc func dismissKeyboard() {
				view.endEditing(true)
			}
		}
