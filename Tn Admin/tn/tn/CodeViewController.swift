//
//  CodeViewController.swift
//  tn
//
//  Created by moham on 5/22/20.
//  Copyright © 2020 Mohamed Aboelsaad. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import GooglePlaces
import  FirebaseFirestore
class CodeViewController: UIViewController {

	@IBOutlet weak var co: UIButton!
	@IBOutlet weak var code: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
		co.layer.cornerRadius = 10
		co.layer.borderWidth = 1
		co.layer.borderColor = UIColor.purple.cgColor
            
        }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func code(_ sender: Any) {
        let db = Firestore.firestore()
        let defaults = UserDefaults.standard
		print( defaults.string(forKey: "phone")!)
		db.collection("provider").whereField("authtoken", isEqualTo: Int(self.code.text!)).whereField("phone", isEqualTo: defaults.string(forKey: "phone")!)
        .getDocuments() {
			(querySnapshot, err) in
			if querySnapshot!.documents.first?.data()["phone"]! !=  nil{
                        defaults.set(true, forKey: "login")
                    self.performSegue(withIdentifier: "home", sender: self)
                    
                    
			}else{
				let alert = UIAlertController(title: "Alert", message: "Code doesnt match", preferredStyle: .alert)
				  alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
				  self.present(alert, animated: true)
			}
        }
    }
}
