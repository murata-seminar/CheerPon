//
//  ViewController.swift
//  YakoOnOff03
//
//  Created by 社会情報学部 on 2018/11/13.
//  Copyright © 2018年 Reina Yako. All rights reserved.
//  ちあぽん改良版
//

import UIKit
import UserNotifications
import CoreLocation

var elapsedTime: Double = 0        // Stopボタンした時点で経過していた時間

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var resetButton: UIButton!
    @IBAction func tapReset(_ sender: Any) {
        mtcc.oncounter = 0
        countNum2 = 0
        countNum02 = 0
        
        startTime = Date().timeIntervalSince1970
        elapsedTime = 0
        
        let s3 = countNum02 % 60
        let m3 = (countNum02 % 3600) / 60
        let h3 =  countNum02 / 3600
        
        time2 = Date().timeIntervalSince1970 - startTime + elapsedTime
        
        let displayStr = NSString(format: "%02d時間%02d分%02d秒", h3,m3,s3 ) as String
        TimerLabel2.text = displayStr
    }
    
    var mmc = myNotificationClass()
    var mtcc = myTimeCalculationClass()
    
    var MorningComments: [String] = ["早起きは三文の徳だよ！ちあぽんもあなたの為に早起きしたよ！！","今日は朝から体を動かしてみたらどうかな？","まだ眠い？ちあぽんも眠たいよ〜ちあぽんのこと起こしに来て〜🛌","寒くて朝起きるの大変だけど、今日も1日頑張ろう！","スマホを使わない1日を作ってみない〜？"]
    var Morning2Comments: [String] = ["スマホを使いすぎないように、ちあぽんが応援してるよ！","ちあぽんがスマホの使いすぎの抑制のお手伝いをするよ😊","ちあぽんを開いてから今日も1日スタートさせよう！","今日も1日頑張って！たまにはちあぽんに会いに来てね🎀","ちあぽんに会いに来たらスマホをどれだけ使っているかわかるよ！"]
    var NoonComments: [String] = ["午前中スマホ使いすぎてない〜？","午後もスマホ使いすぎないように頑張ってね！","今日の昼食は何かな？スマホを離れてゆっくり食べてね🍽","家族や友達とコミュニケーションしながらお昼を楽しんでね！","お昼の時はスマホを見ないようにしよう🍳"]
    var OyatuComments: [String] = ["スマホをお休みしてみよう！","今日やるべきことを今からやったら、きっとすぐ終わるよ♪","午後も始まったばかり！スマホの電池なくならないように気を付けて！","ちあぽんのもぐもぐタイムだよ🍭","休憩休憩🎶体と一緒にスマホも休ませよう！"]
    var AfterNoonComments: [String] = ["お腹空いたぁ🤤夕ご飯食べた？","今日ももう少しでおしまい。スマホを使わないように頑張ってね！","あと一踏ん張り頑張って！！","家族と一緒のご飯は100倍美味しいね！","近くの人とお話ししてみたら何か良いことあるかも🤗"]
    var JuujiComments : [String] = ["今日も残りあと少し！やり残したことはない？","明日の予定は確認できてる？明日はゆっくり休めるかなあ🤔","もう夜になっちゃったね。お風呂は入った？🛁","今日は他にやることない？1日あっという間だね〜🙃","私は寝る支度中〜あなたも他にやることない？","今日ももう少しでおしまい。スマホを使わないように頑張ってね😉"]
    var MidNightComments : [String] = ["今日はどれくらい使ったのか見てみてね👀","明日はもう少し休憩してちょうだいね😌","明日もちあぽんと一緒に使いすぎに気をつけよう！","明日も使いすぎないように頑張ってね♪","スマホの使用量が減ってたらちあぽんも嬉しい！"]
    var NightTimeComments : [String] = ["ふわぁ寝てた〜どうしたの？もう寝よう🛌","まだ起きてたの？もう寝よう😴","スマホを閉じてゆっくり休んでね。","ちあぽんは今夢見てたよ。。食べ物がいっぱいの…","早寝早起きのリズムが大事だよ！"]
    
    var CounterComments: [String] = ["また開いちゃった❓使わないように気をつけよう☺️","こんなに呼ばれてちあぽんびっくり！","スマホの使い過ぎを減らすには、まず開く回数から減らしてみよう🐾","スマホ開いてるのちあぽん見てるよ👀","スマホを使う前に、先に他のことしておこう🚗"]
    
    
    //    var timerRunning = false //これはタイマーが動いているかどうかのフラグ？
    //    var timer = Timer()
    var timer2 = Timer()                 // Timerクラス ライトが消えると止まるタイマー
    var startTime: TimeInterval = 0     // Startした時刻
    //var elapsedTime: Double = 0        // Stopボタンした時点で経過していた時間
    var time2 : Double = 0             // ラベルに表示する時間
    var timer3 = Timer()            //ライトが消えてもずっと動いてるタイマー
    
    @IBOutlet var TimerLabel2: UILabel!
    @IBOutlet weak var CountLabel: UILabel!
    
    
    //var countNum = 0    //ここにタイマーの値を保存
    var countNum2 = 0
    var countNum3 = 0
    var countNum02 = 0
    
    var userDefaults = UserDefaults.standard //データ保存用のuserDefaults
    
    // 1秒ごとに呼び出される処理 現在の時刻との比較
    //ライトが消えてもずっと動いてる方
    @objc func update3() {
        countNum3 += 1
        
        //ここから定時バッジ
        
        //7:00
        if(mtcc.isMorning() == true){
            UIApplication.shared.applicationIconBadgeNumber = 1
        }
        
        //正午
        if(mtcc.isNoon() == true){
            UIApplication.shared.applicationIconBadgeNumber = 1
        }
        
        //18:48
        if(mtcc.isAfterNoon() == true){
            UIApplication.shared.applicationIconBadgeNumber = 1
        }
        
        //23:50
        if(mtcc.isMidNight() == true){
            UIApplication.shared.applicationIconBadgeNumber = 1
        }
        
        
        //00:00 定時リセット
        if(mtcc.isMidNight2() == true){
                
                mtcc.oncounter = 0
                countNum2 = 0
                countNum02 = 0
                
                startTime = Date().timeIntervalSince1970
                elapsedTime = 0
                
                let s3 = countNum02 % 60
                let m3 = (countNum02 % 3600) / 60
                let h3 =  countNum02 / 3600
                
                time2 = Date().timeIntervalSince1970 - startTime + elapsedTime
                
                let displayStr = NSString(format: "%02d時間%02d分%02d秒", h3,m3,s3 ) as String
                TimerLabel2.text = displayStr
            }
        
    }
    
    // 1秒ごとに呼び出される処理 累積表示は現在時刻との比較
    //ライトが消えると止まる方
    @objc func update2() {
        countNum2 += 1
        
        // (現在の時刻 - Startボタンを押した時刻) + Stopボタンを押した時点で経過していた時刻
        time2 = Date().timeIntervalSince1970 - startTime + elapsedTime
        
        userDefaults.set(Date().timeIntervalSince1970, forKey: "interval")
        userDefaults.set(startTime, forKey: "starttime")
        userDefaults.set(elapsedTime, forKey: "elapsedtime")
        
        
        let countNum02 = Int(time2)
        let s2 = countNum02 % 60
        let m2 = (countNum02 % 3600) / 60
        let h2 =  countNum02 / 3600
        
        // 「XX:XX.XX」形式でラベルに表示する %02d:桁数が少ない場合に、前に0を付ける
        let displayStr = NSString(format: "%02d時間%02d分%02d秒", h2,m2,s2 ) as String
        TimerLabel2.text = displayStr
        CountLabel.text = String(mtcc.oncounter) + "回"
        
        
        userDefaults.set(countNum2, forKey: "KeyName2")
        userDefaults.set(mtcc.oncounter, forKey: "KeyName3")
        
        //30分連続使用通知
        if(countNum2 % 1800 == 0){
            
            mmc.title = "\((countNum2 / 60))分間使ってるよ！"
            mmc.body = "そんなに使ったら電池減っちゃうよ😣使わないように頑張って！"
            mmc.sendMessage()
            
        }
        
    }
    //↑ここまでが毎秒処理
    
    //画面状態の変数
    var screenlock: Bool = false
    var screenlight: Bool = true
    
    
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //手動リセットボタン 角丸のUIButtonを作成する 紫枠で線の太さは2.0
        resetButton.layer.borderColor = UIColor.purple.cgColor
        resetButton.layer.borderWidth = 2.0
        resetButton.layer.cornerRadius = 10.0 //丸みを数値で変更できます
        
        //startTimer()
        
        startTime = Date().timeIntervalSince1970
        
        // 1秒おきに関数「update2」を呼び出す
        //ライトが消えたらタイマー止まる
        timer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update2), userInfo: nil, repeats: true)
        
        // 1秒おきに関数「update3」を呼び出す
        //ライトが消えてもタイマーずっと動いてる
        timer3 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update3), userInfo: nil, repeats: true)
        
        
        //ここから定時OS通知
        
        //7:00
        //通知内容の設定
        let morning = UNMutableNotificationContent()
        //通知のメッセージセット
        let random1 = (Int)(arc4random_uniform(5))
        //↓タイトルはこんなに長く表示できない
        //morning.title = NSString.localizedUserNotificationString(forKey: "おはよう☀️今日も記録のためにちあぽんを開いてね！", arguments: nil)
        morning.title = NSString.localizedUserNotificationString(forKey: "今日もちあぽんを開いてね！", arguments: nil)
        morning.body = NSString.localizedUserNotificationString(forKey: MorningComments[random1], arguments: nil)
        // トリガーを設定
        var morninginfo = DateComponents()
        morninginfo.hour = 7
        morninginfo.minute = 0
        let morningtrigger = UNCalendarNotificationTrigger(dateMatching: morninginfo, repeats: true)
        // リクエストオブジェクトを生成
        let morningrequest = UNNotificationRequest(identifier: "Morning", content: morning, trigger: morningtrigger)
        //サウンドの追加
        morning.sound = UNNotificationSound.default
        
        // リクエストのスケジュールを設定
        let center1 = UNUserNotificationCenter.current()
        center1.add(morningrequest) { (error : Error?)in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
        func userNotificationCenter1(_ center1: UNUserNotificationCenter,
                                     willPresent notification: UNNotification,
                                     withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            // アプリケーションのインターフェイスを直接更新。
            // サウンドを再生。
            completionHandler(UNNotificationPresentationOptions.sound)
        }

        //8:00
        //通知内容の設定
        let morning2 = UNMutableNotificationContent()
        //通知のメッセージセット
        let random2 = (Int)(arc4random_uniform(5))
        //7:00の影響でおはよう☀️を追加
        morning2.title = NSString.localizedUserNotificationString(forKey: "おはよう☀️今日も1日頑張ろう！", arguments: nil)
        morning2.body = NSString.localizedUserNotificationString(forKey: Morning2Comments[random2], arguments: nil)
        // トリガーを設定
        var morning2info = DateComponents()
        morning2info.hour = 8
        morning2info.minute = 0
        let morning2trigger = UNCalendarNotificationTrigger(dateMatching: morning2info, repeats: true)
        // リクエストオブジェクトを生成
        let morning2request = UNNotificationRequest(identifier: "Morning2", content: morning2, trigger: morning2trigger)
        //サウンドの追加
        morning2.sound = UNNotificationSound.default
        
        // リクエストのスケジュールを設定
        let center2 = UNUserNotificationCenter.current()
        center2.add(morning2request) { (error : Error?)in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
        func userNotificationCenter2(_ center2: UNUserNotificationCenter,
                                     willPresent notification: UNNotification,
                                     withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            // アプリケーションのインターフェイスを直接更新。
            // サウンドを再生。
            completionHandler(UNNotificationPresentationOptions.sound)
        }
        
        //正午
        //通知内容の設定
        let noon = UNMutableNotificationContent()
        //通知のメッセージセット
        let random3 = (Int)(arc4random_uniform(5))
        noon.title = NSString.localizedUserNotificationString(forKey: "お昼の時間だね🕛", arguments: nil)
        noon.body = NSString.localizedUserNotificationString(forKey: NoonComments[random3], arguments: nil)
        // トリガーを設定
        var nooninfo = DateComponents()
        nooninfo.hour = 12
        nooninfo.minute = 0
        let noontrigger = UNCalendarNotificationTrigger(dateMatching: nooninfo, repeats: true)
        // リクエストオブジェクトを生成
        let noonrequest = UNNotificationRequest(identifier: "Noon", content: noon, trigger: noontrigger)
        //サウンドの追加
        noon.sound = UNNotificationSound.default
        
        // リクエストのスケジュールを設定
        let center3 = UNUserNotificationCenter.current()
        center3.add(noonrequest) { (error : Error?)in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
        func userNotificationCenter3(_ center3: UNUserNotificationCenter,
                                     willPresent notification: UNNotification,
                                     withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            // アプリケーションのインターフェイスを直接更新。
            // サウンドを再生。
            completionHandler(UNNotificationPresentationOptions.sound)
        }
        
        //15:00
        //通知内容の設定
        let oyatu = UNMutableNotificationContent()
        //通知のメッセージセット
        let random4 = (Int)(arc4random_uniform(5))
        oyatu.title = NSString.localizedUserNotificationString(forKey: "おやつの時間だ🍩", arguments: nil)
        oyatu.body = NSString.localizedUserNotificationString(forKey: OyatuComments[random4], arguments: nil)
        // トリガーを設定
        var oyatuinfo = DateComponents()
        oyatuinfo.hour = 15
        oyatuinfo.minute = 00
        let oyatutrigger = UNCalendarNotificationTrigger(dateMatching: oyatuinfo, repeats: true)
        // リクエストオブジェクトを生成
        let oyaturequest = UNNotificationRequest(identifier: "Oyatu", content: oyatu, trigger: oyatutrigger)
        //サウンドの追加
        oyatu.sound = UNNotificationSound.default
        
        // リクエストのスケジュールを設定
        let center4 = UNUserNotificationCenter.current()
        center4.add(oyaturequest) { (error : Error?)in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
        func userNotificationCenter4(_ center4: UNUserNotificationCenter,
                                     willPresent notification: UNNotification,
                                     withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            // アプリケーションのインターフェイスを直接更新。
            // サウンドを再生。
            completionHandler(UNNotificationPresentationOptions.sound)
        }
        
        //18:48
        //通知内容の設定
        let afterNonn = UNMutableNotificationContent()
        //通知のメッセージセット
        let random5 = (Int)(arc4random_uniform(5))
        afterNonn.title = NSString.localizedUserNotificationString(forKey: "もうこんな時間💦", arguments: nil)
        afterNonn.body = NSString.localizedUserNotificationString(forKey: AfterNoonComments[random5], arguments: nil)
        // トリガーを設定
        var afterNonninfo = DateComponents()
        afterNonninfo.hour = 18
        afterNonninfo.minute = 48
        let afterNonntrigger = UNCalendarNotificationTrigger(dateMatching: afterNonninfo, repeats: true)
        // リクエストオブジェクトを生成
        let afterNonnrequest = UNNotificationRequest(identifier: "AfterNoon", content: afterNonn, trigger: afterNonntrigger)
        //サウンドの追加
        afterNonn.sound = UNNotificationSound.default
        
        // リクエストのスケジュールを設定
        let center5 = UNUserNotificationCenter.current()
        center5.add(afterNonnrequest) { (error : Error?)in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
        func userNotificationCenter5(_ center5: UNUserNotificationCenter,
                                     willPresent notification: UNNotification,
                                     withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            // アプリケーションのインターフェイスを直接更新。
            // サウンドを再生。
            completionHandler(UNNotificationPresentationOptions.sound)
        }
        
        //22:00
        //通知内容の設定
        let night = UNMutableNotificationContent()
        //通知のメッセージセット
        //let random6 = (Int)(arc4random_uniform(5))
        night.title = NSString.localizedUserNotificationString(forKey: "22時になったね🌙", arguments: nil)
        night.body = NSString.localizedUserNotificationString(forKey: "0時に今日の使用状況がリセットされちゃうからチェックしてみてね〜😆" , arguments: nil)
        // トリガーを設定
        var nightinfo = DateComponents()
        nightinfo.hour = 22
        nightinfo.minute = 00
        let nighttrigger = UNCalendarNotificationTrigger(dateMatching: nightinfo, repeats: true)
        // リクエストオブジェクトを生成
        let nightrequest = UNNotificationRequest(identifier: "Night", content: night, trigger: nighttrigger)
        //サウンドの追加
        night.sound = UNNotificationSound.default
        
        // リクエストのスケジュールを設定
        let center6 = UNUserNotificationCenter.current()
        center6.add(nightrequest) { (error : Error?)in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
        func userNotificationCenter6(_ center6: UNUserNotificationCenter,
                                     willPresent notification: UNNotification,
                                     withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            // アプリケーションのインターフェイスを直接更新。
            // サウンドを再生。
            completionHandler(UNNotificationPresentationOptions.sound)
        }
        
        //23:50
        //通知内容の設定
        let midNight = UNMutableNotificationContent()
        //通知のメッセージセット
        let random7 = (Int)(arc4random_uniform(5))
        //↓タイトルはこんなに長く表示できない
        //midNight.title = NSString.localizedUserNotificationString(forKey: "もうすぐ0時で今日の使用状況がリセットされちゃうよ！", arguments: nil)
        midNight.title = NSString.localizedUserNotificationString(forKey: "0時で使用状況をリセットするよ！", arguments: nil)
        midNight.body = NSString.localizedUserNotificationString(forKey: MidNightComments[random7], arguments: nil)
        // トリガーを設定
        var midNightinfo = DateComponents()
        midNightinfo.hour = 23
        midNightinfo.minute = 50
        let midNighttrigger = UNCalendarNotificationTrigger(dateMatching: midNightinfo, repeats: true)
        // リクエストオブジェクトを生成
        let midNightrequest = UNNotificationRequest(identifier: "MidNight", content: midNight, trigger: midNighttrigger)
        //サウンドの追加
        midNight.sound = UNNotificationSound.default
        
        // リクエストのスケジュールを設定
        let center7 = UNUserNotificationCenter.current()
        center7.add(midNightrequest) { (error : Error?)in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
        func userNotificationCenter7(_ center7: UNUserNotificationCenter,
                                     willPresent notification: UNNotification,
                                     withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            // アプリケーションのインターフェイスを直接更新。
            // サウンドを再生。
            completionHandler(UNNotificationPresentationOptions.sound)
        }
        
        //00:00
        //通知内容の設定
        let midNight2 = UNMutableNotificationContent()
        //通知のメッセージセット
        //let random7 = (Int)(arc4random_uniform(5))
        midNight2.title = NSString.localizedUserNotificationString(forKey: "0時になったよ", arguments: nil)
        midNight2.body = NSString.localizedUserNotificationString(forKey: "使用状況がリセットされたよ。スマホの画面を開き直して、ちあぽんで確認してね😴", arguments: nil)
        // トリガーを設定
        var midNight2info = DateComponents()
        midNight2info.hour = 0
        midNight2info.minute = 0
        let midNight2trigger = UNCalendarNotificationTrigger(dateMatching: midNight2info, repeats: true)
        // リクエストオブジェクトを生成
        let midNight2request = UNNotificationRequest(identifier: "MidNight2", content: midNight2, trigger: midNight2trigger)
        //サウンドの追加
        midNight2.sound = UNNotificationSound.default
        
        // リクエストのスケジュールを設定
        let center8 = UNUserNotificationCenter.current()
        center8.add(midNight2request) { (error : Error?)in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
        func userNotificationCenter8(_ center8: UNUserNotificationCenter,
                                      willPresent notification: UNNotification,
                                      withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            // アプリケーションのインターフェイスを直接更新。
            // サウンドを再生。
            completionHandler(UNNotificationPresentationOptions.sound)
        }
        
        

        //タスクキル後のタイマー誤作動防止用
        countNum2 = 0
        
        
        if let value2 = UserDefaults.standard.string(forKey: "KeyName2"){
            
            countNum2 = Int(value2)!
            
        }
        
        if let value3 = UserDefaults.standard.string(forKey: "KeyName3"){
            
            mtcc.oncounter = Int(value3)!
            
        }
        
        if let value4 = UserDefaults.standard.string(forKey: "starttime"){
            
            startTime = Double(value4)!
            
        }
        if let value5 = UserDefaults.standard.string(forKey: "elapsedtime"){
            
            elapsedTime = Double(value5)!
            
        }
        
        
        
        /* ここから非公式な方法 */
        //Observe開始
        registerforDeviceLockNotification()
        //Observerの無効化
        CFNotificationCenterRemoveObserver(CFNotificationCenterGetLocalCenter(),
                                           Unmanaged.passUnretained(self).toOpaque(),
                                           nil,
                                           nil)
        /* ここまで */
        
        
        //Timer
        //        if(timerRunning == false){
        //            startTimer()
        //        }
        //位置情報取得用
        let status = CLLocationManager.authorizationStatus()
        if status == CLAuthorizationStatus.restricted || status == CLAuthorizationStatus.denied {
            return
        }
        
        myLocationManager = CLLocationManager()
        myLocationManager.delegate = self as? CLLocationManagerDelegate
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
        
        
    }
    
    /* ここから非公式API */
    func registerforDeviceLockNotification(){
        //Screen lock notification
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                        Unmanaged.passUnretained(self).toOpaque(),
                                        displayStatusChangedCallback,
                                        "com.apple.springboard.lockcomplete" as CFString,
                                        nil,
                                        .deliverImmediately)
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                        Unmanaged.passUnretained(self).toOpaque(),
                                        displayStatusChangedCallback,
                                        "com.apple.springboard.lockstate" as CFString,
                                        nil,
                                        .deliverImmediately)
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                        Unmanaged.passUnretained(self).toOpaque(),
                                        displayStatusChangedCallback,
                                        "com.apple.springboard.hasBlankedScreen" as CFString,
                                        nil,
                                        .deliverImmediately)
    }
    
    
    
    
    private let displayStatusChangedCallback: CFNotificationCallback = {_, cfObserver, cfName, _, _ in
        guard let lockState = cfName?.rawValue as String? else{
            return
        }
        let catcher = Unmanaged<ViewController>.fromOpaque(UnsafeRawPointer(OpaquePointer(cfObserver)!)).takeUnretainedValue()
        catcher.displayStatusChanged(lockState)
    }
    
    //画面状態
    private func displayStatusChanged(_ lockState: String){
        
        // var lockcompleteNotification: Bool = false
        if(lockState == "com.apple.springboard.lockcomplete"){
            self.screenlock = true
            // lockcompleteNotification = true
            
            print("ロックされました")
        }else if(lockState == "com.apple.springboard.hasBlankedScreen"){
            
            if(screenlight == true){
                
                mtcc.setLightOff()
                
                self.screenlight = false
                print("ライトが消えました")
                
                countNum2 = 0
                
                //ライトが消えると止まるタイマー
                timer2.invalidate()
                
                // 再度Startした時に加算するため、これまでに計測した経過時間を保存
                elapsedTime = time2
                
                
            }else{
                self.screenlight = true
                print("ライトがつきました")
                
                startTime = Date().timeIntervalSince1970
                userDefaults.set(Date().timeIntervalSince1970, forKey: "interval")
                
                // 1秒おきに関数「update2」を呼び出す
                timer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update2), userInfo: nil, repeats: true)
                
                mtcc.setLightOn()
                
                if(mtcc.oncounter % 5 == 0)&&(mtcc.oncounter != 0){
                    let random10 = (Int)(arc4random_uniform(5))
                    mmc.title = "今日は\(mtcc.oncounter)回開いてるよ😵"
                    mmc.body = CounterComments[random10]
                    mmc.sendMessage()
                    
                }else{
                    //22時〜24時通知
                    if(mtcc.isJuujiTime() == true)&&(mtcc.oncounter % 3 == 0){
                        let random = (Int)(arc4random_uniform(5))
                        mmc.title = "おつかれさま🍵"
                        mmc.body = JuujiComments[random]
                        mmc.sendMessage()
                    }
                    //0時〜4時
                    if(mtcc.isNightTime() == true)&&(mtcc.oncounter % 3 == 0){
                        let random = (Int)(arc4random_uniform(5))
                        mmc.title = "日にちが変わっちゃったよ！"
                        mmc.body = NightTimeComments[random]
                        mmc.sendMessage()
                    }
                }
                
            }
        }
        //        else if(lockState == "com.apple.springboard.lockstate"){
        //
        //
        ////            print("ロック状態が変わりました")
        ////            if(screenlock == false && lockcompleteNotification == false){
        ////                self.screenlock = false
        ////                print("ロックが解除されました")
        ////
        ////
        ////            }else{
        ////                self.screenlock = true
        ////            }
        //        }
    }
    /* ここまで */
    
    //    func formatDate(seconds: Date) -> String {
    //        //フォーマット形式を設定
    //        let format = DateFormatter()
    //        format.dateFormat = "yyyy/MM/dd HH:mm:ss"
    //        //引数secondsをフォーマットして戻す
    //        return format.string(from: seconds)
    //    }
    //
    /* ここまで */
    
}
