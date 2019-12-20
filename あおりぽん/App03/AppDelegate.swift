//
//  AppDelegate.swift
//  YakoOnOff03
//
//  Created by 社会情報学部 on 2019/11/17.
//  Copyright © 2019年 Rikiya Inada. All rights reserved.
//  ちあぽん改良版
//

import UIKit
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    var backgroundTaskID: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0)
    
    //    var lockState: String = ""
    
    //    var VC = ViewController()
    //    var mtc = myTimeCalculationClass()
        var mnc = myNotificationClass()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Background Fetch
        //        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        
        //return true
        
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
                    center.delegate = self
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
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //バックグラウンドで実行する処理
        
        
        //    if(ViewController.timerRunning == true){
        //        VC.timer = Timer.scheduledTimer(timeInterval: 1,
        //                                         target:self,
        //                                         selector: #selector(ViewController.update),
        //                                         userInfo: nil,
        //                                         repeats: true)
        //
        //    }
        //
        //        //適切なものを渡します → 新規データ: .newData 失敗: .failed データなし: .noData
        //        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        
        //このアプリのID（backgroundTaskID、適当に0にしている）をバックグラウンドアプリとして登録している？
        self.backgroundTaskID = application.beginBackgroundTask(){
            [weak self] in
            application.endBackgroundTask((self?.backgroundTaskID)!)
            self?.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
        }
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
                UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //アプリがアクティブになる直前に呼ばれる
        //バックグラウンドタスクを終了する？
        application.endBackgroundTask(self.backgroundTaskID)
    }
    
    //アプリケーションが終了される直前に呼ばれる
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print("フリックしてアプリを終了させた時に呼ばれる")
        

        mnc.body = "時間が正しく記録されないからちあぽんを開き直してね"
        mnc.sendMessage()
        
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



