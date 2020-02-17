//
//  ViewController.swift
//  LockUnLockTest
//
//  Created by kmurata on 2020/02/06.
//  Copyright © 2020 kmurata seminar. All rights reserved.
//

import UIKit
import CoreLocation // for GPS

class ViewController: UIViewController, CLLocationManagerDelegate {

    //時間計算用
    var mtcc = myTimeCalculationClass()
    //メッセージ通知用
    var mnc = myNotificationClass()
    var mnm = myNotificationMessages()
    
    // タイマー用
    var timerAlways = Timer()
    
    // 画面表示用
    @IBOutlet weak var labelTotalLockNum: UILabel!
    @IBOutlet weak var labelTodayLockNum: UILabel!
    
    var lockcounter: Int = 0

    // 経過時間
    @IBOutlet weak var labelTotalTime: UILabel!
    @IBOutlet weak var labelTotalLockedTime: UILabel!
    @IBOutlet weak var labelTotalUnLockedTime: UILabel!
    @IBOutlet weak var labelTodayLockedTime: UILabel!
    @IBOutlet weak var labelTodayUnLockedTime: UILabel!
    @IBOutlet weak var labelNowUnLockedTime: UILabel!
    
    //制御用
    var flag_unlocked: Bool = true
    var timer_counter: Int = 0
    
    
        var elapsed_time: Int = 0
    
    //----------------------------------------------------------------
    // viewDidLoad
    //----------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // initialize variables
        initSettings()
        
        // start scheduled timer
        timerAlways = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateAlways), userInfo: nil, repeats: true)
        
    }
    
    //----------------------------------------------------------------
    // functions
    //----------------------------------------------------------------
    
    //----------------------------------------------------------------
    // reset variable
    //----------------------------------------------------------------
    func resetVariables(){
        lockcounter = 0
        elapsed_time = 0
        timer_counter = 0;
    }
    
    //----------------------------------------------------------------
    // for initial settings
    //----------------------------------------------------------------
    func initSettings(){
        
        resetVariables()
        
        // *************************************
        //  BackgroundTask (using GPS) start

        
        // Start GPS for background Task
        // Getting Location status
        let status = CLLocationManager.authorizationStatus()
        if status == CLAuthorizationStatus.restricted || status == CLAuthorizationStatus.denied {
            return
        }
        
        myLocationManager = CLLocationManager()
        myLocationManager.delegate = self as CLLocationManagerDelegate
        //myLocationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        myLocationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        myLocationManager.pausesLocationUpdatesAutomatically = false
        myLocationManager.allowsBackgroundLocationUpdates = true
        //myLocationManager.activityType = .fitness
        myLocationManager.distanceFilter = 99999
        
        //
        if status == CLAuthorizationStatus.notDetermined {
            myLocationManager.requestAlwaysAuthorization()
            //myLocationManager.startMonitoringSignificantLocationChanges()
            myLocationManager.startUpdatingLocation()
            print("start with confirmation")
        }else{
            myLocationManager.startUpdatingLocation()
            //myLocationManager.startMonitoringSignificantLocationChanges()
            print("start without confirmation")
        }
        
        //
        if !CLLocationManager.locationServicesEnabled() {
            return
        }
        
        // BackgroundTask (using GPS) end
        // *************************************
        
        
        // *************************************
        //  Lock/UnLock start
        
        // Start checking the Lock/UnLock status.
        addNotificationObservers()
        
        //  Lock/UnLock start end
        // *************************************
    }
    
    //----------------------------------------------------------------
    // 1秒ごとに繰り返されるループ
    //----------------------------------------------------------------
    @objc func updateAlways(){
        labelTotalLockNum.text = "lock: " + String(mtcc.total_lockedcounter) + ", unlock: " + String(mtcc.total_unlockedcounter)
        labelTodayLockNum.text = "lock: " + String(mtcc.lockedcounter) + ", unlock: " + String(mtcc.unlockedcounter)
        labelTotalLockedTime.text = mtcc.getTotalLockedTime()
        labelTotalUnLockedTime.text = mtcc.getTotalUnLockedTime()
        labelTodayLockedTime.text = mtcc.getTodayLockedTime()
        labelTodayUnLockedTime.text = mtcc.getTodayUnLockedTime()
        
        //現在のアンロック時間の処理
        if flag_unlocked {
            timer_counter += 1
            labelNowUnLockedTime.text = mtcc.formatSecToTime(seconds: Double(timer_counter))
            
            //30分以内であれば15分ごとにちあポン通知
            if timer_counter <= 1800 {
                //15分ごとに通知
                if timer_counter % 900 == 0 {
                    mnc.title = "\((timer_counter / 60))分間使ってるよ！"
                    mnc.body = "そんなに使ったら電池減っちゃうよ😣使わないように頑張って！"
                    mnc.sendMessage()
                }
            }else{
                //5分ごとに通知
                if timer_counter % 300 == 0 {
                    //コメント生成
                    var message: String = ""
                    if mtcc.checkTime(from: 5, to: 11) {    //午前
                        message = mnm.getCommnet(comments: mnm.aori_Morning)
                    }else if mtcc.checkTime(from: 11, to: 13){  //お昼
                        message = mnm.getCommnet(comments: mnm.aori_Noon)
                    }else if mtcc.checkTime(from: 13, to: 18){  //午後
                        message = mnm.getCommnet(comments: mnm.aori_AfterNoon)
                    }else if mtcc.checkTime(from: 18, to: 23){  //夜
                        message = mnm.getCommnet(comments: mnm.aori_Night)
                    }else{  //深夜（上記以外）
                        message = mnm.getCommnet(comments: mnm.aori_MidNight)
                    }
                    mnc.title = "\(timer_counter / 60)分も経ったぞ！"
                    mnc.body = message
                    mnc.sendMessage()
                }
            }
            
            //回数による処理
            //アンロック時ではうまくいかないので、アンロックした後1秒経過後に出す（多分確実に見るタイミング）
            if timer_counter == 2 {
                //回数メッセージの送信：５０回が平均？
                //https://www.countand1.com/2017/05/smartphone-usage-48-and-apps-usage-90-per-day.html
                if self.mtcc.unlockedcounter != 0 && self.mtcc.unlockedcounter % 10 == 0 && self.mtcc.unlockedcounter <= 50 {
                    var message: String = ""
                    if self.mtcc.checkTime(from: 7, to: 18){
                        message = self.mnm.getCommnet(comments: self.mnm.cheerpon_Counter_daytime)
                    } else if self.mtcc.checkTime(from: 18, to: 22){
                        message = self.mnm.getCommnet(comments: self.mnm.cheerpon_Counter_Night)
                    } else {
                        message = self.mnm.getCommnet(comments: self.mnm.cheerpon_Counter_MidNight)
                    }
                    self.mnc.title = "今日は\(self.mtcc.unlockedcounter)回開いてるよ😵"
                    self.mnc.body = message
                    self.mnc.sendMessage()
                    
                } else if self.mtcc.unlockedcounter % 5 == 0 && self.mtcc.unlockedcounter > 50 {
                    var message: String = ""
                    if self.mtcc.checkTime(from: 5, to: 11) {    //午前
                        message = self.mnm.getCommnet(comments: self.mnm.aori_Morning)
                    }else if self.mtcc.checkTime(from: 11, to: 13){  //お昼
                        message = self.mnm.getCommnet(comments: self.mnm.aori_Noon)
                    }else if self.mtcc.checkTime(from: 13, to: 18){  //午後
                        message = self.mnm.getCommnet(comments: self.mnm.aori_AfterNoon)
                    }else if self.mtcc.checkTime(from: 18, to: 23){  //夜
                        message = self.mnm.getCommnet(comments: self.mnm.aori_Night)
                    }else{  //深夜（上記以外）
                        message = self.mnm.getCommnet(comments: self.mnm.aori_MidNight)
                    }
                    self.mnc.title = "これでもう\(self.mtcc.unlockedcounter)回目だぞ！"
                    self.mnc.body = message
                    self.mnc.sendMessage()
                }
            }
        }
        
        //定時コメントの処理
        //7:00
        if(mtcc.getNowTime() == "070000"){
            //バッジ表示
            UIApplication.shared.applicationIconBadgeNumber = 1
            //通知メッセージのセット
            let message = mnm.getCommnet(comments: mnm.cheerpon_Morning)
            mnc.title = NSString.localizedUserNotificationString(forKey: "おはよう☀️今日も1日頑張ろう！", arguments: nil)
            mnc.body = NSString.localizedUserNotificationString(forKey: message, arguments: nil)
            mnc.sendMessage()
        }
        
        //12:00
        if(mtcc.getNowTime() == "120000"){
            //バッジ表示
            UIApplication.shared.applicationIconBadgeNumber = 1
            //通知メッセージのセット
            let message = mnm.getCommnet(comments: mnm.cheerpon_AfterNoon)
            mnc.title = NSString.localizedUserNotificationString(forKey: "お昼の時間だね🕛", arguments: nil)
            mnc.body = NSString.localizedUserNotificationString(forKey: message, arguments: nil)
            mnc.sendMessage()
        }
        
        //22:00
        if(mtcc.getNowTime() == "220000"){
            //バッジ表示
            UIApplication.shared.applicationIconBadgeNumber = 1
            //通知メッセージのセット
            let message = mnm.getCommnet(comments: mnm.cheerpon_Night)
            mnc.title = NSString.localizedUserNotificationString(forKey: "もうこんな時間💦", arguments: nil)
            mnc.body = NSString.localizedUserNotificationString(forKey: message, arguments: nil)
            mnc.sendMessage()
        }
        
        //print("lock: " + String(mtcc.lockcounter))
        //print("unlock: " + String(mtcc.unlockcounter))
        
        
        
    }
    
    
    
    // *************************************
    //  BackgroundTask (using GPS) start

    //位置情報関係
    var myLocationManager: CLLocationManager!
    var myLatitude       : String = ""
    var myLongitude      : String = ""
    
    //Success get location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("in locationManager")
        if let location = manager.location {
            self.myLatitude  = "\(location.coordinate.latitude)"
            self.myLongitude = "\(location.coordinate.longitude)"
            
            print("\(self.myLatitude):\(self.myLongitude)")
            
        }
    }
    
    //Cant get location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error")
    }
    
    //  BackgroundTask (using GPS) end
    // *************************************
    
    
    // *************************************
    //  Lock/UnLock start


    struct NotificationName {
        // Listen to CFNotification, and convert to Notification
        public static let lockComplete = Notification.Name("NotificationName.lockComplete")
        public static let lockState = Notification.Name("NotificationName.lockState")

        // Handle lockComplete and lockState Notification to post locked or unlocked notification.
        public static let locked = Notification.Name("NotificationName.locked")
        public static let unlocked = Notification.Name("NotificationName.unlocked")
    }

    func addNotificationObservers() {
        print("in_addNotificationObserver")
        let lockCompleteString = "com.apple.springboard.lockcomplete"
        let lockString = "com.apple.springboard.lockstate"

        // Listen to CFNotification, post Notification accordingly.
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                        nil,
                                        { (_, _, _, _, _) in
                                            NotificationCenter.default.post(name: NotificationName.lockComplete, object: nil)
                                        },
                                        lockCompleteString as CFString,
                                        nil,
                                        CFNotificationSuspensionBehavior.deliverImmediately)

        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                        nil,
                                        { (_, _, _, _, _) in
                                            NotificationCenter.default.post(name: NotificationName.lockState, object: nil)
                                        },
                                        lockString as CFString,
                                        nil,
                                        CFNotificationSuspensionBehavior.deliverImmediately)

        // Listen to Notification and handle.
        NotificationCenter.default.addObserver(self,
                                                selector: #selector(onLockComplete),
                                                name: NotificationName.lockComplete,
                                                object: nil)

        NotificationCenter.default.addObserver(self,
                                                selector: #selector(onLockState),
                                                name: NotificationName.lockState,
                                                object: nil)
    }

    // nil means don't know; ture or false means we did or did not received such notification.
    var receiveLockStateNotification: Bool? = nil
    // when we received lockState notification, use timer to wait 0.3s for the lockComplete notification.
    var waitForLockCompleteNotificationTimer: Timer? = nil
    var receiveLockCompleteNotification: Bool? = nil

    // When we received lockComplete notification, invalidate timer and refresh lock status.
    @objc
    func onLockComplete() {
        //ロックされた時の処理
        print("in_onLockComplete")
        if let timer = waitForLockCompleteNotificationTimer {
            timer.invalidate()
            waitForLockCompleteNotificationTimer = nil
        }

        receiveLockCompleteNotification = true
        changeIsLockedIfNeeded()
        
        // increnebt loccounter
        // lockcounter += 1
        //ロックをセット
        mtcc.setLocked()
        flag_unlocked = false
        timer_counter = 0
    }

    // When we received lockState notification, refresh lock status.
    @objc
    func onLockState() {
        //ロック、アンロックどちらも処理
        print("in_onLockState")
        receiveLockStateNotification = true
        changeIsLockedIfNeeded()
    }

    func changeIsLockedIfNeeded() {
        guard let state = receiveLockStateNotification, state else {
            // If we don't receive lockState notification, return.
            return
        }

        guard let complete = receiveLockCompleteNotification else {
            // If we don't receive lockComplete notification, wait 0.3s.
            // If nothing happens in 0.3s, then make sure we don't receive lockComplete, and refresh lock status.
            //ここが実質的にアンロックされた時の処理（ロックじゃなかった時の処理）
            waitForLockCompleteNotificationTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { _ in
                self.receiveLockCompleteNotification = false
                self.changeIsLockedIfNeeded()
                //アンロックをセット
                self.mtcc.setUnLocked()
                self.flag_unlocked = true
                
                
            })
            return
        }

        // When we determined lockState and lockComplete notification is received or not.
        // We can update the device lock status by 'complete' value.
        NotificationCenter.default.post(
            name: complete ? NotificationName.locked : NotificationName.unlocked,
            object: nil
        )

        // Reset status.
        receiveLockStateNotification = nil
        receiveLockCompleteNotification = nil
    }
    
    //  Lock/UnLock start end
    // *************************************
    

}

