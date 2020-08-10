//
//  DrugMenuTableViewController.swift
//  Ornge
//
//  Created by Charles Trickey on 2019-10-21.
//  Copyright © 2019 Charles Trickey. All rights reserved.
//

import UIKit

class DrugMenuTableViewController: UITableViewController {

    var navController : UINavigationController?
    
    var drugArray : [Drug] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        for drug in DataManager.instance.drugData {
            if(drug.content.count > 1) {
                drugArray.append(drug)
            }
        }
        navController = UIApplication.shared.windows[0].rootViewController as? UINavigationController
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drugArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "drugMenuCell", for: indexPath)
        cell.textLabel!.text = drugArray[indexPath.row].name
        cell.textLabel!.numberOfLines = 0
        cell.textLabel!.lineBreakMode = .byWordWrapping
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = storyboard!.instantiateViewController(withIdentifier: "DrugTabViewController") as! DrugTabViewController
        viewController.drugData = drugArray[indexPath.row]
        viewController.loadSubviews()
        navController!.pushViewController(viewController, animated: true)
    }
}
