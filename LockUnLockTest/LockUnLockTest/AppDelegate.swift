//
//  AppDelegate.swift
//  LockUnLockTest
//
//  Created by kmurata on 2020/02/06.
//  Copyright © 2020 kmurata seminar. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var backgroundTaskID: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0)
    var mnc = myNotificationClass()
    
    var viewController: ViewController! //ViewControllerにアクセスするための変数

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //通知許可を求める
        if #available(iOS 10.0, *){
            //iOS10.0以上の場合
            //UNUsernotificationCenterを使うには UserNotificationsをimportする必要がある
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in
                if error != nil{
                    return
                }
                
                if granted{
                    print("通知許可")
                    //ここは、フォアグラウンドで動かしていても通知を処理できるようにしている？？？？
                    let center = UNUserNotificationCenter.current()
                    center.delegate = self as? UNUserNotificationCenterDelegate
                }else{
                    print("通知拒否")
                }
            })
        }else{
            //iOS9以下
            let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }

//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        print("in_applicationWIllResignActive")
        //このアプリのID（backgroundTaskID、適当に0にしている）をバックグラウンドアプリとして登録している？
        self.backgroundTaskID = application.beginBackgroundTask(){
            [weak self] in
            application.endBackgroundTask((self?.backgroundTaskID)!)
            self?.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
        }
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("in_applicationDidBecomeActive")
        //アプリがアクティブになる直前に呼ばれる
        //バックグラウンドタスクを終了する？
        application.endBackgroundTask(self.backgroundTaskID)
    }
    
    //アプリケーションが終了される直前に呼ばれる
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        //print("フリックしてアプリを終了させた時に呼ばれる")
        
        mnc.title = "アプリが終了されたよ"
        mnc.body = "時間が正しく記録されないからアプリを開き直してね"
        mnc.sendMessage()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.viewController.serializeMTCC()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
            // your code here
        }
        
    }
}

//UNUserNotificationCenterDelegateをAppDelegateに実装
extension AppDelegate: UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping(UNNotificationPresentationOptions) -> Void){
        completionHandler([.alert, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping() -> Void){
        
    }
}
