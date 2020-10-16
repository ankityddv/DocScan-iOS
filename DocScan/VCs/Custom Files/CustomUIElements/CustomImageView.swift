//
//  CustomImageView.swift
//  DocScan
//
//  Created by Ankit on 15/10/20.
//

import UIKit

@IBDesignable
class CustomImageView: UIImageView {
    @IBInspectable var shadowRadius: CGFloat = 15.0 {
        didSet {
            self.updateView()
        }
    }
    
    //Apply params
    func updateView() {
        self.layer.shadowRadius = self.shadowRadius
    }
}
