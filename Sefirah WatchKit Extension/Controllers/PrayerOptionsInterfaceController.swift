//
//  PrayerOptionsInterfaceController.swift
//  Sefirah
//
//  Created by Josh Siegel on 5/1/16.
//  Copyright © 2016 Josh Siegel. All rights reserved.
//

import WatchKit
import Foundation


class PrayerOptionsInterfaceController: WKInterfaceController {
    @IBOutlet var prayerOptionsTable: WKInterfaceTable!
    var prayerOptions = Options.allValues
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        loadTableData()
    }
    
    func loadTableData() {
        self.prayerOptionsTable.setNumberOfRows(prayerOptions.count, withRowType: "PrayerOptionRow")
        for index in 0..<prayerOptionsTable.numberOfRows {
            if let controller = prayerOptionsTable.rowController(at: index) as? PrayerOptionsRowController {
                controller.prayerOption = prayerOptions[index]
            }
        }
    }
    
    
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        
        
    }
    
    override func didAppear() {
        super.didAppear()

    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        let option = prayerOptions[rowIndex]
        var savedOptions = UserDefaults.standard.array(forKey: "Options") as! [String]
        if !savedOptions.contains(option.rawValue) {
            savedOptions.append(option.rawValue)
        } else {
            let index = savedOptions.index(of: option.rawValue)
            savedOptions.remove(at: index!)
        }
        UserDefaults.standard.setValue(savedOptions, forKey: "Options")
        loadTableData()
        
    }

}
