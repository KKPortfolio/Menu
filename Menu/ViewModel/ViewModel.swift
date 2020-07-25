//
//  ViewModel.swift
//  Menu
//
//  Created by Kurt Kim on 2020-06-23.
//  Copyright © 2020 Kurt Kim. All rights reserved.
//

import CoreData
import UIKit

class ViewModel {
    var fetchedMenu: [NSManagedObject] = []
    var fetchedGroup: [NSManagedObject] = []
    var defaultMenus: [DefaultMenu] = []
    var defaultGroups: [DefaultGroup] = []
    
    func fetchImage(groupName: String) -> UIImage? {
        let fetchedMenu = CoreDataManager.shared.fetch(entity: "Menu")
        if fetchedMenu.count != 0 {
            for index in 0...fetchedMenu.count-1 {
                if  groupName == fetchedMenu[index].value(forKey: "nameGroup") as? String {
                    return UIImage(data: fetchedMenu[index].value(forKey: "img") as! Data)
                }
            }
            return nil
        } else {
            return nil
        }
    }
    
    func createDefaultMenus(){
        defaultMenus.append(DefaultMenu(menu: "Strawberry Waffle", price: "$9.99", menuImg: UIImage(named: "waffle001")!, menuGroup: "Waffles"))
        defaultMenus.append(DefaultMenu(menu: "Plain Waffle", price: "$10.99", menuImg: UIImage(named: "waffle002")!, menuGroup: "Waffles"))
        defaultMenus.append(DefaultMenu(menu: "Chocolate Waffle", price: "$11.99", menuImg: UIImage(named: "waffle003")!, menuGroup: "Waffles"))
        defaultMenus.append(DefaultMenu(menu: "Chicken Waffle", price: "$12.99", menuImg: UIImage(named: "waffle004")!, menuGroup: "Waffles"))
        defaultMenus.append(DefaultMenu(menu: "Veggie Egg Bennie", price: "$13.99", menuImg: UIImage(named: "eggbennie002")!, menuGroup: "Egg Benedict"))
        defaultMenus.append(DefaultMenu(menu: "Ham Egg Bennie", price: "$9.99", menuImg: UIImage(named: "eggbennie003")!, menuGroup: "Egg Benedict"))
        defaultMenus.append(DefaultMenu(menu: "Hamburger", price: "$11.99", menuImg: UIImage(named: "burger001")!, menuGroup: "Burgers"))
        defaultMenus.append(DefaultMenu(menu: "Cheese Burger", price: "$12.99", menuImg: UIImage(named: "burger002")!, menuGroup: "Burgers"))
        defaultMenus.append(DefaultMenu(menu: "Poutine Burger", price: "$13.99", menuImg: UIImage(named: "burger003")!, menuGroup: "Burgers"))
        saveDefaultMenus(menus: self.defaultMenus)
    }
    
    func saveDefaultMenus(menus: [DefaultMenu]){
        for index in 0...menus.count-1 {
            let menu = NSEntityDescription.insertNewObject(forEntityName: "Menu", into: CoreDataManager.shared.context)
            menu.setValue(menus[index].menuName, forKey: "name")
            menu.setValue(menus[index].menuPrice, forKey: "price")
            menu.setValue(menus[index].menuImg?.pngData(), forKey: "img")
            menu.setValue(menus[index].menuGroup, forKey: "nameGroup")
        }
        CoreDataManager.shared.save()
    }
    
    func createDefaultGroups(){
        self.defaultGroups.append(DefaultGroup(name: "Waffles"))
        self.defaultGroups.append(DefaultGroup(name: "Egg Benedict"))
        self.defaultGroups.append(DefaultGroup(name: "Burgers"))
        saveDefaultGroups(groups: self.defaultGroups)
    }
    
    func saveDefaultGroups(groups: [DefaultGroup]){
        for index in 0...groups.count-1 {
            let group = NSEntityDescription.insertNewObject(forEntityName: "Group", into: CoreDataManager.shared.context)
            group.setValue(groups[index].groupName, forKey: "nameGroup")
        }
        CoreDataManager.shared.save()
    }
}
