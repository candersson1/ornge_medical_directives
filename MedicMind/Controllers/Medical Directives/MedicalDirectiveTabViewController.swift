//
//  MedicalDirectiveTabViewController.swift
//  Ornge
//
//  Created by Charles Trickey on 2020-03-09.
//  Copyright © 2020 Charles Trickey. All rights reserved.
//

import Foundation
import UIKit

class MedicalDirectiveTabViewController : ContentPageTabBarController {
    
    var directive : MedicalDirective?
    
    func loadSubviews()
    {
        let viewController = storyboard!.instantiateViewController(withIdentifier: "MedicalDirectiveViewController") as! MedicalDirectiveViewController
        
        viewController.currentDirective = directive
        
        if(viewController.currentDirective != nil)
        {
            var viewControllersArray : [UIViewController] = [viewController]
            viewController.tabBarItem = UITabBarItem(title: "Directive", image: UIImage(systemName: "book.fill"), tag: 1)
            if( viewController.currentDirective?.flowchartkeys.isEmpty == false )
            {
                for flowchartKey in viewController.currentDirective!.flowchartkeys
                {
                    
                    let flowchartController = storyboard!.instantiateViewController(withIdentifier: "DirectiveFlowChartViewController") as! DirectiveFlowChartViewController
                    flowchartController.imageName = flowchartKey[1]
                    flowchartController.tabBarItem = UITabBarItem(title: flowchartKey[0], image: UIImage(systemName: "flowchart.fill"), tag: 1)
                    
                    viewControllersArray.append(flowchartController)
                }
            }
            self.viewControllers = viewControllersArray
        }
    }
    
    static func loadViewControllerWithData(data : MedicalDirective)
    {
        let navController = UIApplication.shared.windows[0].rootViewController as? UINavigationController
        let storyboard = navController?.storyboard

        let viewController = storyboard!.instantiateViewController(withIdentifier: "MedicalDirectiveTabViewController") as! MedicalDirectiveTabViewController
        viewController.navigationItem.title = data.title
        viewController.directive = data
        viewController.loadSubviews()
        navController!.pushViewController(viewController, animated: true)
    
    }
    
    static func loadViewControllerWithKey(key : String)
    {
        let navController = UIApplication.shared.windows[0].rootViewController as? UINavigationController
        let storyboard = navController?.storyboard

        let data = DataManager.instance.documentByKey(key: key)
        if(data == nil)
        {
            return
        }
        
        if let directive = data as? MedicalDirective
        {
            let viewController = storyboard!.instantiateViewController(withIdentifier: "MedicalDirectiveTabViewController") as! MedicalDirectiveTabViewController
            viewController.navigationItem.title = directive.title
            viewController.directive = directive
            viewController.loadSubviews()
            navController!.pushViewController(viewController, animated: true)
        }
    }
}
