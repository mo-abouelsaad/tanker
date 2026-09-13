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
import FirebaseFirestore

class homViewController: UIViewController,UITabBarDelegate {
	@IBOutlet weak var imageview: UIImageView!
	
	@IBOutlet weak var tab: UITabBar!
	@IBOutlet weak var on: UILabel!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var online: UILabel!
	@IBOutlet weak var switchstate: UISwitch!
	var arr  = [Tanker]()
	var type :  String = ""
	override func viewWillAppear(_ animated: Bool) {
	super.viewWillAppear(animated);
	self.navigationController?.isNavigationBarHidden = true
	
	}
    override func viewDidLoad() {
        super.viewDidLoad()
		tab.delegate = self
 		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
		imageview.isUserInteractionEnabled = true
		imageview.addGestureRecognizer(tapGestureRecognizer)
		
        let db = Firestore.firestore()
        let defaults = UserDefaults.standard
        db.collection("trips").whereField("phonep",isEqualTo:defaults.string(forKey: "phone")).whereField("ip", isEqualTo: "true").getDocuments() { (querySnapshot, err) in
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
			   db.collection("provider").whereField("phone",isEqualTo:  UserDefaults.standard.string(forKey: "phone"))
						   .getDocuments() { (querySnapshot, err) in

						   if querySnapshot!.documents !=  nil{
						   var id = querySnapshot!.documents.first?.documentID
							   var online = querySnapshot!.documents.first?["online"] as? String
							   if online == "online"{
								  
											   self.imageview.image = UIImage(named: "tankeronline.png")


									   }
								   
							   
							   else{
								self.imageview.image = UIImage(named: "tankeroffline.png")

							}
							}
		}
	}
	


    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "reserve" {
                let controller = segue.destination as! HomeViewController
                controller.type = self.type
			       }
    }
	@objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
	{
		let tappedImage = tapGestureRecognizer.view as! UIImageView
        let db = Firestore.firestore()
		db.collection("provider").whereField("phone",isEqualTo:  UserDefaults.standard.string(forKey: "phone"))
					.getDocuments() { (querySnapshot, err) in

					if querySnapshot!.documents !=  nil{
					var id = querySnapshot!.documents.first?.documentID
						var online = querySnapshot!.documents.first?["online"] as? String
						if online == "online"{
							let defaults = UserDefaults.standard
							let db = Firestore.firestore()
								 db.collection("provider").whereField("phone",isEqualTo:  defaults.string(forKey: "phone"))
									.getDocuments() { (querySnapshot, err) in

									if querySnapshot!.documents !=  nil{
									var id = querySnapshot!.documents.first?.documentID
										var online = querySnapshot!.documents.first?["online"] as? String
										let sfReference = db.collection("provider").document(id!)
											sfReference.updateData( [ "online" :"offline"], completion: nil)
										let alert = UIAlertController(title: "Alert", message: "you are offline ", preferredStyle: .alert)

																		 alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
																		 self.present(alert, animated: true)
										tappedImage.image = UIImage(named: "tankeroffline.png")
										

								}
							}
						}
						else{
							let defaults = UserDefaults.standard
										   let db = Firestore.firestore()
												db.collection("provider").whereField("phone",isEqualTo:  defaults.string(forKey: "phone"))
												   .getDocuments() { (querySnapshot, err) in

												   if querySnapshot!.documents !=  nil{
												   var id = querySnapshot!.documents.first?.documentID
													   var online = querySnapshot!.documents.first?["online"] as? String
													   let sfReference = db.collection("provider").document(id!)

													   sfReference.updateData( [ "online" :"online"], completion: nil)
													let alert = UIAlertController(title: "Alert", message: "you are Online ", preferredStyle: .alert)

																					 alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
																					 self.present(alert, animated: true)
											   					tappedImage.image = UIImage(named: "tankeronline.png")
										   }
								
							}
						}

				}
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
