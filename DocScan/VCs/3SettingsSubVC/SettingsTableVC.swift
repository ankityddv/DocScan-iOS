//
//  SettingsTableVC.swift
//  DocScan
//
//  Created by Ankit on 15/10/20.
//

import UIKit

class SettingsTableVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // To hide the top line
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
}
