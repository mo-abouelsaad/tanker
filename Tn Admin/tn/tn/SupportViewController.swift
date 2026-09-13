//
//  SupportViewController.swift
//  tn
//
//  Created by moham on 5/29/20.
//  Copyright © 2020 Mohamed Aboelsaad. All rights reserved.
//

import UIKit

class SupportViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated);
    self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()

		self.navigationController?.isNavigationBarHidden = false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func support(_ sender: Any) {
UIApplication.shared.open(URL(string:"https://api.whatsapp.com/send?phone=96550008957")!, options: [:], completionHandler: nil)
    }
    
    @IBAction func supportwhatsapp(_ sender: Any) {
        if let url = URL(string: "tel://500008957") {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        }
    }
    
        @IBAction func support2(_ sender: Any) {
    UIApplication.shared.open(URL(string:"https://api.whatsapp.com/send?phone=96599707414")!, options: [:], completionHandler: nil)
        }
        
        @IBAction func supportwhatsapp2(_ sender: Any) {
            if let url = URL(string: "tel://96599707414") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                
            }
        }
	@IBAction func whats3(_ sender: Any) {
		UIApplication.shared.open(URL(string:"https://api.whatsapp.com/send?phone=96560707594")!, options: [:], completionHandler: nil)
	}
	@IBAction func support3(_ sender: Any) {
		if let url = URL(string: "tel://60707594") {
		UIApplication.shared.open(url, options: [:], completionHandler: nil)
			
		}
	}
}
