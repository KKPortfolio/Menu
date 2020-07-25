//
//  GroupViewController.swift
//  Menu
//
//  Created by Kurt Kim on 2020-06-23.
//  Copyright © 2020 Kurt Kim. All rights reserved.
//

import UIKit
import CoreData

class GroupViewController: UIViewController {

    var viewModel = ViewModel()
    var groupName: String = ""
    
    @IBOutlet weak var groupTableView: UITableView!
    
    @IBAction func addGroupButton(_ sender: UIBarButtonItem) {
        var alertController: UIAlertController?
        alertController = UIAlertController(title: "New Group", message: "Enter a name for this group.", preferredStyle: .alert)
        alertController?.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "Name"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            let textField = (alertController?.textFields![0])! as UITextField
            guard let userInputGroupName = textField.text else { return }
            if userInputGroupName.isEmpty {
                let innerAlertController = UIAlertController(title: "Error", message: "Group name should not be empty.", preferredStyle: .alert)
                innerAlertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: { ( action: UIAlertAction!) in }))
                self.present(innerAlertController, animated: true, completion: nil)
                return
            }
            if self.isExistingGroup(newGroupName: userInputGroupName) {
                let innerAlertController = UIAlertController(title: "Error", message: "Group already exists.", preferredStyle: .alert)
                innerAlertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: { ( action: UIAlertAction!) in }))
                self.present(innerAlertController, animated: true, completion: nil)
                return
            }
            let group = NSEntityDescription.insertNewObject(forEntityName: "Group", into: CoreDataManager.shared.context)
            group.setValue(userInputGroupName, forKey: "nameGroup")
            CoreDataManager.shared.save()
            self.viewModel.fetchedGroup = CoreDataManager.shared.fetch(entity: "Group")
            self.groupTableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action : UIAlertAction!) -> Void in })
        
        alertController?.addAction(saveAction)
        alertController?.addAction(cancelAction)
        self.present(alertController!, animated: true, completion: nil)
    }
    @IBAction func unwindToGroupViewController(sender: UIStoryboardSegue){
        print("View Loaded Successfully.")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "InsideGroupSegue" {
            guard let insideGroupViewController = segue.destination as? InsideGroupCollectionViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            insideGroupViewController.groupName = groupName
        } else {
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isFirstLaunch() {
            viewModel.createDefaultMenus()
            viewModel.createDefaultGroups()
            instructionalert()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchedMenu = CoreDataManager.shared.fetch(entity: "Menu")
        viewModel.fetchedGroup = CoreDataManager.shared.fetch(entity: "Group")
        setupTableView()
    }
}

extension GroupViewController {
    
    func setupTableView(){
        groupTableView.delegate = self
        groupTableView.dataSource = self
        groupTableView.reloadData()
    }
    
    func isFirstLaunch() -> Bool {
        if (!UserDefaults.standard.bool(forKey: "launched_before")) {
            UserDefaults.standard.set(true, forKey: "launched_before")
            return true
        }
        return false
    }
    
    func isExistingGroup(newGroupName: String) -> Bool {
        if viewModel.fetchedGroup.count != 0 {
            for index in 0...viewModel.fetchedGroup.count - 1 {
                if newGroupName == (viewModel.fetchedGroup[index].value(forKey: "nameGroup") as! String) {
                    return true
                }
            }
            return false
        }
        return false
    }
    
    func instructionalert(){
        let message: String = "1. Add groups and menus.\n2. Tap the group name and add the menus.\n\nTo delete the group, swipe group name to left.\nTo remove menu from the group, long press.\nTo delete the menu, use the edit button."
        let alertcontroller = UIAlertController(title: "Instruction", message: message, preferredStyle: .alert)
        let acceptAction = UIAlertAction(title: "Got It!", style: .cancel, handler: { (action: UIAlertAction!) -> Void in })
//        resize alertcontroller using constraints
        let defaultWidthConstraint = alertcontroller.view.constraints.filter({ return $0.firstAttribute == .width})
        alertcontroller.view.removeConstraint(defaultWidthConstraint[0])
        let newWidth = UIScreen.main.bounds.width * 0.90
        let newWidthContraint = NSLayoutConstraint(item: alertcontroller.view as Any, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: newWidth)
        alertcontroller.view.addConstraint(newWidthContraint)
        let firstContainer = alertcontroller.view.subviews[0]
        let firstContainerWidthContraint = firstContainer.constraints.filter({ return $0.firstAttribute == .width && $0.secondItem == nil})
        firstContainer.removeConstraint(firstContainerWidthContraint[0])
        alertcontroller.view.addConstraint(NSLayoutConstraint(item: firstContainer, attribute: .width, relatedBy: .equal, toItem: alertcontroller.view, attribute: .width, multiplier: 1.0, constant: 0))
        let innerBackground = firstContainer.subviews[0]
        let innerConstraints = innerBackground.constraints.filter({ return $0.firstAttribute == .width && $0.secondItem == nil })
        innerBackground.removeConstraints(innerConstraints)
        firstContainer.addConstraint(NSLayoutConstraint(item: innerBackground, attribute: .width, relatedBy: .equal, toItem: firstContainer, attribute: .width, multiplier: 1.0, constant: 1))
        alertcontroller.addAction(acceptAction)
        self.present(alertcontroller, animated: true, completion: nil)
    }    
}

extension GroupViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.fetchedGroup.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath)
        cell.textLabel?.text = viewModel.fetchedGroup[indexPath.row].value(forKey: "nameGroup") as? String
        cell.imageView?.image = viewModel.fetchImage(groupName: cell.textLabel?.text ?? "")
        return cell
    }
}
extension GroupViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        groupName = viewModel.fetchedGroup[indexPath.row].value(forKey: "nameGroup") as! String
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let groupToDelete = viewModel.fetchedGroup[indexPath.row]
            CoreDataManager.shared.context.delete(groupToDelete)
            CoreDataManager.shared.save()
            CoreDataManager.shared.releaseAllMenusFromGroup(groupName: (tableView.cellForRow(at: indexPath)?.textLabel?.text)!)
            viewModel.fetchedGroup = CoreDataManager.shared.fetch(entity: "Group")
            viewModel.fetchedMenu = CoreDataManager.shared.fetch(entity: "Menu")
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
    }
}

