//
//  CoreDataManager.swift
//  Menu
//
//  Created by Kurt Kim on 2020-06-23.
//  Copyright © 2020 Kurt Kim. All rights reserved.
//

import CoreData
import UIKit
import Foundation

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func save(){
        do {
            try context.save()
        } catch let error as NSError {
            print("save error: \(error), \(error.userInfo)")
        }
    }
    
    func fetch(entity: String)->[NSManagedObject]{
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
        var fetchedResults: [NSManagedObject] = []
        do {
            fetchedResults = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("fetch error: \(error), \(error.userInfo)")
        }
        return fetchedResults
    }
    
    func updateGroupForMenu(entity: String, menuName: String, groupName: String){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.predicate = NSPredicate(format: "name = %@", menuName)
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
                results![0].setValue(groupName, forKey: "nameGroup")
            }
        } catch let error as NSError {
            print("fetch error: \(error), \(error.userInfo)")
        }
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Save error: \(error), \(error.userInfo)")
        }
    }
    
    func releaseAllMenusFromGroup(groupName: String){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Menu")
        fetchRequest.predicate = NSPredicate(format: "nameGroup = %@", groupName)
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
                for index in 0...results!.count-1 {
                    results![index].setValue("", forKey: "nameGroup")
                }
            }
        } catch let error as NSError {
            print("Fetch error: \(error), \(error.userInfo)")
        }
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Save error: \(error), \(error.userInfo)")
        }
    }
    
    func releaseAMenuFromGroup(menuName: String){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Menu")
        fetchRequest.predicate = NSPredicate(format: "name = %@", menuName)
        
        do {
            let result = try context.fetch(fetchRequest) as? [NSManagedObject]
            if result?.count != 0 {
                result![0].setValue("", forKey: "nameGroup")
            }
        } catch let error as NSError {
            print("Fetch error: \(error), \(error.userInfo)")
        }
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Save error: \(error), \(error.userInfo)")
        }
    }
}
