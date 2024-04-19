//
//  BotonDeAyudaIOSApp.swift
//  BotonDeAyudaIOS
//
//  Created by Andres Cabral on 04/04/24.
//

import SwiftUI
import Firebase
import FirebaseCore

@main
struct BotonDeAyudaIOSApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            HomePage()
        }
    }
    
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}
