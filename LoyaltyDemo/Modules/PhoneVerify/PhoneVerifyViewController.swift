//
//  PhoneVerifyViewController.swift
//  LoyaltyExample
//
//  Created by Tung Nguyen on 4/15/21.
//

import UIKit
import TekIdentityService

class PhoneVerifyViewController: UIViewController {

    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var otpField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = false
    }

    @IBAction func sendOtp(_ sender: Any) {
        TerraIdentity.getInstance(by: AppDelegate.shared.terraApp)?
            .verify(.phone(value: phoneField.text!), completion: { (type, success, _) in
                print(success)
            })
    }
    
    @IBAction func verify(_ sender: Any) {
        TerraIdentity.getInstance(by: AppDelegate.shared.terraApp)?
            .update(.phone(value: phoneField.text!), otp: otpField.text!, completion: { (type, success, _) in
                print(success)
            })
    }
    
}
