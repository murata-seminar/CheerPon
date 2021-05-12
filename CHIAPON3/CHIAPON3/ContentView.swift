//
//  ContentView.swift
//  CHIAPON3
//
//  Created by kmurata on 2021/02/15.
//

import SwiftUI
import CoreLocation
import RealmSwift

struct ContentView: View {
    
    var mnc: myNotificationClass = myNotificationClass()
    var mtcc: myTimeCalculationClass = myTimeCalculationClass()
    var mnm: myNotificationMessages = myNotificationMessages()
    
    //Firestore用
    
    //Realmの処理
    @StateObject var logData: LogViewModel = LogViewModel()
    
    //定時メッセージ表示時刻
    @State var morning: String = "070000"
    @State var afternoon: String = "120000"
    @State var night: String = "220000"

    
    //@ObservedObject var location: LocationManager
    
    @State var chiapon_message: String = "スマホの使用状況に応じて、\nアドバイスしてやってもいいぜ。\nたまには見に来いよ。"
    @State var label_current_time: String = "current time"
    @State var label_total_time: String = "total time"
    @State var label_unlocked: String = "Unlocked: 0"
    @State var label_locked: String = "Locked: 0"
    @State var counter_unlocked: Int = 0
    @State var counter_locked: Int = 0
    
    @State var image_name: String = "normal"
    
    //var userid: String = ""
    //var chiapon: String = "normal"
    //var type: String = "chiapon"
    
    //@State var counter: Int = 0
    
    @State var flag_unlocked: Bool = true  //アンロックされているかどうか
    var userDefaultsData = UserDefaults.standard  //シリアライズ用
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    let pub_unlocked = NotificationCenter.default.publisher(for: UIApplication.protectedDataDidBecomeAvailableNotification)
    let pub_locked = NotificationCenter.default.publisher(for: UIApplication.protectedDataWillBecomeUnavailableNotification)
    let pub_discard = NotificationCenter.default.publisher(for: UIScene.didDisconnectNotification)
    
    //各種設定用クラス
    @ObservedObject var msc = mySettingClass()
    //設定画面の表示
    @State private var showSettingView: Bool = false
    
    //イニシャライザ
    init(){
        //位置情報取得に関する設定
        //self.location = LocationManager(accuracy: kCLLocationAccuracyThreeKilometers)
        
        //ちあぽんのモードをあおりにしておく
        msc.chiapon = "aori"
        
        //その他の一般的な初期設定
        initialSettings()
        
        //if logData.logs.isEmpty{
        //    print("Realm Chack: no datum")
        //}else{
        //    print("Realm check: \(logData.logs)")
        //}
    }
    
    var body: some View {
        VStack {
            VStack(alignment:.trailing) {
                Button(action: {
                    self.showSettingView = true
                }, label: {
                    Text("設定")
                        .frame(width: 100, height: 30)
                        .foregroundColor(.black)
                        .background(Color.orange)
                        .cornerRadius(15, antialiased: true)
                })
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 10.0)
                .sheet(isPresented: self.$showSettingView, content: {
                    SettingView().environmentObject(msc)
                })
            }
            //DBのデバッグ用
/*            HStack{
                Button(action: {
                    /*
                    let tmplog: Log = Log()
                    tmplog.id = Int(Date().timeIntervalSince1970 * 1000)
                    tmplog.timestamp = Date().timeIntervalSince1970
                    tmplog.message = chiapon_message
                    tmplog.userid = msc.userid
                    tmplog.username = msc.username
                    tmplog.chiapon = msc.chiapon
                    tmplog.type = msc.type
                    logData.addData(addlog: tmplog)
                    */
                    addLog(message: chiapon_message, locked: true, unlocked: true, current_usagetime: 0.1)
                    //firestore
                    addLogFirestore(message: chiapon_message, locked: true, unlocked: true, current_usagetime: 0.1)
                }, label: {
                    Text("追加")
                        .frame(width: 100, height: 30)
                        .foregroundColor(.black)
                        .background(Color.orange)
                        .cornerRadius(15, antialiased: true)
                })
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.trailing, 10.0)
                .sheet(isPresented: self.$showSettingView, content: {
                    SettingView().environmentObject(msc)
                })
                Button(action: {
                    logData.fetchData()
                    print("current logs: \(logData.logs)")
                }, label: {
                    Text("確認")
                        .frame(width: 100, height: 30)
                        .foregroundColor(.black)
                        .background(Color.orange)
                        .cornerRadius(15, antialiased: true)
                })
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.trailing, 10.0)
                .sheet(isPresented: self.$showSettingView, content: {
                    SettingView().environmentObject(msc)
                })
                Button(action: {
                    logData.deleteAll()
                }, label: {
                    Text("削除")
                        .frame(width: 100, height: 30)
                        .foregroundColor(.black)
                        .background(Color.orange)
                        .cornerRadius(15, antialiased: true)
                })
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.trailing, 10.0)
                .sheet(isPresented: self.$showSettingView, content: {
                    SettingView().environmentObject(msc)
                })
                Button(action: {
                    logData.removeDB()
                }, label: {
                    Text("初期化")
                        .frame(width: 100, height: 30)
                        .foregroundColor(.black)
                        .background(Color.orange)
                        .cornerRadius(15, antialiased: true)
                })
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.trailing, 10.0)
                .sheet(isPresented: self.$showSettingView, content: {
                    SettingView().environmentObject(msc)
                })
            }*/
            Spacer()
            VStack {
                Text("今回の使用時間")
                Text(label_current_time).padding(.top, 1.0)
            }.padding(.bottom, 20.0)
            
            VStack {
                Text("本日の総使用時間")
                Text(label_total_time).padding(.top, 1.0)
            }.padding(.bottom, 20.0)
            
            VStack {
                Text("本日のスマホ使用回数")
                Text(label_unlocked).padding(.top, 1.0)
                    
            }.padding(.bottom, 20.0)
            Spacer()
            VStack(alignment: .trailing) {
                Text(chiapon_message).frame(maxWidth: .infinity, alignment: .center)
                Image(image_name).frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        //アプリ終了時の処理
        .onReceive(pub_discard, perform: { _ in
            //アプリkill時の処理
            print("Terminated!")

            //メッセージ送信
            mnc.setTitle(str: "アプリが終了してしまいました")
            mnc.setBody(str: "このままでは正常に動作しません。\nアプリを開き直してね！")
            mnc.sendMessage()
            
            //シリアライズして保存
            serializeMTCC()
        })
        //位置情報更新時の処理
        //.onChange(of: self.location.userLocation, perform: { value in
        //    if let receivedUpdate = value {
        //        print(receivedUpdate)
        //        print("緯度: \(receivedUpdate.coordinate.latitude), 経度: \(receivedUpdate.coordinate.longitude)")
        //    }
        //})
        //タイマーの処理
        .onReceive(timer, perform: { time in
            updateAlways()
            label_current_time = "\(mtcc.formatSecToTime(seconds: Double(mtcc.timer_counter)))"
            label_total_time = "\(mtcc.getTodayUnLockedTime())"
            label_unlocked = "\(mtcc.unlockedcounter) 回"
            
            //countup()
            //print("カウント:\(counter), timer_counter: \(mtcc.timer_counter)")
            /*
            label_total_time = "\(counter)"
            if counter % 5 == 0 {
                mnc.setTitle(str: "\(counter)時間たったよ")
                mnc.setBody(str: chiapon_message)
                mnc.setImageName(str: image_name)
                mnc.sendMessage()
            }
            */
        })
        //アンロック時の処理
        .onReceive(pub_unlocked, perform: { _ in
            lockStatusChange(unlocked: true)
            //self.counter_unlocked = self.counter_unlocked + 1
            //label_unlocked = "Unlocked: \(counter_unlocked)"
        })
        //ロック時の処理
        .onReceive(pub_locked, perform: { _ in
            lockStatusChange(unlocked: false)
            //self.counter_locked = self.counter_locked + 1
            //label_locked = "Locked: \(counter_locked)"
        })
        //画面が生成表示されたタイミング実行される
        //@StateObjectはここで実行しないとワーニングが出る
        .onAppear(){
            logData.fetchData()
            if logData.logs.count > 0 {
                msc.userid = logData.logs[0].userid
                print("in logData userid chedk - true")
            }else{
                print("in logData userid chedk - false")
                msc.userid = UUID().uuidString
            }
            print("userid was identified as \(msc.userid)")
        }
    }
    
    /* ------------------------------------------------------ */
    /*  for initial settings                                  */
    /* ------------------------------------------------------ */
    mutating func initialSettings(){
        print("initial settings were called.")
        //アンシリアライズ
        unserializeMTCC()
        //基準日時の設定
        mtcc.standardtime = mtcc.getStandardTime(sdate: mtcc.starttime)
        //キューの設定(過去何回分をチェックするか: とりあえず4回)
        mtcc.unlock_queue.setmax(num: 4)
        //ユーザIDの設定
        

        
    }
    
    /* ------------------------------------------------------ */
    /*  for reset settings                                    */
    /* ------------------------------------------------------ */
    func resetSettings(){
        //mtccの各値をリセットする
        mtcc.starttime = Date()
        mtcc.nowtime = Date()
        mtcc.time_unlocked = Date()
        mtcc.time_locked = Date()
        mtcc.total_unlocked = 0.0
        mtcc.total_locked = 0.0
        mtcc.today_unlocked = 0.0
        mtcc.today_locked = 0.0
        mtcc.lockedtimeseconds  = 0.0
        mtcc.unlockedtimeseconds = 0.0
        mtcc.lockedduration = 0.0
        mtcc.unlockedduration = 0.0
        mtcc.unlockedcounter = 0
        mtcc.lockedcounter = 0
        mtcc.total_unlockedcounter = 0
        mtcc.total_lockedcounter = 0
        mtcc.timer_counter = 0
    }
    
    /* ------------------------------------------------------ */
    /*  for serializing                                       */
    /* ------------------------------------------------------ */
    func serializeMTCC(){
        guard let archiveData = try? NSKeyedArchiver.archivedData(withRootObject: mtcc, requiringSecureCoding: true) else {
            fatalError("Archive dailed")
        }
        userDefaultsData.set(archiveData, forKey: "mtcc_data")
        userDefaultsData.synchronize()
        //print("serealizing process was done.")
        //print(mtcc.unlockedcounter)
    }
    
    mutating func unserializeMTCC(){
        if let storedData = userDefaultsData.object(forKey: "mtcc_data") as? Data{
            if let unarchivedData = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(storedData) as? myTimeCalculationClass {
                mtcc = unarchivedData
                
                msc.username = mtcc.username
                if(msc.username != "no name"){
                    //buttonNameInput.isEnabled = false
                    //buttonNameInput.isHidden = true
                }
                //print("unserealizing was succeeded.")
                //print(mtcc.unlockedcounter)
            }
            
            //if let unarchivedData = try? NSKeyedUnarchiver.unarchivedObject(ofClass: myTimeCalculationClass.self, from: storedData){
            //    mtcc = unarchivedData
            //}
            
        }
        
        //print("unserealizing process was done.")
    }
    
    /* ------------------------------------------------------ */
    /*  Realmに追加                                            */
    /* ------------------------------------------------------ */
    func addLog(message: String = "", locked: Bool = false, unlocked: Bool = false, current_usagetime: Double = 0.0){
        //日時の生成
        let f = DateFormatter()
        //f.dateStyle = .short
        //f.timeStyle = .medium
        f.dateFormat = "yyyyMMddHHmmss"
        let now: Date = Date()
        //Relamに追加
        let tmplog: Log = Log()
        tmplog.id = Int(now.timeIntervalSince1970 * 1000)
        tmplog.timestamp = now.timeIntervalSince1970
        tmplog.day = f.string(from: now)
        tmplog.userid = msc.userid
        tmplog.username = msc.username
        tmplog.locked = locked
        tmplog.unlocked = unlocked
        //ロック時には利用時間、アンロック時には利用しなかった時間
        tmplog.current_usagetime = current_usagetime
        tmplog.message = message
        tmplog.chiapon = msc.chiapon
        tmplog.type = msc.type
        logData.addData(addlog: tmplog)
    }
    
    /* ------------------------------------------------------ */
    /*  firestoreに追加                                        */
    /* ------------------------------------------------------ */
    func addLogFirestore(message: String = "", locked: Bool = false, unlocked: Bool = false, current_usagetime: Double = 0.0){
        //日時の生成
        let f = DateFormatter()
        //f.dateStyle = .short
        //f.timeStyle = .medium
        f.dateFormat = "yyyyMMddHHmmss"
        let now: Date = Date()
        //Firestoreに追加
        let tmplog: Log = Log()
        tmplog.id = Int(now.timeIntervalSince1970 * 1000)
        tmplog.timestamp = now.timeIntervalSince1970
        tmplog.day = f.string(from: now)
        tmplog.userid = msc.userid
        tmplog.username = msc.username
        tmplog.locked = locked
        tmplog.unlocked = unlocked
        //ロック時には利用時間、アンロック時には利用しなかった時間
        tmplog.current_usagetime = current_usagetime
        tmplog.message = message
        tmplog.chiapon = msc.chiapon
        tmplog.type = msc.type
        logData.addFirestore(addlog: tmplog)
    }
    
    /* ------------------------------------------------------ */
    /*  1秒毎に繰り返されるループ                                  */
    /* ------------------------------------------------------ */
    func updateAlways(){
        
        //現在のアンロック時間の処理
        if flag_unlocked {
            mtcc.timer_counter += 1
            
            //表示
            //showDisplayStrings()
            
            //30分ごとに通知
            if mtcc.timer_counter % 1800 == 0 {
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
                mnc.setTitle(str: "\(mtcc.timer_counter / 60)分も経ったぞ！")
                //mnc.body = "そんなに使ったら電池減っちゃうよ😣使わないように頑張って！"
                mnc.setBody(str: message)
                mnc.setImageName(str: "emptiness")
                mnc.sendMessage()
                chiapon_message = message
                image_name = "emptiness"
                
                //Realmに追加
                msc.type = "continued"
                addLog(message: chiapon_message)
                addLogFirestore(message: chiapon_message)
                
                //addDataToFirestore(deviceid: deviceid, messageid: 4, message: mnc.body)
            }
            
            //回数による処理
            //アンロック時ではうまくいかないので、アンロックした後2秒経過後に出す（多分確実に見るタイミング）
            if mtcc.timer_counter == 2 {
                //回数メッセージの送信：５０回が平均？（ロック解除は２３回）１時
                //https://www.countand1.com/2017/05/smartphone-usage-48-and-apps-usage-90-per-day.html
                //if self.mtcc.unlockedcounter != 0 && self.mtcc.unlockedcounter % 10 == 0 && self.mtcc.unlockedcounter <= 50 {
                //1時間に3回がヘビーユーザと定義、4回前のアンロックが１時間以内かつ最新が20分以内にあれば出す
                if !mtcc.unlock_queue.isEmpty && mtcc.unlock_queue.count >= 4{
                    var diff_front = 3601.0
                    var diff_last = 3601.0
                    //queueの先頭の時刻と現在時刻との差を算出する
                    if !mtcc.unlock_queue.isEmpty {
                        diff_front = mtcc.getNowSeconds() - mtcc.unlock_queue.front!
                    }
                    if !mtcc.unlock_queue.isEmpty{
                        diff_last = mtcc.getNowSeconds() - mtcc.unlock_queue.last!
                    }
                    //qqueueの最後尾から2個目（前回起動）の時刻と現在時刻との差を算出する
                    //差が１時間＝60*60秒＝3600秒未満であればメッセージを出す
                    if diff_front <= 3600  && diff_last <= 1200 {
                        
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
                        mnc.setTitle(str: "これでもう\(self.mtcc.unlockedcounter)回目だぞ！")
                        mnc.setBody(str: message)
                        mnc.setImageName(str: "emptiness")
                        mnc.sendMessage()
                        chiapon_message = message
                        image_name = "emptiness"
                        
                        //Realmに追加
                        msc.type = "unlocked"
                        addLog(message: chiapon_message)
                        addLogFirestore(message: chiapon_message)
                        
                        //addDataToFirestore(deviceid: deviceid, messageid: 2, message: mnc.body)
                    }
                }
            }
        }
        
        //定時コメントの処理
        msc.type = "scheduled"  //scheduledに戻しておく
        //7:00
        if(mtcc.getNowTime() == morning){
            //バッジ表示
            UIApplication.shared.applicationIconBadgeNumber = 1
            //通知メッセージのセット
            let message = mnm.getCommnet(comments: mnm.cheerpon_Morning)
            mnc.setTitle(str: NSString.localizedUserNotificationString(forKey: "おはよう☀️今日も1日頑張ろう！", arguments: nil))
            mnc.setBody(str: NSString.localizedUserNotificationString(forKey: message, arguments: nil))
            mnc.setImageName(str: "normal")
            mnc.sendMessage()
            chiapon_message = message
            image_name = "normal"
            
            //Realmに追加
            addLog(message: chiapon_message)
            addLogFirestore(message: chiapon_message)
            
            //addDataToFirestore(deviceid: deviceid, messageid: 1, message: mnc.body)
        }
        
        //12:00
        if(mtcc.getNowTime() == afternoon){
            //バッジ表示
            UIApplication.shared.applicationIconBadgeNumber = 1
            //通知メッセージのセット
            let message = mnm.getCommnet(comments: mnm.cheerpon_AfterNoon)
            mnc.setTitle(str: NSString.localizedUserNotificationString(forKey: "お昼の時間だね🕛", arguments: nil))
            mnc.setBody(str: NSString.localizedUserNotificationString(forKey: message, arguments: nil))
            mnc.setImageName(str: "normal")
            mnc.sendMessage()
            chiapon_message = message
            image_name = "normal"
            
            //Realmに追加
            addLog(message: chiapon_message)
            addLogFirestore(message: chiapon_message)
            
            //addDataToFirestore(deviceid: deviceid, messageid: 1, message: mnc.body)
        }
        
        //22:00
        if(mtcc.getNowTime() == night){
            //バッジ表示
            UIApplication.shared.applicationIconBadgeNumber = 1
            //通知メッセージのセット
            let message = mnm.getCommnet(comments: mnm.cheerpon_Night)
            mnc.setTitle(str: NSString.localizedUserNotificationString(forKey: "もうこんな時間💦", arguments: nil))
            mnc.setBody(str: NSString.localizedUserNotificationString(forKey: message, arguments: nil))
            mnc.setImageName(str: "normal")
            mnc.sendMessage()
            chiapon_message = message
            image_name = "emptiness"
            
            //Realmに追加
            addLog(message: chiapon_message)
            addLogFirestore(message: chiapon_message)
            
            //addDataToFirestore(deviceid: deviceid, messageid: 1, message: mnc.body)
        }
        
        //23:59:59
        if(mtcc.getNowTime() == "235959"){
            //その日の集計を送る
            //addDataToFirestore(deviceid: deviceid, messageid: 6, message: "本日の集計結果")
            //翌日の定時メッセージ時刻の決定
            var hour: Int
            var minute: Int
            //morning 7:00 - 8:30
            hour = Int.random(in: 7...8)
            morning = "0" + String(hour)
            if hour == 7 {
                minute = Int.random(in: 0...59)
            }else{
                minute = Int.random(in: 0...30)
            }
            if minute < 10 {
                morning += "0" + String(minute) + "00"
            }else{
                morning += String(minute) + "00"
            }
            //afternoon 12:00 - 13:30
            hour = Int.random(in: 12...13)
            afternoon = String(hour)
            if hour == 12 {
                minute = Int.random(in: 0...59)
            }else{
                minute = Int.random(in: 0...30)
            }
            if minute < 10 {
                afternoon += "0" + String(minute) + "00"
            }else{
                afternoon += String(minute) + "00"
            }
            //night  22:00 - 22:30
            hour = Int.random(in: 22...23)
            night = String(hour)
            if hour == 22 {
                minute = Int.random(in: 0...59)
            }else{
                minute = Int.random(in: 0...30)
            }
            if minute < 10 {
                night += "0" + String(minute) + "00"
            }else{
                night += String(minute) + "00"
            }
        }
        
        //print("lock: " + String(mtcc.lockcounter))
        //print("unlock: " + String(mtcc.unlockcounter))
        
        //実験のため、毎秒シリアライズして保存する
        serializeMTCC()
    }
    
    /* ------------------------------------------------------ */
    /*  ロック/アンロックの処理                                   */
    /* ------------------------------------------------------ */
    func lockStatusChange(unlocked: Bool){
        if unlocked {
            //ロック解除された時の処理
            mtcc.setUnLocked()
            addLog(unlocked: true, current_usagetime: mtcc.lockedduration)
            addLogFirestore(unlocked: true, current_usagetime: mtcc.lockedduration)
        }else{
            //ロックされた時の処理
            mtcc.setLocked()
            mtcc.timer_counter = 0
            addLog(locked: true, current_usagetime: mtcc.unlockedduration)
            addLogFirestore(locked: true, current_usagetime: mtcc.unlockedduration)
            
        }
        
        flag_unlocked = unlocked
    }
    
    
    //func countup(){
    //    self.counter = self.counter + 1
    //}
    
}

//キーボードを閉じる
extension UIApplication {
    func closeKeyboard(){
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


/* ------------------------------------------------------ */
/*  for location management                               */
/* ------------------------------------------------------ */
/*

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var userLocation: CLLocation?
    
    let locationManager = CLLocationManager()
    
    init(accuracy: CLLocationAccuracy){
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.desiredAccuracy = accuracy
            locationManager.distanceFilter = 9999
            locationManager.allowsBackgroundLocationUpdates = true //バックグラウンド処理を可能にする
            locationManager.pausesLocationUpdatesAutomatically = false //ポーズしても位置取得を続ける
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        guard let newLocation = locations.last else {
            return
        }
        self.userLocation = newLocation
        //let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude)
        //print("緯度: ", location.latitude, "経度: ", location.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print(error.localizedDescription)
        }
}
*/
