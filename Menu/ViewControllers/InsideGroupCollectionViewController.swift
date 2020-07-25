//
//  InsideGroupCollectionViewController.swift
//  Menu
//
//  Created by Kurt Kim on 2020-06-26.
//  Copyright © 2020 Kurt Kim. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

struct CustomData {

    var menuDescription: NSAttributedString
    var menuImage: UIImage
}

class InsideGroupCollectionViewController: UICollectionViewController {

    var viewModel = ViewModel()
    var groupName: String = ""
    var matchedIndexes: [Int] = []
    var matchedMenus: [CustomData] = []

    @IBAction func unwindToInsideGroupCollectionViewController(sender: UIStoryboardSegue){
        print("View Loaded Successfully.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView!.register(InsideGroupCollectionViewCell.self, forCellWithReuseIdentifier: "InsideGroupCell")
        viewModel.fetchedMenu = CoreDataManager.shared.fetch(entity: "Menu")
        setupCollectionView()
        setupLongPressGesture()
        collectionView.reloadData()
        collectionView.scrollToItem(at: [0], at: .top, animated: true)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let savedMenuViewController = segue.destination as? SavedMenusViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        savedMenuViewController.groupName = groupName
    }
}

extension InsideGroupCollectionViewController {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matchedIndexes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InsideGroupCell", for: indexPath) as! InsideGroupCollectionViewCell
        cell.data = self.matchedMenus[indexPath.item]
        return cell
    }
}

extension InsideGroupCollectionViewController {
    func setupCollectionView(){
        matchedMenus.removeAll()
        matchedIndexes.removeAll()
        if viewModel.fetchedMenu.count != 0 {
            for index in 0...viewModel.fetchedMenu.count-1 {
                let groupName = viewModel.fetchedMenu[index].value(forKey: "nameGroup") as? String
                if groupName == self.groupName {
                    matchedIndexes.append(index)
                }
            }
        }
        if self.matchedIndexes.count != 0 {
            for index in 0...self.matchedIndexes.count-1 {
                let attributedString = NSMutableAttributedString(string: "\(viewModel.fetchedMenu[matchedIndexes[index]].value(forKey: "name") as! String)\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 28), NSAttributedString.Key.foregroundColor: UIColor.gray])
                attributedString.append(NSAttributedString(string: "\(viewModel.fetchedMenu[matchedIndexes[index]].value(forKey: "price") as! String)", attributes: [NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 19), NSAttributedString.Key.foregroundColor: UIColor.gray]))
                let customData = CustomData(menuDescription: attributedString, menuImage: UIImage(data: viewModel.fetchedMenu[matchedIndexes[index]].value(forKey: "img") as! Data)!)
                matchedMenus.append(customData)
            }
        }
        collectionView.isPagingEnabled = true
        navigationItem.title = groupName
    }
}

extension InsideGroupCollectionViewController: UIGestureRecognizerDelegate {
    
    func setupLongPressGesture(){
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.delegate = self
        longPressGesture.delaysTouchesBegan = true
        self.collectionView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state != UIGestureRecognizer.State.ended {
            return
        }
        let cgPoint = gestureRecognizer.location(in: self.collectionView)
        let indexPath: IndexPath = self.collectionView.indexPathForItem(at: cgPoint)!
        let alertController = UIAlertController(title: "Remove from the group?", message: "", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Yes", style: .default, handler: { alert -> Void in
            CoreDataManager.shared.releaseAMenuFromGroup(menuName: self.stringSeparation(source: self.matchedMenus[indexPath.item].menuDescription))
            self.viewModel.fetchedMenu = CoreDataManager.shared.fetch(entity: "Menu")
            self.setupCollectionView()
            self.collectionView.reloadData()
        })
        alertController.addAction(deleteAction)
        alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func stringSeparation(source: NSAttributedString) -> String{
        let nsToString: String = source.string
        let delimiter = "\n"
        let separatedString = nsToString.components(separatedBy: delimiter)
        return separatedString[0]
    }
}

