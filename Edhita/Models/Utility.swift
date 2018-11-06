//
//  Utility.swift
//  Edhita
//
//  Created by Tatsuya Tobioka on 2018/11/06.
//  Copyright © 2018 tnantoka. All rights reserved.
//

import Foundation

struct Utility {
    static func barButtonItem(target: UIViewController, icon: FAKIcon, action: Selector) -> UIBarButtonItem {
        let image = self.iconImage(icon)
        let item = UIBarButtonItem(image: image, style: .plain, target: target, action: action)
        return item
    }

    static func iconImage(_ icon: FAKIcon) -> UIImage {
        return icon.image(with: CGSize(width: icon.iconFontSize, height: icon.iconFontSize))
    }
}
