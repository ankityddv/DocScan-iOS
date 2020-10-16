//
//  CustomTextField.swift
//  DocScan
//
//  Created by Ankit on 16/10/20.
//

import UIKit

@IBDesignable
class CustomTextField: UITextField {
    
    @IBInspectable var cornerRad: CGFloat = 0{
        didSet{
            layer.cornerRadius = cornerRad
        }
    }

    @IBInspectable var leftImage: UIImage? {
        didSet{
            updateView()
        }
    }
    @IBInspectable var leftPadding: CGFloat = 0 {
        didSet{
            updateView()
        }
    }
    
    //Padding text and image in text field
    
    let padding = UIEdgeInsets(top: 0, left: 35, bottom: 0, right: 5)
    let imagePadding = UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 321)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: imagePadding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    //
    
    
    func updateView() {
        if let image = leftImage {
            leftViewMode = .always
            
            let imageView = UIImageView(frame: CGRect(x: 5, y: 0, width: 20, height: 20))
            imageView.image = image
            imageView.tintColor = tintColor
            
            var width = leftPadding + 20
            
            if borderStyle == UITextField.BorderStyle.none || borderStyle == UITextField.BorderStyle.line {
                width = width + 5
            }
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20))
            view.addSubview(imageView)
            
            leftView = imageView
        } else{
            leftViewMode = .never
        }
        
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ? placeholder! : "", attributes: [NSAttributedString.Key.foregroundColor:tintColor])
    }
}

