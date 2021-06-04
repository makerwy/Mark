//
//  DayMarkApp.swift
//  DayMark
//
//  Created by wy on 2021/6/3.
//

import SwiftUI
import UserNotifications

@main
struct DayMarkApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    
    }
}
class AppDelegate:NSObject,UIApplicationDelegate {
   //swiftUI 2只有这个还有效果，其他的生命周期方法都失效，用上面的onchage代替。
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
       print("launch")
    
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { result, error in
        if result {
            print("success")
        }
        if error != nil {
            print(error as Any)
        }
    }
       return true
   }
}
