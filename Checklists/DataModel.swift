//
//  DataModel.swift
//  Checklists
//
//  Created by Vu Hoang Son on 10/16/17.
//  Copyright © 2017 Son Vu. All rights reserved.
//

import Foundation

class DataModel {
    
    var lists = [Checklist]()
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
            UserDefaults.standard.synchronize()
        }
    }
    
    init() {
        loadChecklists()
        registerDefaults()
        handlerFirstTime()
    }
    
    func documentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentDirectory().appendingPathComponent("Checklists.plist")
    }
    
    // this method is now called saveChecklists()
    func saveChecklists() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        // this line is different from before
        archiver.encode(lists, forKey: "Checklists")
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
    }
    // this method is now called loadChecklists()
    func loadChecklists() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            lists = unarchiver.decodeObject(forKey: "Checklists") as! [Checklist]
            unarchiver.finishDecoding()
            sortChecklists()
        } }
    
    func registerDefaults() {
        let dictionary: [String: Any] = ["ChecklistIndex": -1,
                                         "FirstTime": true,
                                         "ChecklistItemID": 0]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    func handlerFirstTime() {
        let userDefault = UserDefaults.standard
        let firstTime = userDefault.bool(forKey: "FirstTime")
        if firstTime {
            let checklist = Checklist(name: "List", iconName: "No Icon")
            lists.append(checklist)
            
            indexOfSelectedChecklist = 0
            userDefault.set(false, forKey: "FirstTime")
            userDefault.synchronize()
        }
    }
    
    func sortChecklists() {
        lists.sort { (checklist1, checklist2) -> Bool in
            return checklist1.name.localizedStandardCompare(checklist2.name) == .orderedAscending
        }
    }
    
    class func nextChecklistItemID() -> Int {
        let userDefault = UserDefaults.standard
        let itemID = userDefault.integer(forKey: "ChecklistItemID")
        userDefault.set(itemID + 1, forKey: "ChecklistItemID")
        userDefault.synchronize()
        return itemID
    }
}
