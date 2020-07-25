//
//  DefaultMenu.swift
//  Menu
//
//  Created by Kurt Kim on 2020-06-29.
//  Copyright © 2020 Kurt Kim. All rights reserved.
//

import Foundation
import UIKit

class DefaultMenu {
    var menuName: String = ""
    var menuPrice: String = ""
    var menuImg: UIImage?
    var menuGroup: String = ""
    
    init(menu: String, price: String, menuImg: UIImage, menuGroup: String) {
        self.menuName = menu
        self.menuPrice = price
        self.menuImg = menuImg
        self.menuGroup = menuGroup
    }
}
