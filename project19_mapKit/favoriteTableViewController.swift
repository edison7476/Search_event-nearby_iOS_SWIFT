//
//  favoriteTableViewController.swift
//  project19_mapKit
//
//  Created by Jia Wang on 7/26/16.
//  Copyright © 2016 Jia Wang. All rights reserved.
//

import UIKit
import CoreData
class favoriteTableViewController: UITableViewController {

    var savedEvents = [EventTable]()
       var manageObjContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        let request = NSFetchRequest(entityName: "EventTable")
        
        var ac = UIAlertController(title: "Empty Favorite List", message: "You have not saved any event!", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil ))
        do {
            savedEvents = try manageObjContext.executeFetchRequest(request) as! [EventTable]
            if savedEvents.count > 0{
                self.tableView.reloadData()
            }
            else{
                presentViewController(ac, animated: true, completion: nil)
            }
        }
        catch let error as NSError{
            ac = UIAlertController(title: "Empty Favorite List", message: "\(error)", preferredStyle: .Alert)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return savedEvents.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("favCell", forIndexPath: indexPath)

        cell.textLabel?.text = savedEvents[indexPath.row].title

        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // removing the cell from CoreData
        manageObjContext.deleteObject(savedEvents[indexPath.row])
        savedEvents.removeAtIndex(indexPath.row)
        // Delete the row from the data source
        
        do{
            try manageObjContext.save()
            
        }
        catch{
            
        }
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
