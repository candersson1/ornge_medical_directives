//
//  DrugTabViewController.swift
//  Ornge
//
//  Created by Charles Trickey on 2020-03-09.
//  Copyright © 2020 Charles Trickey. All rights reserved.
//

import Foundation
import UIKit

class DrugTabViewController : ContentPageTabBarController
{
    var drugData : Drug?
    
    override func viewDidLoad() {
        
    }
    
    func loadSubviews() {
        if(drugData != nil) {
            let viewController = storyboard!.instantiateViewController(withIdentifier: "DrugMonographViewController") as! DrugMonographViewController
            viewController.drugData = drugData!

            var viewControllersArray : [UIViewController] = []
            viewControllersArray.append(viewController)
            
            if(viewController.drugData!.y_site.count > 0) {
                let ySiteViewController = storyboard!.instantiateViewController(identifier: "y_site") as! YSiteCompatibilityViewController
                ySiteViewController.initialField = viewController.drugData!
                ySiteViewController.tabBarItem = UITabBarItem(title: "Y Site Compatibility", image: UIImage(systemName: "arrow.merge"), tag: 1)
                viewControllersArray.append(ySiteViewController)
            }
            
            if( viewController.drugData?.drug_tables.isEmpty == false )
            {
                let drugTableViewController = storyboard!.instantiateViewController(withIdentifier: "DrugTableViewController") as! DrugTableViewController
                drugTableViewController.drugData = viewController.drugData
                drugTableViewController.tabBarItem = UITabBarItem(title: "Infusion Table", image: UIImage(systemName: "square.grid.4x3.fill"), tag: 1)
                viewControllersArray.append(drugTableViewController)
            }
            
            viewController.tabBarItem = UITabBarItem(title: "Monograph", image: UIImage(systemName: "book.fill"), tag: 1)
                
            self.viewControllers = viewControllersArray
            
        }
    }
}
