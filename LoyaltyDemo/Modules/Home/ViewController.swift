//
//  ViewController.swift
//  LoyaltyExample
//
//  Created by Huy on 05/04/2021.
//

import UIKit
import TekCoreService
import Janus
import JanusGoogle
import Apollo
import Toast_Swift
import TerraInstancesManager
import LoyaltyComponent
import LoyaltyUI
import LoyaltyCore
import LoyaltyModel

class ViewController: UIViewController {
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var versionLabel: UILabel!
    
    var networkConfig: NetworkConfigResult?
    var memberInfo: MemberInfo?
    
    var controller: LoyaltyRedeemPointController?
    var controller2: LoyaltyRedeemPointController?
    
    var cardController: MemberCardControllerProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        appName = terraAppName
        
        if TerraAuth.getInstance(by: AppDelegate.shared.terraApp)?.isAuthorized ?? false {
            btnLogin.setTitle("Đăng xuất", for: .normal)
            btnLogin.backgroundColor = .lightGray
        } else {
            btnLogin.setTitle("Đăng nhập", for: .normal)
            btnLogin.backgroundColor = .systemBlue
        }
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionLabel.text = "Version \(version)"
        }
    }
    
    @IBAction func phoneWasTapped(_ sender: Any) {
        let phone = PhoneVerifyViewController.instantiateFromNib()
        phone.appName = appName
        navigationController?.pushViewController(phone, animated: true)
    }
    
    @IBAction func cardWasTapped(_ sender: Any) {
        let card = CardViewController.instantiateFromNib()
        card.appName = appName
        navigationController?.pushViewController(card, animated: true)
    }
    
    @IBAction func redeemWasTapped(_ sender: Any) {
        let redeem = RedeemViewController.instantiateFromNib()
        redeem.appName = appName
        navigationController?.pushViewController(redeem, animated: true)
    }

    @IBAction func viewHistoryButtonWasTapped(_ sender: Any) {
        let vc = LoyaltyHistoryViewController()
        vc.terraApp = AppDelegate.shared.terraApp!
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func registerWasTapped(_ sender: Any) {
        let vc = RegisterViewController.instantiateFromNib()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func loginFacebookWasTapped(_ sender: Any) {
        if TerraAuth.getInstance(by: AppDelegate.shared.terraApp)?.isAuthorized ?? false {
            btnLogin.setTitle("Đăng nhập", for: .normal)
            btnLogin.backgroundColor = .systemBlue
            TerraAuth.getInstance(by: terraAppName)?.logout()
        } else {
            TerraAuth.getInstance(by: terraAppName)?.registerGoogle()
            TerraAuth.getInstance(by: terraAppName)?.loginWithGoogle(presentViewController: self, delegate: self)
        }
        
        
    }
    
    @IBAction func viewMemberButtonWasTapped(_ sender: Any) {
        loyaltyApp?.getMemberInfo { [weak self] result in
            switch result {
            case .success(let response):
                self?.alertMessage(title: "Get member info", message: String(describing: response.result?.member?.dictValue))
            case .failure(let error):
                self?.alertMessage(title: "Get memeber info", message: String(describing: error))
            }
        }
    }
    
    func alertJson(title: String, member: MemberInfo) {
        let message = String(data: try! JSONEncoder().encode(member), encoding: .utf8)!
        alertMessage(title: title, message: message)
    }
    
    func alertMessage(title: String, message: String) {
        let alert = ApolloAlertConfirmation(title: title, message: message , actions: [
            AlertAction(title: "OK", type: .primary)
        ])
        present(alert, animated: true)
    }
    
    @IBAction func faqButtonWasTapped(_ sender: Any) {
        loyaltyApp?.getNetworkConfig { [weak self] result in
            switch result {
            case .success(let response):
                if let url = response.result?.networkConfig?.faqWebUrl {
                    let vc = SingleWebViewController(url: url)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                self?.alertMessage(title: "FAQ", message: String(describing: error))
            }
        }
    }
    
    @IBAction func myMembershipWasTapped(_ sender: Any) {
//        TerraLoyaltyConsumerUI.openMembership(self, terraApp: AppDelegate.shared.terraApp!)
    }
}

extension ViewController: JanusLoginDelegate {
    
    func janusWillGetAuthCredential() {
        
    }
    
    func janusHasLoginSuccess(authCredential: JanusAuthCredential) {
        btnLogin.setTitle("Đăng xuất", for: .normal)
        btnLogin.backgroundColor = .lightGray
        
        controller?.reload()
    }
    
    func janusHasLoginFail(error: JanusError?) {
      
    }
    
}
