//
//  AppIconService.swift
//  DocScan
//
//  Created by Ankit on 15/10/20.
//

import UIKit

class AppIConService {
    
    let application = UIApplication.shared
    
    enum AppIcon: String {
        case primaryAppIcon
        case blackIcon
        case orangeIcon
        case purpleIcon
    }
    
    func changeAppIcon(to appIcon: AppIcon) {
        let appIconValue: String? = appIcon == .primaryAppIcon ? nil : appIcon.rawValue
        application.setAlternateIconName(appIconValue)
    }

}
