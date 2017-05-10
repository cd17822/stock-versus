//
//  NoUserViewController.swift
//  StockVersus
//
//  Created by Charlie DiGiovanna on 5/10/17.
//  Copyright © 2017 Charlie DiGiovanna. All rights reserved.
//

import UIKit

class NoUserViewController: UIViewController {
    @IBOutlet weak var name_field: UITextField!
    @IBOutlet weak var username_field: UITextField!
    @IBOutlet weak var password_field: UITextField!
    @IBOutlet weak var confirm_button: UIButton!

    var first_time_for_name = true
    var first_time_for_username = true
    var first_time_for_password = true

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.init(patternImage: #imageLiteral(resourceName: "bg"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func checkForConfirmability() {
        confirm_button.isHidden = name_field.text == nil || username_field.text == nil || password_field.text == nil || first_time_for_name || first_time_for_username || first_time_for_password
    }

    @IBAction func nameEditingChanged(_ sender: Any) {
        checkForConfirmability()
    }

    @IBAction func usernameEditingChanged(_ sender: Any) {
        checkForConfirmability()
    }

    @IBAction func passwordEditingChanged(_ sender: Any) {
        checkForConfirmability()
    }

    @IBAction func nameEditingDidBegin(_ sender: Any) {
        if first_time_for_name {
            name_field.alpha = 1
            name_field.text = ""
            first_time_for_name = false
        }
    }

    @IBAction func usernameEditingDidBegin(_ sender: Any) {
        if first_time_for_username {
            username_field.alpha = 1
            username_field.text = ""
            first_time_for_username = false
        }
    }

    @IBAction func passwordEditingDidBegin(_ sender: Any) {
        if first_time_for_password {
            password_field.alpha = 1
            password_field.text = ""
            password_field.isSecureTextEntry = true
            first_time_for_password = false
        }
    }

    @IBAction func confirmButtonTapped(_ sender: Any) {
        NetworkHandler.createUser(name: name_field.text!, username: username_field.text!, password: password_field.text!) { user, err in
            if err != nil {
                print(err!)
                return
            }

            print("USER: \(user!)")
            self.dismiss(animated: true, completion: nil)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
