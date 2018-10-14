//
//  AppDelegate.swift
//  TigerEvent
//
//  Created by SiyangLiu on 2018/10/12.
//  Copyright © 2018 SiyangLiu. All rights reserved.
//

import UIKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?

    // MS
//    func application(_ app: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        if url.scheme == "tigerevent" {
//            let service = OutlookService.shared()
//            service.handleOAuthCallback(url: url)
//            return true
//        }
//        else {
//            return false
//        }
//    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Logout MS
        let service = OutlookService.shared()
        if (service.isLoggedIn) {
            // Logout
            service.logout()
            let userDefaults = UserDefaults.standard
            userDefaults.removeObject(forKey: "MSToken")
            userDefaults.synchronize()
        }
        
        // Google
        GIDSignIn.sharedInstance().clientID = "483455703032-87b1g717lq452nbc6isq60np79pmmn2j.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        return true
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            _ = user.userID                  // For client-side use only!
            _ = user.authentication.idToken // Safe to send to the server
            _ = user.profile.name
            _ = user.profile.givenName
            _ = user.profile.familyName
            _ = user.profile.email
            // ...
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme == "tigerevent" {
            let service = OutlookService.shared()
            service.handleOAuthCallback(url: url)
            return true
        }
        
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
    

}

