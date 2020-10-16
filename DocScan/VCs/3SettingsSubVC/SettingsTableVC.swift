//
//  SettingsTableVC.swift
//  DocScan
//
//  Created by Ankit on 15/10/20.
//

import UIKit
import MessageUI

class SettingsTableVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // To hide the top line
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    //MARK:- Open Mail VC
        func showMailComposer(){
            guard MFMailComposeViewController.canSendMail() else {
                return
            }
            let composer = MFMailComposeViewController()
            composer.mailComposeDelegate = self
            composer.setToRecipients(["yadavankit840@gmail.com"])
            composer.setSubject("Support!")
            composer.setMessageBody("I love this app, but ", isHTML: false)
            present(composer, animated: true)
        }
    
    @objc func setTheme(){
        let actionSheet = UIAlertController.init(title: "Select apperances", message: "Don't you like light theme?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction.init(title: "System", style: UIAlertAction.Style.default, handler: { (action) in
            UIApplication.shared.windows.forEach { window in
                                        window.overrideUserInterfaceStyle = .unspecified
                           }
            }))
        actionSheet.addAction(UIAlertAction.init(title: "Light", style: UIAlertAction.Style.default, handler: { (action) in
            UIApplication.shared.windows.forEach { window in
                                        window.overrideUserInterfaceStyle = .light
                           }
            }))
        actionSheet.addAction(UIAlertAction.init(title: "Dark", style: UIAlertAction.Style.default, handler: { (action) in
            UIApplication.shared.windows.forEach { window in
                                        window.overrideUserInterfaceStyle = .dark
                           }
            }))
        actionSheet.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) in
            }))
            self.present(actionSheet, animated: true, completion: nil)}
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 1{
            setTheme()
        }
        // MARK: - open mail (SECTION 2)
        else if indexPath.section == 0 && indexPath.row == 2 {
            showMailComposer()
        }
  
        
    }
    
}

extension SettingsTableVC: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error {
            controller.dismiss(animated: true)
        }
        switch result {
        case .cancelled:
            print("Cancelled")
        case .failed:
            print("Failed to send")
        case .saved:
            print("Saved")
        case .sent:
            print("Email Sent")
        }
        controller.dismiss(animated: true)
    }
}
