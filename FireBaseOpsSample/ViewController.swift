//
//  ViewController.swift
//  FireBaseOpsSample
//
//  Created by Tauseef Kamal on 3/6/17.
//  Copyright © 2017 tauk. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ViewController: UIViewController {

    @IBOutlet weak var tfUserName: UITextField!
    
    @IBOutlet weak var tfEmail: UITextField!
    
    @IBOutlet weak var lblData: UILabel!
    
    @IBAction func findUser(_ sender: Any) {
        let userName = tfUserName.text
        
        //get the reference to the database
        let ref = FIRDatabase.database().reference()
        
        //using the database ref get the reference to userName which is the child of the users child
        let userNameRef = ref.child("users").child(userName!)
        
        userNameRef.observeSingleEvent(of: .value, with: {
            (snapshot) in
            if (snapshot.exists()) {
                let snapshotValue = snapshot.value as! Dictionary<String, String>
                
                //from the snapshotValue take out the email and display in the text box
                self.tfEmail.text = snapshotValue["email"]
            }
            else {
                self.showAlert(titleText: "User Not Found!", messageText: "Cannot find user \(userName!)")
            }
        })
        
    }
    
    @IBAction func showAllUsers(_ sender: Any) {
        //get the database reference to child "users"
        let usersRef = FIRDatabase.database().reference().child("users")
        
        var data = ""
        
        usersRef.observe(.childAdded, with: {
            (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String, String>

            //from the snapshotValue take out the email and display in the text box
            let userName = snapshotValue["username"]
            let email = snapshotValue["email"]
            
            data.append("\(userName!) \(email!)")
            data.append("\n")
            
            //display in the label
            self.lblData.text = data
        })
    }
    
    @IBAction func addUser(_ sender: Any) {
        let userName = tfUserName.text
        let email = tfEmail.text
        
        //get the reference to the database
        let ref = FIRDatabase.database().reference()
        
        //get a reference all the way to the user name to check if that user name already exists
        let userNameRef = ref.child("users").child(userName!)
        
        
        userNameRef.observeSingleEvent(of: .value, with: {
            (snapshot) in  
            
            if(snapshot.exists()) {
                self.showAlert(titleText: "Error!", messageText: "Username \(userName!) already exists")
                return
            }
        })
        
        //add a new user to the users child using the setValue() method
        userNameRef.setValue(["username":userName, "email":email])
        
        print("New user added!")
        
    }
    
    @IBAction func updateEmail(_ sender: Any) {
        let userName = tfUserName.text
        let email = tfEmail.text
        
        
        let ref = FIRDatabase.database().reference()
        
        //update the child of the child node using updateChildValues()
        ref.child("users").child(userName!).updateChildValues(["username":userName!, "email":email!])
        
        print("update done!")
    }
    
    @IBAction func deleteUser(_ sender: Any) {
        let userName = tfUserName.text
        
        //get a reference to the database
        let ref = FIRDatabase.database().reference()
        
        //delete the child node for the user by using  the removeValue() method
        ref.child("users").child(userName!).removeValue()
        
        print("delete done!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //reusable method to show alert box
    private func showAlert(titleText:String, messageText:String) {
        let errorAlert = UIAlertController(title: titleText, message:messageText,
                                           preferredStyle: UIAlertControllerStyle.alert)
        
        //add a button to the alert message with title OK
        errorAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        //display the error message
        self.present(errorAlert, animated: true, completion: nil)
    }
}

