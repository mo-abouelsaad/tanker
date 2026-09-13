//
//  PersonCell.swift
//  tn
//
//  Created by Mohamed Aboelsaad on 5/14/20.
//  Copyright © 2020 Mohamed Aboelsaad. All rights reserved.
//

import UIKit

class PersonCell: UITableViewCell {
    
    @IBOutlet weak var personImage: UIImageView!
    @IBOutlet weak var persontitleLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

		if selected {

		}
		
	}
    
}
