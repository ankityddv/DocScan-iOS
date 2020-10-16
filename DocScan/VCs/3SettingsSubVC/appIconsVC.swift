//
//  appIconsVC.swift
//  DocScan
//
//  Created by Ankit on 15/10/20.
//

import UIKit

class appIconsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var myTableView: UITableView!
    
    //MARK:- To add app icon
    let appIconService = AppIConService()
    let imageArr = ["blueIcon","blackIcon","orangeIcon","purpleIcon"]
    let iconNameArr = ["Default","Black","Orange","Purple"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (iconNameArr.count)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        let cell:appIconsCell = tableView.dequeueReusableCell(withIdentifier: "appIconsCell", for: indexPath) as! appIconsCell
        cell.logImageView?.image = UIImage(named: imageArr[indexPath.row])
        cell.logImageView.layer.cornerRadius = 20
        cell.iconTitle.text = iconNameArr[indexPath.row]
        return (cell)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            appIconService.changeAppIcon(to: .primaryAppIcon)
        }
        else if indexPath.row == 1{
            appIconService.changeAppIcon(to: .blackIcon)
        }
        else if indexPath.row == 2{
            appIconService.changeAppIcon(to: .orangeIcon)
        }
        else if indexPath.row == 3{
            appIconService.changeAppIcon(to: .purpleIcon)
        }
        
        //myTableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    /*
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
       return "Select"
    }
    */

}
