//
//  qtyViewController.swift
//  tn
//
//  Created by moham on 5/28/20.
//  Copyright © 2020 Mohamed Aboelsaad. All rights reserved.
//

import UIKit

class qtyViewController: UIViewController {
    var type :  String = ""
    var qty : Double = 0
    @IBOutlet weak var lbl: UILabel!
    
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var step: UIStepper!
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated);
    self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.type == "تنكر ماء"{
                   step.value = 500
                   step.stepValue = 500
                   step.minimumValue = 500
                   step.maximumValue = 10000
               }
               else if self.type == "تنكر ديزل"{
                   step.value = 500
                   step.stepValue = 100
                   step.minimumValue = 100
                   step.maximumValue = 10000
               }
        
        btn.layer.cornerRadius = 10
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.black.cgColor
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func changed(_ sender: Any) {
                                 var s = self.step.value
                                 if self.type == "تنكر ماء"{
                                    self.qty = self.step.value

                                 self.lbl.text = String(self.step.value)+"L."
                                 }
                                 else if self.type == "تنكر ديزل"{
                                    self.qty = self.step.value
                                     self.lbl.text = String(self.step.value)+"L."
                                 }

    }
    
    @IBAction func map(_ sender: Any) {
        performSegue(withIdentifier: "mapqty", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapqty" {
                let controller = segue.destination as! HomeViewController
                controller.qty = self.qty
                controller.type = self.type
       }
    }
}
