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
        
        //check to see if we have a menu already, otherwise set it to the root menu
        if currentMenu == nil {
            if !DataManager.instance.menuData.isEmpty {
                if let rootMenu = DataManager.instance.menuData[0] as? Menu {
                    currentMenu = rootMenu
                } else {
                    print("Could not assign root menu")
                    return
                }
            } else {
                print("Menu data is empty")
                return
            }
        }
        
        for item in currentMenu!.items {
            itemArray.append(item.title)
        }
        navController = UIApplication.shared.windows[0].rootViewController as? UINavigationController
        if(navController?.viewControllers.count == 1)
        {
                setupNavigationBar();
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //setupNavigationBar()
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
        cell.textLabel?.font = UIFont.systemFont(ofSize: CGFloat(DataManager.instance.fontSize + 2))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count;
    }
    
    //MARK - Tableview delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let nextMenu = currentMenu!.items[indexPath.row] as? Menu
        {
            let viewController = storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
            viewController.currentMenu = nextMenu
            
            if(viewController.currentMenu != nil) {
                navController!.pushViewController(viewController, animated: true)
            }
            else {
                print("Could not load the menu")
            }
        }
        else if let documentLink = currentMenu!.items[indexPath.row] as? MenuDocumentLink
        {
            if let document = DataManager.instance.documentByKey(key: documentLink.key) {
                switch document.type {
                case .directive:
                    if let directive = document as? MedicalDirective {
                        MedicalDirectiveTabViewController.loadViewControllerWithData(data: directive)
                    } else {
                        print("Could not load medical directive, not a valid directive")
                    }
                    break
                case .webview:
                    let viewController = storyboard!.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
                    viewController.target = documentLink.key
                    navController!.pushViewController(viewController, animated: true)
                    break
                case .tool:
                    let viewController = storyboard!.instantiateViewController(withIdentifier: documentLink.key)
                    navController!.pushViewController(viewController, animated: true)
                case .dep_document:
                    if let dep_document = document as? dep_Document {
                        print("Loading deprecated view controller DocumentTableViewController, this will be removed in the future")
                        let viewController = storyboard!.instantiateViewController(withIdentifier: "DocumentTableViewController") as! DocumentTableViewController
                        viewController.document = dep_document
                        navController!.pushViewController(viewController, animated: true)
                    } else {
                        print("Could not load deprecated view controller DocumentTableViewController")
                    }
                default:
                    break
                }
            }
        }
            
        /*if(dataManager.currentPage?.type == .document)
        {
            DocumentViewController.loadViewControllerWithKey(key: dataManager.currentPage!.key)
            
        }*/
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
