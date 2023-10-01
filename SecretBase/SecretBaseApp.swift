//
//  SecretBaseApp.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/05.
//

import SwiftUI
import FirebaseCore
import FirebaseAuthUI
import FirebaseEmailAuthUI


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        return true
    }
    // MARK: URL Schemes
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }
}
    
    
    
@main
struct SecretBaseApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .accentColor(Color("MainColor2")) 
        }
    }
}
    
    
    
    
//    @StateObject private var firebaseInitializer = FirebaseInitializer()
//
//    var body: some Scene {
//        WindowGroup {
//            if !firebaseInitializer.isInitialized {
//                LoadingView()
//            } else if firebaseInitializer.isSignedIn {
//                ContentView()
//            } else {
//                SignInView()
//            }
//        }
//    }
//}
//
//class FirebaseInitializer: ObservableObject {
//    @Published var isInitialized: Bool = false
//    @Published var isSignedIn: Bool = false
//
//    init() {
//        isInitialized = true
//        isSignedIn = Auth.auth().currentUser != nil
//    }
//}
