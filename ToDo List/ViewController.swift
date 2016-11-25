//
//  ViewController.swift
//  ToDo List
//
//  Created by Stephen on 25/11/2016.
//  Copyright © 2016 Luminator Technology. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var importantCheckbox: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var DeleteButton: NSButton!
    
    var toDoItems : [ToDoItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getToDoItems()
    }
    
    func getToDoItems() {
        // Get the todoItems from coredata
        if let context = (NSApplication.shared().delegate as? AppDelegate)?.managedObjectContext {
            do {
                // Set them to the class property
                toDoItems = try context.fetch(ToDoItem.fetchRequest())
            } catch {}
        }
        
        
        // Update the table
        tableView.reloadData()
    }
    
    @IBAction func addClicked(_ sender: Any) {
        if textField.stringValue != "" {
            if let context = (NSApplication.shared().delegate as? AppDelegate)?.managedObjectContext {
                let todoItem = ToDoItem(context: context)
                todoItem.name = textField.stringValue
                todoItem.important = importantCheckbox.state == 0 ? false : true
                
                (NSApplication.shared().delegate as? AppDelegate)?.saveAction(nil)
                
                // Reset fields
                textField.stringValue = ""
                importantCheckbox.state = 0
                
                getToDoItems()
            }
        }
    }
    
    @IBAction func DeleteClicked(_ sender: Any) {
        let todoItem = toDoItems[tableView.selectedRow]
        if let context = (NSApplication.shared().delegate as? AppDelegate)?.managedObjectContext {
            context.delete(todoItem)
            (NSApplication.shared().delegate as? AppDelegate)?.saveAction(nil)
            getToDoItems()
            DeleteButton.isHidden = true
        }
    }
    
    // MARK: - TabeVew Stuff
    func numberOfRows(in tableView: NSTableView) -> Int {
        return toDoItems.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let toDoItem = toDoItems[row]
        if tableColumn?.identifier == "ImportantColumn" {
            // Important
            if let cell = tableView.make(withIdentifier: "ImportantCell", owner: self) as? NSTableCellView {
                
                if toDoItem.important {
                    cell.textField?.stringValue = "❗️"
                } else {
                    cell.textField?.stringValue = ""
                }
                
                return cell
            }
        } else {
            // ToDo List
            if let cell = tableView.make(withIdentifier: "todoItems", owner: self) as? NSTableCellView {
                
                cell.textField?.stringValue = toDoItem.name!
                
                return cell
            }
        }
        return nil
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        DeleteButton.isHidden = false
    }
    
}

