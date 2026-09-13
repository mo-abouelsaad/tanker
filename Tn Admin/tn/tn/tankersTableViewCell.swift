//
//  tankersTableViewCell.swift
//  tn
//
//  Created by Mohamed Aboelsaad on 5/9/20.
//  Copyright © 2020 Mohamed Aboelsaad. All rights reserved.
//

import UIKit

class tankersTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            contentView.backgroundColor = UIColor.lightGray
        } else {
            contentView.backgroundColor = UIColor.blue
        }
    }

}
