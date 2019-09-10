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

var elapsed_time: Double = 0        // Stopボタンした時点で経過していた時間

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var resetButton: UIButton!

    //通知処理用
    var mnc = myNotificationClass()
    //時刻処理用
    var mtcc = myTimeCalculationClass()
    
    //ちあぽんのセリフ
    var MorningComments: [String] = ["早起きは三文の徳だよ！ちあぽんもあなたの為に早起きしたよ！！","今日は朝から体を動かしてみたらどうかな？","まだ眠い？ちあぽんも眠たいよ〜ちあぽんのこと起こしに来て〜🛌","寒くて朝起きるの大変だけど、今日も1日頑張ろう！","スマホを使わない1日を作ってみない〜？"]
    var Morning2Comments: [String] = ["スマホを使いすぎないように、ちあぽんが応援してるよ！","ちあぽんがスマホの使いすぎの抑制のお手伝いをするよ😊","ちあぽんを開いてから今日も1日スタートさせよう！","今日も1日頑張って！たまにはちあぽんに会いに来てね🎀","ちあぽんに会いに来たらスマホをどれだけ使っているかわかるよ！"]
    var NoonComments: [String] = ["午前中スマホ使いすぎてない〜？","午後もスマホ使いすぎないように頑張ってね！","今日の昼食は何かな？スマホを離れてゆっくり食べてね🍽","家族や友達とコミュニケーションしながらお昼を楽しんでね！","お昼の時はスマホを見ないようにしよう🍳"]
    var OyatuComments: [String] = ["スマホをお休みしてみよう！","今日やるべきことを今からやったら、きっとすぐ終わるよ♪","午後も始まったばかり！スマホの電池なくならないように気を付けて！","ちあぽんのもぐもぐタイムだよ🍭","休憩休憩🎶体と一緒にスマホも休ませよう！"]
    var AfterNoonComments: [String] = ["お腹空いたぁ🤤夕ご飯食べた？","今日ももう少しでおしまい。スマホを使わないように頑張ってね！","あと一踏ん張り頑張って！！","家族と一緒のご飯は100倍美味しいね！","近くの人とお話ししてみたら何か良いことあるかも🤗"]
    var JuujiComments : [String] = ["今日も残りあと少し！やり残したことはない？","明日の予定は確認できてる？明日はゆっくり休めるかなあ🤔","もう夜になっちゃったね。お風呂は入った？🛁","今日は他にやることない？1日あっという間だね〜🙃","私は寝る支度中〜あなたも他にやることない？","今日ももう少しでおしまい。スマホを使わないように頑張ってね😉"]
    var MidNightComments : [String] = ["今日はどれくらい使ったのか見てみてね👀","明日はもう少し休憩してちょうだいね😌","明日もちあぽんと一緒に使いすぎに気をつけよう！","明日も使いすぎないように頑張ってね♪","スマホの使用量が減ってたらちあぽんも嬉しい！"]
    var NightTimeComments : [String] = ["ふわぁ寝てた〜どうしたの？もう寝よう🛌","まだ起きてたの？もう寝よう😴","スマホを閉じてゆっくり休んでね。","ちあぽんは今夢見てたよ。。食べ物がいっぱいの…","早寝早起きのリズムが大事だよ！"]
    
    var CounterComments: [String] = ["また開いちゃった❓使わないように気をつけよう☺️","こんなに呼ばれてちあぽんびっくり！","スマホの使い過ぎを減らすには、まず開く回数から減らしてみよう🐾","スマホ開いてるのちあぽん見てるよ👀","スマホを使う前に、先に他のことしておこう🚗"]
    
    
    var timer_lighton = Timer()                 // Timerクラス ライトが消えると止まるタイマー
    var start_time: TimeInterval = 0     // Startした時刻
    var total_time : Double = 0             // ラベルに表示する時間
    var timer_always = Timer()            //ライトが消えてもずっと動いてるタイマー
    
    @IBOutlet var TimerLabel2: UILabel!
    @IBOutlet weak var CountLabel: UILabel!
    
    
    var counter_lighton = 0 //画面点灯時間の計測用
    var time_display = 0    //画面に表示する時間の一時置き
    
    var userDefaults = UserDefaults.standard //データ保存用のuserDefaults
    
    @IBAction func tapReset(_ sender: Any) {
        mtcc.oncounter = 0
        counter_lighton = 0
        time_display = 0
        
        start_time = Date().timeIntervalSince1970
        elapsed_time = 0
        
        let s3 = time_display % 60
        let m3 = (time_display % 3600) / 60
        let h3 =  time_display / 3600
        
        total_time = Date().timeIntervalSince1970 - start_time + elapsed_time
        
        let displayStr = NSString(format: "%02d時間%02d分%02d秒", h3,m3,s3 ) as String
        TimerLabel2.text = displayStr
    }
    
    // 1秒ごとに呼び出される処理 現在の時刻との比較
    //ライトが消えてもずっと動いてる方
    @objc func update_always() {
        print(mtcc.getNowTime())    //現在時刻の表示（デバッグよう）


        //ここから定時処理
        
        //7:00
        if(mtcc.isMorning() == true){
            //バッジ表示
            UIApplication.shared.applicationIconBadgeNumber = 1
            //通知メッセージのセット
            let message = (Int)(arc4random_uniform(5))
            mnc.title = NSString.localizedUserNotificationString(forKey: "今日もちあぽんを開いてね！", arguments: nil)
            mnc.body = NSString.localizedUserNotificationString(forKey: MorningComments[message], arguments: nil)
            mnc.sendMessage()
        }
        
        //8:00
        if(mtcc.getNowTime() == "080000"){
            //バッジ表示
            UIApplication.shared.applicationIconBadgeNumber = 1
            //通知メッセージのセット
            let message = (Int)(arc4random_uniform(5))
            mnc.title = NSString.localizedUserNotificationString(forKey: "おはよう☀️今日も1日頑張ろう！", arguments: nil)
            mnc.body = NSString.localizedUserNotificationString(forKey: Morning2Comments[message], arguments: nil)
            mnc.sendMessage()
        }
        
        //正午
        if(mtcc.isNoon() == true){
            //バッジ表示
            UIApplication.shared.applicationIconBadgeNumber = 1
            //通知メッセージのセット
            let message = (Int)(arc4random_uniform(5))
            mnc.title = NSString.localizedUserNotificationString(forKey: "お昼の時間だね🕛", arguments: nil)
            mnc.body = NSString.localizedUserNotificationString(forKey: NoonComments[message], arguments: nil)
            mnc.sendMessage()
        }
        
        //15:00
        if(mtcc.getNowTime() == "150000"){
            //バッジ表示
            UIApplication.shared.applicationIconBadgeNumber = 1
            //通知メッセージのセット
            let message = (Int)(arc4random_uniform(5))
            mnc.title = NSString.localizedUserNotificationString(forKey: "おやつの時間だ🍩", arguments: nil)
            mnc.body = NSString.localizedUserNotificationString(forKey: OyatuComments[message], arguments: nil)
            mnc.sendMessage()
        }
        
        //18:48
        if(mtcc.isAfterNoon() == true){
            //バッジ表示
            UIApplication.shared.applicationIconBadgeNumber = 1
            //通知メッセージのセット
            let message = (Int)(arc4random_uniform(5))
            mnc.title = NSString.localizedUserNotificationString(forKey: "もうこんな時間💦", arguments: nil)
            mnc.body = NSString.localizedUserNotificationString(forKey: AfterNoonComments[message], arguments: nil)
            mnc.sendMessage()
        }
        
        //22:00
        if(mtcc.getNowTime() == "220000"){
            //バッジ表示
            UIApplication.shared.applicationIconBadgeNumber = 1
            //通知メッセージのセット
            //let message = (Int)(arc4random_uniform(5))
            mnc.title = NSString.localizedUserNotificationString(forKey: "22時になったね🌙", arguments: nil)
            mnc.body = NSString.localizedUserNotificationString(forKey: "0時に今日の使用状況がリセットされちゃうからチェックしてみてね〜😆", arguments: nil)
            mnc.sendMessage()
        }
        
        //23:50
        if(mtcc.isMidNight() == true){
            //バッジ表示
            UIApplication.shared.applicationIconBadgeNumber = 1
            //通知メッセージのセット
            let message = (Int)(arc4random_uniform(5))
            mnc.title = NSString.localizedUserNotificationString(forKey: "0時で使用状況をリセットするよ！", arguments: nil)
            mnc.body = NSString.localizedUserNotificationString(forKey: MidNightComments[message], arguments: nil)
            mnc.sendMessage()
        }
        
        
        //00:00 定時リセット
        if(mtcc.isMidNight2() == true){
            mtcc.oncounter = 0
            counter_lighton = 0
            time_display = 0
                
            start_time = Date().timeIntervalSince1970
            elapsed_time = 0
                
            let s3 = time_display % 60
            let m3 = (time_display % 3600) / 60
            let h3 =  time_display / 3600
                
            total_time = Date().timeIntervalSince1970 - start_time + elapsed_time
                
            let displayStr = NSString(format: "%02d時間%02d分%02d秒", h3,m3,s3 ) as String
            TimerLabel2.text = displayStr
            
            //メッセージ通知
            //通知メッセージのセット
            //let message = (Int)(arc4random_uniform(5))
            mnc.title = NSString.localizedUserNotificationString(forKey: "0時になったよ", arguments: nil)
            mnc.body = NSString.localizedUserNotificationString(forKey: "使用状況がリセットされたよ。スマホの画面を開き直して、ちあぽんで確認してね😴", arguments: nil)
            mnc.sendMessage()
        }
        
    }
    
    // 1秒ごとに呼び出される処理 累積表示は現在時刻との比較
    //ライトが消えると止まる方
    @objc func update_lighton() {
        counter_lighton += 1
        //test
        print("counter_lighton: \(counter_lighton)")
        // (現在の時刻 - Startボタンを押した時刻) + Stopボタンを押した時点で経過していた時刻
        total_time = Date().timeIntervalSince1970 - start_time + elapsed_time
        
        userDefaults.set(Date().timeIntervalSince1970, forKey: "interval")
        userDefaults.set(start_time, forKey: "starttime")
        userDefaults.set(elapsed_time, forKey: "elapsedtime")
        
        
        let countNum02 = Int(total_time)
        let s2 = countNum02 % 60
        let m2 = (countNum02 % 3600) / 60
        let h2 =  countNum02 / 3600
        
        // 「XX:XX.XX」形式でラベルに表示する %02d:桁数が少ない場合に、前に0を付ける
        let displayStr = NSString(format: "%02d時間%02d分%02d秒", h2,m2,s2 ) as String
        TimerLabel2.text = displayStr
        CountLabel.text = String(mtcc.oncounter) + "回"
        
        
        userDefaults.set(counter_lighton, forKey: "KeyName2")
        userDefaults.set(mtcc.oncounter, forKey: "KeyName3")
        
        //30分連続使用通知
        if(counter_lighton % 1800 == 0){
            
            mnc.title = "\((counter_lighton / 60))分間使ってるよ！"
            mnc.body = "そんなに使ったら電池減っちゃうよ😣使わないように頑張って！"
            mnc.sendMessage()
            
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
        
        start_time = Date().timeIntervalSince1970
        
        // 1秒おきに関数「update2」を呼び出す
        //ライトが消えたらタイマー止まる
        timer_lighton = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update_lighton), userInfo: nil, repeats: true)
        
        // 1秒おきに関数「update_always」を呼び出す
        //ライトが消えてもタイマーずっと動いてる
        timer_always = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update_always), userInfo: nil, repeats: true)
        

        //タスクキル後のタイマー誤作動防止用
        counter_lighton = 0
        
        //アプリ起動時に、前回終了時に保存していた各種値を戻す
        if let value2 = UserDefaults.standard.string(forKey: "KeyName2"){
            
            counter_lighton = Int(value2)!
            
        }
        
        if let value3 = UserDefaults.standard.string(forKey: "KeyName3"){
            
            mtcc.oncounter = Int(value3)!
            
        }
        
        if let value4 = UserDefaults.standard.string(forKey: "starttime"){
            
            start_time = Double(value4)!
            
        }
        if let value5 = UserDefaults.standard.string(forKey: "elapsedtime"){
            
            elapsed_time = Double(value5)!
            
        }
        
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
        
        
        
        /* ここから非公式な方法 */
        //Observe開始
        registerforDeviceLockNotification()
        //Observerの無効化
        CFNotificationCenterRemoveObserver(CFNotificationCenterGetLocalCenter(),
                                           Unmanaged.passUnretained(self).toOpaque(),
                                           nil,
                                           nil)
        /* ここまで */
        
    }
    
    /* ここから非公式API */
    // デバイスのロック、画面点灯を検出する　→ この処理をしているとAppStoreの審査に通りません
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
                
                counter_lighton = 0
                
                //ライトが消えると止まるタイマー
                timer_lighton.invalidate()
                
                // 再度Startした時に加算するため、これまでに計測した経過時間を保存
                elapsed_time = total_time
                
                
            }else{
                self.screenlight = true
                print("ライトがつきました")
                
                start_time = Date().timeIntervalSince1970
                userDefaults.set(Date().timeIntervalSince1970, forKey: "interval")
                
                // 1秒おきに関数「update_lighton」を呼び出す
                timer_lighton = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update_lighton), userInfo: nil, repeats: true)
                
                mtcc.setLightOn()
                
                if(mtcc.oncounter % 5 == 0)&&(mtcc.oncounter != 0){
                    let random10 = (Int)(arc4random_uniform(5))
                    mnc.title = "今日は\(mtcc.oncounter)回開いてるよ😵"
                    mnc.body = CounterComments[random10]
                    mnc.sendMessage()
                    
                }else{
                    //22時〜24時通知
                    if(mtcc.isJuujiTime() == true)&&(mtcc.oncounter % 3 == 0){
                        let random = (Int)(arc4random_uniform(5))
                        mnc.title = "おつかれさま🍵"
                        mnc.body = JuujiComments[random]
                        mnc.sendMessage()
                    }
                    //0時〜4時
                    if(mtcc.isNightTime() == true)&&(mtcc.oncounter % 3 == 0){
                        let random = (Int)(arc4random_uniform(5))
                        mnc.title = "日にちが変わっちゃったよ！"
                        mnc.body = NightTimeComments[random]
                        mnc.sendMessage()
                    }
                }
                
            }
        }
    }
    /* ここまで */
    
}
