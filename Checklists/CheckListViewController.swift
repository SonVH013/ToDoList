//
//  ViewController.swift
//  Checklists
//
//  Created by Son Vu on 9/25/17.
//  Copyright © 2017 Son Vu. All rights reserved.
//

import UIKit

class CheckListViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    //var items: [ChecklistItem]
    var checklist: Checklist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = checklist.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    required init?(coder aDecoder: NSCoder) {
//        checklist.items = [ChecklistItem]()
//        // ???
//        super.init(coder: aDecoder)
//        //loadChecklistItems()
//        //print("Documents folder is: \(documentsDirectory())")
//        //print("Data file path is: \(dataFilePath())")
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Checklistitem", for: indexPath)
        let item = checklist.items[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[indexPath.row]
            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        //saveChecklistItems()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //
        checklist.items.remove(at: indexPath.row)
        let indexPath = [indexPath]
        tableView.deleteRows(at: indexPath, with: .automatic)
        //saveChecklistItems()
    }
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        dismiss(animated: true, completion: nil)
        //saveChecklistItems()
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        if let index = checklist.items.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        dismiss(animated: true, completion: nil)
        //saveChecklistItems()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        let view = cell.viewWithTag(1001) as! UILabel
        if item.checked {
            view.text = "√"
        } else {
            view.text = ""
        }
    }
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        //label.text = item.text
        label.text = "\(item.itemID): \(item.text)"
    }
    
//    func documentsDirectory() -> URL {
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        return paths[0]
//    }
//
//    func dataFilePath() -> URL {
//        return documentsDirectory().appendingPathComponent("Checklists.plist")
//    }
    
//    func saveChecklistItems() {
//        let data = NSMutableData()
//        let archiver = NSKeyedArchiver(forWritingWith: data)
//        archiver.encode(items, forKey: "ChecklistItems")
//        archiver.finishEncoding()
//        data.write(to: dataFilePath(), atomically: true)
//    }
//
//    func loadChecklistItems() {
//        let path = dataFilePath()
//        if let data = try? Data(contentsOf: path) {
//            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
//            items = unarchiver.decodeObject(forKey: "ChecklistItems") as! [ChecklistItem]
//            unarchiver.finishDecoding()
//        }
//    }
}

