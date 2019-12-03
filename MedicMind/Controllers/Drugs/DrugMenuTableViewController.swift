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

    override func viewDidLoad() {
        super.viewDidLoad()
        navController = UIApplication.shared.windows[0].rootViewController as? UINavigationController
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.instance.drugData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "drugMenuCell", for: indexPath)
        cell.textLabel!.text = DataManager.instance.drugData[indexPath.row].name
        cell.textLabel!.numberOfLines = 0
        cell.textLabel!.lineBreakMode = .byWordWrapping
        // Configure the cell...

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = storyboard!.instantiateViewController(withIdentifier: "DrugMonographViewController") as! DrugMonographViewController
        viewController.drugData = DataManager.instance.drugData[indexPath.row]
        if(viewController.drugData != nil)
        {
            navController!.pushViewController(viewController, animated: true)
        }
        else
        {
            print("Could not load the drug monograph")
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
