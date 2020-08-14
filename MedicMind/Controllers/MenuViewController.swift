//
//  ViewController.swift
//  MedicMind
//
//  Created by Charles Trickey on 2019-05-09.
//  Copyright © 2019 Charles Trickey. All rights reserved.
//

import UIKit
import CoreData

class MainMenuCell : UITableViewCell
{
    
}

class MenuViewController: UITableViewController
{
    var itemArray : [String] = []
    var navController : UINavigationController?
    var currentMenu : Menu?
    var dataManager = DataManager.instance
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(DataManager.instance.waiverComplete == false) {
            if let viewController = storyboard?.instantiateViewController(withIdentifier: "DisclaimerViewController") {
                self.present(viewController, animated: true, completion: nil)
            }
        }
        
        if(!dataManager.loaded) {
            dataManager.load()
        }
        if let menu = dataManager.currentPage {
            if menu is Menu
            {
                currentMenu = (menu as! Menu)

                for item in currentMenu!.items
                {
                    itemArray.append(item.title)
                }
            }
        }
        else {
            print("Could not load page, not a valid menu")
        }
        
        navController = UIApplication.shared.windows[0].rootViewController as? UINavigationController
    }
    
    override func viewDidAppear(_ animated : Bool) {
        super.viewDidAppear(true)
    }

    //MARK - Tableview Data Source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = .systemFont(ofSize: 15)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count;
    }
    
    //MARK - Tableview delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if(currentMenu!.items[indexPath.row] is Menu)
        {
            dataManager.currentPage = currentMenu!.items[indexPath.row]
            
            let viewController = storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
            viewController.currentMenu = dataManager.currentPage as? Menu
            
            if(viewController.currentMenu != nil) {
                navController!.pushViewController(viewController, animated: true)
            }
            else {
                print("Could not load the menu")
            }
        }
        else
        {
            dataManager.currentPage = currentMenu!.items[indexPath.row]
            
            if(dataManager.currentPage?.type == .tool)
            {
                let viewController = storyboard!.instantiateViewController(withIdentifier: dataManager.currentPage!.key)
                
                navController!.pushViewController(viewController, animated: true)
            }
        }
    
        dataManager.currentPage = currentMenu!.items[indexPath.row]
        
        if(dataManager.currentPage?.type == .document)
        {
            let viewController = storyboard!.instantiateViewController(withIdentifier: "DocumentTableViewController") as! DocumentTableViewController
            let pageData = DataManager.instance.pageByKey(key: (dataManager.currentPage!.key))
            if(pageData != nil) {
                if(pageData is Document) {
                    let document = pageData as! Document
                    viewController.document = document
                    navController!.pushViewController(viewController, animated: true)
                }
            }
            else
            {
                print("Could not load the document")
            }
            
        } else if( dataManager.currentPage?.type == .webview) {
            let viewController = storyboard!.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            viewController.target = dataManager.currentPage!.key
            
            navController!.pushViewController(viewController, animated: true)
        }
        else if(dataManager.currentPage?.type == .directive)
        {
            MedicalDirectiveTabViewController.loadViewControllerWithKey(key: dataManager.currentPage!.key)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
