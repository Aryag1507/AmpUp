//
//  AmpUpApp.swift
//  AmpUp
//
//  Created by Keegan Reynolds on 2/12/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestoreSwift
import Combine

class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    print("Firebase Configured!")
    return true
  }
}

@main
struct AmpUpApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var appState = AppState()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }

    var body: some Scene {
        WindowGroup {
            if appState.isLoggedIn {
                // Assuming Workouts is your main content view
                NavigationView {
                        Workouts().environmentObject(appState)
                      }
            } else {
                // Your login or signup view
                NavigationView {
                        ContentView().environmentObject(appState)
                      }
            }
        }
    }
}
