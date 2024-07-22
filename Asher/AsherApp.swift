//
//  AsherApp.swift
//  Asher
//
//  Created by chuchu on 6/7/24.
//

import SwiftUI
import SwiftData

import FirebaseCore
import FirebaseCrashlytics

@main
struct AsherApp: App {
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            Item.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            RootViewControllerRepresentable()
                .ignoresSafeArea(.all)
//            ContentView()
            
        }
//        .modelContainer(SwiftDataModelConfigurationProvider.shared.container)
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
