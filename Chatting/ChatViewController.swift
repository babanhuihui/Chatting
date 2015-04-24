//
//  ChatViewController.swift
//  Chatting
//
//  Created by Shuhui Qu on 4/24/15.
//  Copyright (c) 2015 Shuhui Qu. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contactField: UITextField!
    
    var messages = [PFObject]()
    var currentUser: PFUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.automaticallyAdjustsScrollViewInsets = false;
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70
        NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "onTimer", userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func SendMessage(sender: UIButton) {
        var message = PFObject(className:"message")
        message["text"] = messageField.text
        message["from"] = currentUser.username
        message["to"] = contactField.text
        println(message["to"]!)
        message.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                self.messageField.text = ""
                self.onTimer()
                // update the tableview
            } else {
                // There was a problem, check error.description
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MCell") as! MessageCell
//        print indexPath.row
        var message = messages[indexPath.row]
        cell.messageLabel.text = message["text"] as? String
        cell.fromLabel.text = message["from"] as? String
        cell.toLabel.text = message["to"] as? String
//        cell.fromLabel.text = currentUser.username
        return cell
        
    }

    @IBAction func SignOut(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func onTimer() {
        // Add code to be run periodically
        var query = PFQuery(className:"message")
        query.whereKey("to", equalTo:"\(self.currentUser.username!)")
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil{
                self.messages = objects as! [PFObject]
                self.tableView.reloadData()
            }else{
//                println("Error: \(error) \(error.userInfo!)")
            }
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
