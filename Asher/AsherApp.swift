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
    @Environment(\.scenePhase) var scenePhase
    @State var isStart = true
    
    var body: some Scene {
        WindowGroup {
            ToastLayerView {
                RootViewControllerRepresentable()
                    .ignoresSafeArea(.all)
                    .onReceive(NotificationCenter.default.publisher(for: UIScene.willEnterForegroundNotification)) { _ in
                        delegate.openLockScreen()
                    }
            }
            
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    func openLockScreen() {
        print(#function)
        let window = UIApplication.shared.window
        let lock = window?.rootViewController?.presentedViewController as? LockScreenViewController
        let rootViewController = window?.rootViewController as? RootViewController
        
        guard UserDefaultsManager.shared.usePassword && lock == nil
        else { return }
        
        print("my password = \(UserDefaultsManager.shared.password)")
        let lockScreenVc = LockScreenViewController(type: .normal)
        
        lockScreenVc.modalPresentationStyle = .overFullScreen
        
        UIApplication.shared.window?.rootViewController?.present(lockScreenVc, animated: false)
    }
}
