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
import FirebaseRemoteConfig

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
                    .onChange(of: scenePhase) { newScenePhase in
                        switch newScenePhase {
                        case .active where isStart:
                            delegate.openLockScreen()
                            isStart = false
                        default: break
                        }
                    }
                
            }.onAppear()
            
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        setFireBase()
        return true
    }
    
    private func setFireBase() {
        FirebaseApp.configure()
        
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings().then { $0.minimumFetchInterval = 0 }
        
        remoteConfig.configSettings = settings
        
        remoteConfig.fetch { status, error in
            switch status {
            case .success:
                remoteConfig.activate { isChanged, error in
                    self.setUserDefaultFromRemoteConfig(remoteConfig)
                }
            default: break
            }
        }
    }
    
    private func setUserDefaultFromRemoteConfig(_ config: RemoteConfig) {
        UserDefaultsManager.shared.contactUrl = config[RemoteConfigKey.contactUrl].string
    }
    
    func openLockScreen() {
        print(#function)
        let window = UIApplication.shared.window
        let lock = window?.rootViewController?.presentedViewController as? LockScreenViewController
        
        guard UserDefaultsManager.shared.usePassword && lock == nil
        else { return }
        
        print("my password = \(UserDefaultsManager.shared.password)")
        let lockScreenVc = LockScreenViewController(type: .normal)
        
        lockScreenVc.modalPresentationStyle = .overFullScreen
        
        UIApplication.shared.window?.rootViewController?.present(lockScreenVc, animated: false)
    }
}

extension RemoteConfigValue {
    var string: String { stringValue ?? "" }
}

enum RemoteConfigKey {
    static let contactUrl = "contactUrl"
}
