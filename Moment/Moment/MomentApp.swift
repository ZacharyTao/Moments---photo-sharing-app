//
//  MomentApp.swift
//  Moment
//
//  Created by Zachary Tao on 12/15/23.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}


@main
struct MomentApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
//            NavigationView {
//                AuthenticatedView {
//                    
//                } content: {
//                    ConversationView()
//                    Spacer()
//                }
//            }
            
        }
    }
}
