//
//  myTimeCalculationClass.swift
//  LockUnLockTest
//
//  Created by kmurata on 2020/02/07.
//  Copyright © 2020 kmurata seminar. All rights reserved.
//

import Foundation

class myTimeCalculationClass: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    
    //時刻関係の変数
    var starttime: Date = Date()  //起動時刻
    var nowtime: Date = Date() //現在時刻（とりあえず起動時刻を入れておく）
    var time_unlocked: Date = Date() //アンロックされた時刻（とりあえず起動時刻を入れておく）
    var time_locked: Date = Date()  //ロックされた時刻（とりあえず起動時刻を入れておく）
    var total_unlocked: Double = 0.0 //アプリ起動後、アンロックされていた（使っていた）累積時間
    var total_locked: Double = 0.0 //アプリ起動後、ロックされていた（使っていなかった）累積時間
    var today_unlocked: Double = 0.0    //当日のアンロック時間
    var today_locked: Double = 0.0      //当日のロック時間
    
    var lockedtimeseconds:Double = 0
    var unlockedtimeseconds:Double = 0
    var lockedduration:Double = 0  //直近のロックされていた時間
    var unlockedduration:Double = 0   //直近のアンロックされていた時間
    
    //カウンター
    var unlockedcounter:Int = 0
    var lockedcounter:Int = 0
    var total_unlockedcounter:Int = 0   //前日までの累積アンロック回数
    var total_lockedcounter:Int = 0     //前日までの累積ロック回数
    var timer_counter: Int = 0
    
    //ユーザ名保存用
    var username: String = "no name"

    //ユーザ名の保存
    func setUserName(name: String){
        username = name
    }
    
    //ここから基準日の話
    //次の日の0:00用の日付
    var standardtime: Date = Date()
    
    //イニシャライザ（コンストラクタ）
    override init(){
        //基準日時を作る ←これはViewDidLoadで呼び出すinitSettingsで行う
        //standardtime = self.getStandardTime(sdate: starttime)
    }
    
    //シリアライズ用
    required init?(coder: NSCoder) {
        //デコードするときはそれぞれ型専用のデコードメソッドを使う

        starttime = (coder.decodeObject(forKey: "starttime") as? Date)!
        nowtime = (coder.decodeObject(forKey: "nowtime") as? Date)!
        time_unlocked = (coder.decodeObject(forKey: "time_unlocked") as? Date)!
        time_locked = (coder.decodeObject(forKey: "time_locked") as? Date)!
        total_unlocked = coder.decodeDouble(forKey: "total_unlocked") as Double
        total_locked = coder.decodeDouble(forKey: "total_locked") as Double
        today_unlocked = coder.decodeDouble(forKey: "today_unlocked") as Double
        today_locked = coder.decodeDouble(forKey: "today_locked") as Double
        lockedtimeseconds = coder.decodeDouble(forKey: "lockedtimeseconds") as Double
        unlockedtimeseconds = coder.decodeDouble(forKey: "unlockedtimeseconds") as Double
        lockedduration = coder.decodeDouble(forKey: "lockedduration") as Double
        unlockedduration = coder.decodeDouble(forKey: "unlockedduration") as Double
        unlockedcounter = coder.decodeInteger(forKey: "unlockedcounter") as Int
        lockedcounter = coder.decodeInteger(forKey: "lockedcounter") as Int
        total_unlockedcounter = coder.decodeInteger(forKey: "total_unlockedcounter") as Int
        total_lockedcounter = coder.decodeInteger(forKey: "total_lockedcounter") as Int
        timer_counter = coder.decodeInteger(forKey: "timer_counter") as Int
        username = coder.decodeObject(forKey: "username") as? String ?? "no name"
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(starttime, forKey: "starttime")
        coder.encode(nowtime, forKey: "nowtime")
        coder.encode(time_unlocked, forKey: "time_unlocked")
        coder.encode(time_locked, forKey: "time_locked")
        coder.encode(total_unlocked, forKey: "total_unlocked")
        coder.encode(total_locked, forKey: "total_locked")
        coder.encode(today_unlocked, forKey: "today_unlocked")
        coder.encode(today_locked, forKey: "today_locked")
        coder.encode(lockedtimeseconds, forKey: "lockedtimeseconds")
        coder.encode(unlockedtimeseconds, forKey: "unlockedtimeseconds")
        coder.encode(lockedduration, forKey: "lockedduration")
        coder.encode(unlockedduration, forKey: "unlockedduration")
        coder.encode(unlockedcounter, forKey: "unlockedcounter")
        coder.encode(lockedcounter, forKey: "lockedcounter")
        coder.encode(total_unlockedcounter, forKey: "total_unlockedcounter")
        coder.encode(total_lockedcounter, forKey: "total_lockedcounter")
        coder.encode(timer_counter, forKey: "timer_counter")
        coder.encode(username, forKey: "username")
        
        //print("finish encode.")
    }

    //基準日時を作る
    //Date型の変数を受けとって、その日の0:00:00を返す
    func getStandardTime(sdate: Date) -> Date {
        let calendar = Calendar.current
        let year: Int = calendar.component(.year, from: sdate)
        let month: Int = calendar.component(.month, from: sdate)
        let day: Int = calendar.component(.day, from: sdate)
        let d = calendar.date(from: DateComponents(year: year, month: month, day: day, hour: 0, minute: 0, second: 0)) ?? sdate
        //let d = calendar.date(from: DateComponents(year: year, month: month, day: day - 1, hour: 14, minute: 50, second: 0))    //テスト用
        
        return d
    }
    
    //カウンターと累積時間をリセットする
    func resetCheck(now: Date){
        //引数の時間と基準時刻を比較して、86400より大きい場合、次の日（もしくはそれ以上）になったとみなす
        //時間差を計算
        var elapsedtime = now.timeIntervalSince(standardtime)
        //時間差が86400以上であればリセット（24時間）
        if(elapsedtime >= 86400){
            unlockedcounter = 0       //ロック回数
            lockedcounter = 0     //アンロック回数
            unlockedtimeseconds = 0
            lockedtimeseconds = 0
            //elapsed_time = 0     //累積時間
            while elapsedtime >= 86400 {
                elapsedtime -= 86400
            }
            today_unlocked = 0.0
            today_locked = elapsedtime
            
            //基準時刻を更新する
            standardtime = getStandardTime(sdate: now)
        }
        
    }
    
    
    //現在時刻
    func getNowDate() -> String {
        nowtime = Date()
        //let nowseconds = nowtime.timeIntervalSince1970
        let nowtimestring = formatDate(seconds: nowtime) //現在時刻を文字列に直す
        return nowtimestring
    }
    
    //現在時刻(時間だけ)
    func getNowTime() -> String {
        nowtime = Date()
        //let nowseconds = nowtime.timeIntervalSince1970
        let nowtimestring = formatTime(seconds: nowtime) //現在時刻を文字列に直す
        return nowtimestring
    }
    
    //現在時刻を1970.1.1からの経過秒数で返す
    func getNowSeconds() -> Double {
        nowtime = Date()
        let nowseconds = nowtime.timeIntervalSince1970
        return nowseconds
    }
    
    //アプリ起動からの経過時間
    func getTotalSeconds() -> Double {
        //現在時刻を取得する
        nowtime = Date()
        let nowseconds = nowtime.timeIntervalSince1970
        let startseconds = starttime.timeIntervalSince1970
        //起動してから何分経ったかを計算する
        return (nowseconds - startseconds)
    }
    
    //7:00かどうかを調べる
    func isMorning() -> Bool {
        let now = Date()
        let calendar = Calendar.current
        let hour:Int = calendar.component(.hour, from: now)
        let minute:Int = calendar.component(.minute, from: now)
        let second:Int = calendar.component(.second, from: now)
        if(hour == 7 && minute == 0 && second == 0 ){
            return true
        }else{
            return false
        }
    }
    
    //正午かどうかを調べる
    func isNoon() -> Bool {
        let now = Date()
        let calendar = Calendar.current
        let hour:Int = calendar.component(.hour, from: now)
        let minute:Int = calendar.component(.minute, from: now)
        let second:Int = calendar.component(.second, from: now)
        if(hour == 12 && minute == 0 && second == 0 ){
            return true
        }else{
            return false
        }
    }
    
    //時間帯を調べる
    //現在時刻が22:00から23:59であれば true, それ以外であればfalseを返す
    func checkTime(from: Int, to: Int) -> Bool {
        let now = Date()
        let calendar = Calendar.current
        let hour:Int = calendar.component(.hour, from: now)
        
        if(hour >= from && hour < to){
            return true
        }else{
            return false
        }
    }
    
    
    //アンロックされた時刻をセット
    func setUnLocked(){
        time_unlocked = Date()
        //今使っていなかった時間（ロックされていた時間＝直近のロックされた時間から何秒たったか）を計算する
        lockedtimeseconds = time_unlocked.timeIntervalSince1970
        unlockedtimeseconds = time_locked.timeIntervalSince1970
        lockedduration = lockedtimeseconds - unlockedtimeseconds
        //ロックされていた時間を累積ロック時間に追加
        total_locked = total_locked + lockedduration
        today_locked = today_locked + lockedduration
        //アンロックされた回数を増やす
        unlockedcounter = unlockedcounter + 1
        total_unlockedcounter = total_unlockedcounter + 1
        //リセットのチェック
        self.resetCheck(now: time_unlocked)
        
    }
    
    //ロックされた時刻をセット
    func setLocked(){
        time_locked = Date()
        //今使っていた時間（アンロックされていた時間＝直近のアンロックされた時間から何秒たったか）を計算する
        unlockedtimeseconds = time_unlocked.timeIntervalSince1970
        lockedtimeseconds = time_locked.timeIntervalSince1970
        unlockedduration = lockedtimeseconds - unlockedtimeseconds
        //アンロックされていた時間を累積アンロック時間に追加_
        total_unlocked = total_unlocked + unlockedduration
        today_unlocked = today_unlocked + unlockedduration
        //ロックされた回数を増やす
        lockedcounter = lockedcounter + 1
        total_lockedcounter = total_lockedcounter + 1
        //リセットのチェック
        //self.resetCheck(now: lightofftime)
    }
    

    //秒を時間に治す
    func formatSecToTime(seconds: Double) -> String{
        let int_seconds: Int = Int(seconds)
        let s: Int = int_seconds % 60
        let m: Int = (int_seconds % 3600) / 60
        let h: Int = int_seconds / 3600
        let time = NSString(format: "%02d時間%02d分%02d秒", h, m, s) as String

        return time
    }
    
    //累積アンロック時間をかえす
    func getTotalUnLockedTime() -> String{
        return formatSecToTime(seconds: total_unlocked)
    }
    
    //累積ロック時間をかえす
    func getTotalLockedTime() -> String{
        return formatSecToTime(seconds: total_locked)
    }
    
    //本日のアンロック時間をかえす
    func getTodayUnLockedTime() -> String{
        let today_total_unlockedtime = today_unlocked + Double(timer_counter)
        return formatSecToTime(seconds: today_total_unlockedtime)
    }
    //本日のロック時間をかえす
    func getTodayLockedTime() -> String{
        return formatSecToTime(seconds: today_locked)
    }
    
    //時刻形式を整える
    func formatDate(seconds: Date) -> String {
        //フォーマット形式を設定
        let format = DateFormatter()
        format.dateFormat = "yyyy/MM/dd HH:mm:ss"
        //引数secondsをフォーマットして戻す
        return format.string(from: seconds)
    }
    
    func formatTime(seconds: Date) -> String{
        //フォーマット形式を設定
        let format = DateFormatter()
        //format.dateStyle = .none
        //format.timeStyle = .medium
        format.dateFormat = "HHmmss"
        //引数secondsをフォーマットして戻す
        return format.string(from: seconds)
    }
    
}


