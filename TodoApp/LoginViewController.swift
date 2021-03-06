//
//  LoginViewController.swift
//  TodoApp
//
//  Created by Brandon on 2016-06-18.
//  Copyright © 2016 RBSoftware. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import CoreGraphics
import SkyFloatingLabelTextField

class LoginViewController : UIViewController, UITextFieldDelegate
{
    
    @IBOutlet var usernameTextBox: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet var passwordTextBox: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var errorMessage: UILabel!
    
    @IBOutlet var loginButton: UIButton!
    
    @IBOutlet var registerButton: UIButton!
    
    @IBOutlet var titleLabel: UILabel!
    
    
    var api: TodoAPI = TodoAPI()
    
    let accentColor = UIColor(red:0.31, green:0.46, blue:0.46, alpha:1.00)
    
    let darkerAccent = UIColor(red:0.01, green:0.14, blue:0.20, alpha:1.00)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Login screen loaded.")
        
        // adding bg
        let bg = UIImageView(image: UIImage(named: "login-bg2"))
        bg.frame = self.view.frame
        self.view.insertSubview(bg, atIndex: 0)
        
        // adding dim above bg since it's too bright
        let dim = UIView(frame: self.view.frame)
        dim.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        self.view.insertSubview(dim, aboveSubview: bg)
        
        // setting up title label
        titleLabel.font = UIFont(name: "FontAwesome", size: 110)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.text = "\u{f00c}"
        
        // setting this view controller as textField delegate
        usernameTextBox.delegate = self
        passwordTextBox.delegate = self
        
        // setting username textField attributes
        usernameTextBox.placeholder = "Username"
        usernameTextBox.title = "Username"
        usernameTextBox.textColor = UIColor.whiteColor()
        usernameTextBox.placeholderColor = UIColor.whiteColor()
        usernameTextBox.backgroundColor = UIColor.clearColor()
        usernameTextBox.selectedLineColor = UIColor.whiteColor()
        usernameTextBox.selectedTitleColor = UIColor.whiteColor()
        usernameTextBox.tintColor = UIColor.whiteColor()
        usernameTextBox.lineColor = UIColor.whiteColor()
        usernameTextBox.titleColor = UIColor.whiteColor()
        usernameTextBox.iconFont = UIFont(name: "FontAwesome", size: 13)
        usernameTextBox.iconText = "\u{f007}"
        usernameTextBox.iconColor = UIColor.whiteColor()
        usernameTextBox.selectedIconColor = UIColor.whiteColor()
        
        // setting password textField attributes
        passwordTextBox.placeholder = "Password"
        passwordTextBox.title = "Password"
        passwordTextBox.textColor = UIColor.whiteColor()
        passwordTextBox.placeholderColor = UIColor.whiteColor()
        passwordTextBox.backgroundColor = UIColor.clearColor()
        passwordTextBox.selectedLineColor = UIColor.whiteColor()
        passwordTextBox.selectedTitleColor = UIColor.whiteColor()
        passwordTextBox.tintColor = UIColor.whiteColor()
        passwordTextBox.lineColor = UIColor.whiteColor()
        passwordTextBox.titleColor = UIColor.whiteColor()
        passwordTextBox.iconFont = UIFont(name: "FontAwesome", size: 13)
        passwordTextBox.iconText = "\u{f023}"
        passwordTextBox.iconColor = UIColor.whiteColor()
        passwordTextBox.selectedIconColor = UIColor.whiteColor()
        
        // setting error label attributes
        errorMessage.textColor = UIColor.whiteColor()
        
        // setting login button attributes
        loginButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        loginButton.backgroundColor = UIColor.clearColor()
        loginButton.layer.borderWidth = 2.0
        loginButton.layer.cornerRadius = 20.0
        loginButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        
        // setting register button attributes
        registerButton.setTitleColor(UIColor(red:0.23, green:0.60, blue:0.85, alpha:1.00), forState: UIControlState.Normal)
        registerButton.setTitleColor(UIColor(red:0.23, green:0.60, blue:0.85, alpha:1.00), forState: UIControlState.Highlighted)
        registerButton.backgroundColor = UIColor.clearColor()
        

        
        // looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // dismiss keyboard
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    // function gets called whenever the 'next' key is pressed on keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if(textField == usernameTextBox){
            passwordTextBox.becomeFirstResponder()
        }else if(textField == passwordTextBox){
            loginAttempt(self)
        }
        return true
    }
    
    //whenever the a textfield is being edited
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if let skyFloatingLabelTextField = textField as? SkyFloatingLabelTextField {
            skyFloatingLabelTextField.errorMessage = ""
        }
        return true
    }
    
    @IBAction func loginAttempt(sender: AnyObject) {
        
        dismissKeyboard()
        
        let user = self.usernameTextBox.text!
        let pssd = self.passwordTextBox.text!
        
        if(user == ""){
            usernameTextBox.errorColor = UIColor.redColor()
            usernameTextBox.errorMessage = "Missing Username"
            return
        }
        
        if(pssd == ""){
            passwordTextBox.errorColor = UIColor.redColor()
            passwordTextBox.errorMessage = "Missing Password"
            return
        }
        
        self.api.attemptLogin(user, password: pssd, completion: { (response: JSON) in
            
            print(response)
            
            self.errorMessage.text = "Attempting to log in..."
            
            if(response["status"] == 200) {
                self.displayError("Login successful!")
                let storyboard = UIStoryboard(name: "TodoList", bundle: nil)
                let vc = storyboard.instantiateInitialViewController()! as UIViewController
                self.presentViewController(vc, animated: true, completion: nil)
            }else{
                self.displayError(String(response["reason"]))
            }
            
        })
        
    }
    
    // called everytime view is back in view
    func displayingView(){
        usernameTextBox.errorMessage = ""
        passwordTextBox.errorMessage = ""
        usernameTextBox.text = ""
        passwordTextBox.text = ""
    }
    
    @IBAction func registerButtonClicked(sender: AnyObject) {
        let parentViewController = self.parentViewController as? StartupViewController
        parentViewController?.switchToRegister()
    }
    
    func displayError(msg: String){
        self.errorMessage.text = msg
        UIView.animateWithDuration(1.0, animations: {
            self.errorMessage.alpha = 1.0
            
            UIView.animateWithDuration(1.0, delay: 2.0, options: .CurveEaseIn, animations: {
                self.errorMessage.alpha = 0.0
                }, completion: nil)
        })
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
}




