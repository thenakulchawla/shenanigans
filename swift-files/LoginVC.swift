//
//  LoginController.swift
//  reeal-primitive
//
//  Created by Nakul Chawla on 2/2/20.
//  Copyright © 2020 Nakul Chawla. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        
        loginButton.isEnabled = true
        
        if authRef.currentUser != nil || globalUser.uid == authRef.currentUser?.uid {
            self.performSegue(withIdentifier: "showHome", sender: nil)
        }
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        
        view.addGestureRecognizer(tap)
        
    }
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func loginAction(_ loginButton: UIButton) {

        // TODO : userclass
        authRef.signIn(withEmail: email.text!, password: password.text!) { (authUser, error) in
            if error == nil {
                print("Login Successful. Now checking user auth")
                if (authRef.currentUser?.isEmailVerified)!
                {
                    self.performSegue(withIdentifier: "LogInToVerification", sender: self)
                }
                else
                {
                    globalUser.uid = (authUser?.user.uid)!
                    globalUser.getUser() { (isSuccess) in
                        if (isSuccess) {
                            self.performSegue(withIdentifier: "showHome", sender: self)
                        }
                    }
                }

            } else {
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                
                print("Error in login")
                
            }
        }
    }
        
    // MARK: - Navigation
         
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {}
        
    }