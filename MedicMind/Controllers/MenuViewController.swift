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
        
        if(!dataManager.loaded)
        {
            dataManager.load()
        }
        if let menu = dataManager.currentPage
        {
            if menu is Menu
            {
                currentMenu = (menu as! Menu)

                for item in currentMenu!.items
                {
                    itemArray.append(item.title)
                }
            }
        }
        else
        {
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
        cell.textLabel?.font = UIFont(name: DataManager.instance.boldFontName, size: CGFloat(DataManager.instance.fontSize))
        cell.textLabel?.text = itemArray[indexPath.row]
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.numberOfLines = 0
        
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
            
            /*if((dataManager.currentPage as! PageLinkTarget).target_type == .drug_monograph)
            {
                let viewController = storyboard!.instantiateViewController(withIdentifier: "DrugMonographViewController") as! DrugMonographViewController
                viewController.drugData = DataManager.instance.drugByKey(key: (dataManager.currentPage as? PageLinkTarget)!.target)
                if(viewController.drugData != nil)
                {
                    navController!.pushViewController(viewController, animated: true)
                }
                else
                {
                    print("Could not load the drug monograph")
                }
            }
            else if((dataManager.currentPage as! PageLinkTarget).target_type == .document)
            {
                let viewController = storyboard!.instantiateViewController(withIdentifier: "DrugMonographViewController") as! DrugMonographViewController
                let pageData = DataManager.instance.pageByKey(key: (dataManager.currentPage as? PageLinkTarget)!.target)
                if(pageData != nil)
                {
                    print("Found page data")
                    //navController!.pushViewController(viewController, animated: true)
                }
                else
                {
                    print("Could not load the document")
                }
            } else*/
            if(dataManager.currentPage?.type == .tool)
            {
                let viewController = storyboard!.instantiateViewController(withIdentifier: dataManager.currentPage!.key)
                
                navController!.pushViewController(viewController, animated: true)
            }
        }
    
        dataManager.currentPage = currentMenu!.items[indexPath.row]
        
        if(dataManager.currentPage?.type == .document)
        {
            let viewController = storyboard!.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            viewController.target = dataManager.currentPage!.key
            
            navController!.pushViewController(viewController, animated: true)
            
        }
        else if(dataManager.currentPage?.type == .directive)
        {
            let viewController = storyboard!.instantiateViewController(withIdentifier: "MedicalDirectiveViewController") as! MedicalDirectiveViewController
            
            viewController.currentDirective = DataManager.instance.pageByKey(key: dataManager.currentPage!.key) as? MedicalDirective
            
            if(viewController.currentDirective != nil)
            {
                if( viewController.currentDirective?.flowchartkeys.isEmpty == false )
                {
                    var viewControllersArray : [UIViewController] = []
                    viewControllersArray.append(viewController)
                    
                    let tabController = storyboard!.instantiateViewController(withIdentifier: "ContentPageTabBarController") as! ContentPageTabBarController
                    
                    viewController.tabBarItem = UITabBarItem(title: "Directive", image: UIImage(systemName: "book.fill"), tag: 1)
            
            
                    for flowchartKey in viewController.currentDirective!.flowchartkeys
                    {
                        
                        let flowchartController = storyboard!.instantiateViewController(withIdentifier: "DirectiveFlowChartViewController") as! DirectiveFlowChartViewController
                        flowchartController.imageName = flowchartKey[1]
                        flowchartController.tabBarItem = UITabBarItem(title: flowchartKey[0], image: UIImage(systemName: "flowchart.fill"), tag: 1)
                        
                        viewControllersArray.append(flowchartController)
                    }
                    tabController.viewControllers = viewControllersArray
                    navController!.pushViewController(tabController, animated: true)
                }
                else
                {
                    navController!.pushViewController(viewController, animated: true)
                }
                
            }
            else
            {
                print("Could not load the medical directive")
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}