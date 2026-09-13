//
//  SplashViewController.swift
//  tn
//
//  Created by moham on 5/30/20.
//  Copyright © 2020 Mohamed Aboelsaad. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

	
	override func viewWillAppear(_ animated: Bool) {
	super.viewWillAppear(animated);
	self.navigationController?.isNavigationBarHidden = false
}
    override func viewDidLoad() {
        super.viewDidLoad()

		if  UserDefaults.standard.string(forKey: "login") != nil {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "home3", sender: self)

                  }
		}else{
		DispatchQueue.main.async {
		self.performSegue(withIdentifier: "hm", sender: self)

			  
			}}	    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
