//
//  appIconsCell.swift
//  DocScan
//
//  Created by Ankit on 15/10/20.
//

import UIKit

class appIconsCell: UITableViewCell {

    @IBOutlet weak var logImageView: UIImageView!
    @IBOutlet weak var iconTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
