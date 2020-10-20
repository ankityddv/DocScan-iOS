//
//  AlertUtil.swift
//  DocScan
//
//  Created by Ankit on 20/10/20.
//

import UIKit
class AlertUtil : UIViewController,UITextFieldDelegate{
    static let shared = AlertUtil()
    var alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
    var okAction = UIAlertAction(title: "", style: .default, handler: nil)
    var cancelAction = UIAlertAction(title: "", style: .default, handler: nil)
    var textValue = ""
    
    func alertWithTextField(parent:UIViewController,title:String,message:String,placeholder:String,value:String,proceedTitle:String,cancelTitle:String,didProceed:@escaping ((String)->Void),didCancel:(()->Void)?) {
        self.alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.okAction = UIAlertAction(title: proceedTitle, style: .default) { (alertAction) in
            didProceed(self.textValue)
        }
        self.cancelAction = UIAlertAction(title: cancelTitle, style: .default){(alertAction) in
            if let cancelCallBack = didCancel{
                cancelCallBack()
            }
        }
        alert.addTextField { (textField) in
            if(value != ""){
                textField.text = value
            }else{
                textField.placeholder = placeholder
            }
            textField.delegate = self
            textField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        }
        self.alert.addAction(self.cancelAction)
        self.alert.addAction(self.okAction)
        
        okAction.isEnabled = false
        parent.present(alert, animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange(textField:UITextField){
        if let text = textField.text{
            if(text == ""){
                self.okAction.isEnabled = false
            }else{
                self.textValue = text
                self.okAction.isEnabled = true
            }
        }else{
            self.okAction.isEnabled = false
        }
    }
}
