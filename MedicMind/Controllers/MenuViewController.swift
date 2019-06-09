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
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated : Bool) {
        /*if(dataManager.currentPage?.color != "")
        {
            navController?.navigationBar.barTintColor = UIColor(hex: dataManager.currentPage!.color)
        }*/
        super.viewDidAppear(true)
        
    }

    //MARK - Tableview Data Source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        //let step = Float(0.05)
        if(currentMenu?.items[indexPath.row].color != "")
        {
            cell.backgroundColor = UIColor(hex: (currentMenu?.items[indexPath.row].color)!)
        }
        else
        {
            if(currentMenu?.color != "")
            {
                let color = UIColor(hex: currentMenu!.color)
                let hsba = color!.hsba
                let step = (CGFloat((indexPath.row))) / (CGFloat(indexPath.count) * 4)
                cell.backgroundColor = UIColor(hue: hsba.h, saturation: hsba.s - (hsba.s * step), brightness: hsba.b + (hsba.b * step), alpha: 1.0)
            }
        }
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
            viewController.title = dataManager.currentPage?.title
            
            if(viewController.currentMenu != nil)
            {
                navController!.pushViewController(viewController, animated: true)
            }
            else
            {
                print("Could not load the menu")
            }
            
        }
        else if(currentMenu!.items[indexPath.row] is MedicalDirective)
        {
            dataManager.currentPage = currentMenu!.items[indexPath.row]
            
            let viewController = storyboard!.instantiateViewController(withIdentifier: "MedicalDirectiveViewController") as! MedicalDirectiveViewController
            viewController.currentDirective = dataManager.currentPage as? MedicalDirective
            viewController.title = dataManager.currentPage?.title
            if(viewController.currentDirective != nil)
            {
                navController!.pushViewController(viewController, animated: true)
            }
            else
            {
                print("Could not load the medical directive")
            }
        }
        else if(currentMenu!.items[indexPath.row] is PageLinkTarget)
        {
            dataManager.currentPage = currentMenu!.items[indexPath.row]
            
            if((dataManager.currentPage as! PageLinkTarget).target_type == .drug_monograph)
            {
                let viewController = storyboard!.instantiateViewController(withIdentifier: "DrugMonographViewController") as! DrugMonographViewController
                viewController.drugData = DataManager.instance.drugByKey(key: (dataManager.currentPage as? PageLinkTarget)!.target)
                viewController.title = dataManager.currentPage?.title
                if(viewController.drugData != nil)
                {
                    navController!.pushViewController(viewController, animated: true)
                }
                else
                {
                    print("Could not load the drug monograph")
                }
            } else if((dataManager.currentPage as! PageLinkTarget).target_type == .directive)
            {
                let viewController = storyboard!.instantiateViewController(withIdentifier: "MedicalDirectiveViewController") as! MedicalDirectiveViewController
                viewController.currentDirective = DataManager.instance.directiveByKey(key: (dataManager.currentPage as? PageLinkTarget)!.target)
                viewController.title = dataManager.currentPage?.title
                if(viewController.currentDirective != nil)
                {
                    navController!.pushViewController(viewController, animated: true)
                }
                else
                {
                    print("Could not load the medical directive")
                }
            }
        }
        //viewController.currentMenu = itemArray[indexPath.row].target as? Menu
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
