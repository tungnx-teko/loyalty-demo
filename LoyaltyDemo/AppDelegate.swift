//
//  AppDelegate.swift
//  LoyaltyExample
//
//  Created by Huy on 05/04/2021.
//

import UIKit
import Terra
import TerraInstancesManager
import ApolloTheme
import Janus
import IQKeyboardManagerSwift
import LoyaltyCore
import TekIdentityService
import GoogleSignIn
import JanusGoogle

let terraAppName = "loyalty_example"
var loyaltyApp: Loyalty?

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var terraApp: ITerraApp!
    
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        
        window = UIWindow(frame: UIScreen.main.bounds)
        buildRoot()
        
        TerraApp.configure(appName: terraAppName) { (isSuccess, terraApp) in
            self.terraApp = terraApp
            UserDefaults.standard.setValue(terraApp.bus.id, forKey: "vn.teko.terra.bus.app-host")
            TerraTheme.configureWith(app: terraApp)
            TerraAuth.configureWith(app: terraApp)
            TerraLoyalty.configureWith(app: terraApp)
            
            loyaltyApp = TerraLoyalty.getInstance(by: terraApp)
            self.moveToHome()
        }
        return true
    }
    
    func moveToHome() {
        guard let home = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() else { return }
        home.navigationController?.isNavigationBarHidden = true
        window?.rootViewController = home
        window?.makeKeyAndVisible()
    }
    
    func buildRoot() {
        let splash = SplashViewController.instantiateFromNib()
        window?.rootViewController = splash
        window?.makeKeyAndVisible()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return TerraAuth.handleGoogleURL(app, open: url, options: options)
    }
    
}

