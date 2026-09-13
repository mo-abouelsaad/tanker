//
//  OrdersViewController.swift
//  tn
//
//  Created by moham on 5/18/20.
//  Copyright © 2020 Mohamed Aboelsaad. All rights reserved.
//

import UIKit
import FirebaseFirestore

class OrdersViewController: UIViewController {
	@IBOutlet weak var tableview: UITableView!
	var arr = [order]()
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated);
    self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()

		let db = Firestore.firestore()
        var defaults = UserDefaults.standard
        db.collection("trips").whereField("phoneu",isEqualTo: defaults.string(forKey: "phone")).getDocuments() { (querySnapshot, err) in
				   if let err = err {
					   print("Error getting documents: \(err)")
				   } else {
					   for document in querySnapshot!.documents {
                        let str : Double = document.data()["price"] as! Double
                        self.arr.append(order(name: "Order ID : "+String(document.documentID.uppercased() as! String),phone: ("price : "+String(str)),id: "provider number : "+String(document.data()["phonep"] as! String),time: document.data()["day"]))
					}
					self.tableview.delegate=self
					self.tableview.dataSource=self
					self.tableview.reloadData()
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

}
extension OrdersViewController: UITableViewDataSource, UITableViewDelegate {
	
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier : "Cell") as? OrderTableViewCell
		cell?.name.text = arr[indexPath.row].name
        cell?.phone.text = arr[indexPath.row].phone
        cell?.id.text = arr[indexPath.row].id
        let ts = arr[indexPath.row].time as! Timestamp
        let aDate = ts.dateValue()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        let formattedTimeZoneStr = formatter.string(from: aDate)
        cell?.day.text = formattedTimeZoneStr

        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
    }
	
	
}

