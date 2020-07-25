//
//  MenuViewController.swift
//  Menu
//
//  Created by Kurt Kim on 2020-06-23.
//  Copyright © 2020 Kurt Kim. All rights reserved.
//

import UIKit
import CoreData
import Photos

class MenuViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var editedImage: UIImage?
    var viewModel = ViewModel()
    
    
    @IBOutlet weak var duplicatedNameWarning: UILabel!
    @IBOutlet weak var menuPhotoImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: PriceTextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func setImage(_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        priceTextField.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        viewModel.fetchedMenu = CoreDataManager.shared.fetch(entity: "Menu")
        duplicatedNameWarning.isHidden = true
        updateSaveButtonState()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button === saveButton else { return }
        let menu = NSEntityDescription.insertNewObject(forEntityName: "Menu", into: CoreDataManager.shared.context)
        menu.setValue(nameTextField.text, forKey: "name")
        menu.setValue(priceTextField.text, forKey: "price")
        menu.setValue(menuPhotoImageView.image?.pngData(), forKey: "img")
        CoreDataManager.shared.save()
    }
}

extension MenuViewController {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            self.editedImage = image
            menuPhotoImageView.image = image
        } else if let image = info[.originalImage] as? UIImage{
            menuPhotoImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func isExistingMenu(newMenuName: String) -> Bool {
        if viewModel.fetchedMenu.count != 0 {
            for index in 0...viewModel.fetchedMenu.count - 1 {
                if newMenuName == (viewModel.fetchedMenu[index].value(forKey: "name") as! String) {
                    return true
                }
            }
            return false
        }
        return false
    }
}

extension MenuViewController {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    private func updateSaveButtonState(){
        let text = nameTextField.text ?? ""
        if text.isEmpty {
            saveButton.isEnabled = false
            duplicatedNameWarning.isHidden = true
            return
        } else {
            saveButton.isEnabled = true
            duplicatedNameWarning.isHidden = true
        }
        
        if isExistingMenu(newMenuName: nameTextField.text!) {
            saveButton.isEnabled = false
            duplicatedNameWarning.isHidden = false
        } else {
            saveButton.isEnabled = true
            duplicatedNameWarning.isHidden = true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
}


