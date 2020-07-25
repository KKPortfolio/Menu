//
//  SavedMenusViewController.swift
//  Menu
//
//  Created by Kurt Kim on 2020-06-23.
//  Copyright © 2020 Kurt Kim. All rights reserved.
//

import UIKit
import CoreData

class SavedMenusViewController: UIViewController {

    var viewModel = ViewModel()
    var groupName: String = ""
    var menuName: String = ""
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var savedMenuTableView: UITableView!
    
    @IBAction func editButtonClicked(_ sender: UIBarButtonItem) {
        self.savedMenuTableView.isEditing = !self.savedMenuTableView.isEditing
        sender.title = self.savedMenuTableView.isEditing ? "Done" : "Edit"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchedMenu = CoreDataManager.shared.fetch(entity: "Menu")
        setupTableView()
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    }
}

extension SavedMenusViewController {
    
    func setupTableView(){
        savedMenuTableView.dataSource = self
        savedMenuTableView.delegate = self
        savedMenuTableView.reloadData()
    }
}

extension SavedMenusViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        menuName = (viewModel.fetchedMenu[indexPath.row].value(forKey: "name") as? String)!
        CoreDataManager.shared.updateGroupForMenu(entity: "Menu", menuName: menuName, groupName: groupName)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let menuToDelete = viewModel.fetchedMenu[indexPath.row]
            CoreDataManager.shared.context.delete(menuToDelete)
            CoreDataManager.shared.save()
            viewModel.fetchedMenu = CoreDataManager.shared.fetch(entity: "Menu")
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing {
            return .delete
        }
        return .none
    }
}

extension SavedMenusViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.fetchedMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedMenuCell", for: indexPath)
        cell.textLabel?.text = viewModel.fetchedMenu[indexPath.row].value(forKey: "name") as? String
        cell.detailTextLabel?.text = viewModel.fetchedMenu[indexPath.row].value(forKey: "price") as? String
        cell.imageView?.image = UIImage(data: viewModel.fetchedMenu[indexPath.row].value(forKey: "img") as! Data)
        return cell
    }
}
