//
//  ViewController.swift
//  Chatting
//
//  Created by Shuhui Qu on 4/23/15.
//  Copyright (c) 2015 Shuhui Qu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var currentUser: PFUser!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func SignUpClicked(sender: AnyObject) {
        var user = PFUser()
        user.username = userTextField.text
        user.password = passwordTextField.text
//        user.email = "email@example.com"
        // other fields can be set just like with PFObject
//        user["phone"] = "415-392-0202"
        
        user.signUpInBackgroundWithBlock { (succeeded: Bool, error: NSError?) -> Void in
            if error == nil {
                // Hooray! Let them use the app now.
                self.currentUser = user
                self.performSegueWithIdentifier("loginSegue", sender: self)
            }
        }
        
    }
    
    @IBAction func SignInClicked(sender: UIButton){
        PFUser.logInWithUsernameInBackground(userTextField.text, password:passwordTextField.text) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                // Do stuff after successful login.
                self.currentUser = user!
                self.performSegueWithIdentifier("loginSegue", sender: self)
            } else {
                // The login failed. Check error to see why.
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let filtersNC = segue.destinationViewController as! UINavigationController
        let filtersVC = filtersNC.viewControllers[0] as! ChatViewController
        filtersVC.currentUser = currentUser
    }
}

