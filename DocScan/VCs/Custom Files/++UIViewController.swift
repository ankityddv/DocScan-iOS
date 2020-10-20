//
//  ++UIViewController.swift
//  DocScan
//
//  Created by Ankit on 20/10/20.
//


import UIKit
extension UIViewController{
    func presentAlert(title:String,message:String) {
        let genericAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .destructive, handler: nil)
        genericAlert.addAction(okAction)
        self.present(genericAlert, animated: true, completion: nil)
    }
    func presentAlert(title:String,message:String,okAction:@escaping (()->Void)) {
        let genericAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .destructive){
            (alertAction)in
            okAction()
        }
        genericAlert.addAction(okAction)
        self.present(genericAlert, animated: true, completion: nil)
    }
}
