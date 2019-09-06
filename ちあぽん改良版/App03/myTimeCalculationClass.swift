
//
//  myTimeCalculationClass.swift
//  YakoOnOff03
//
//  Created by kmurata on 2018/11/30.
//  Copyright © 2018 Reina Yako. All rights reserved.
//  ちあぽん改良版
//

import Foundation

class myTimeCalculationClass {
    //時刻関係の変数
    let starttime: Date = Date()  //起動時刻
    var nowtime: Date = Date() //現在時刻（とりあえず起動時刻を入れておく）
    var lightontime: Date = Date() //ライトがついた時刻（とりあえず起動時刻を入れておく）
    var lightofftime: Date = Date()  //ライトが消えた時刻（とりあえず起動時刻を入れておく）
    var total_ontime = 0.0 //アプリ起動後、ライトがついていた（使っていた）累積時間
    var total_offtime = 0.0 //アプリ起動後、ライトが消えていた（使っていなかった）累積時間
    
    var lightofftimeseconds:Double = 0
    var lightontimeseconds:Double = 0
    var offduration:Double = 0
    var onduration:Double = 0
    
    //カウンター
    var oncounter:Int = 0
    var offcounter:Int = 0
    

    
    //ここから基準日の話
    //次の日の0:00用の日付
    var standardtime: Date = Date()
    
    //イニシャライザ（コンストラクタ）
    init(){
        //基準日時を作る
        standardtime = self.getStandardTime(sdate: starttime)
    }

    //基準日時を作る
    //Date型の変数を受けとって、その日の0:00:00を返す
    func getStandardTime(sdate: Date) -> Date {
        let calendar = Calendar.current
        let year: Int = calendar.component(.year, from: sdate)
        let month: Int = calendar.component(.month, from: sdate)
        let day: Int = calendar.component(.day, from: sdate)
        let d = calendar.date(from: DateComponents(year: year, month: month, day: day, hour: 0, minute: 0, second: 0))
        //let d = calendar.date(from: DateComponents(year: year, month: month, day: day - 1, hour: 14, minute: 50, second: 0))    //テスト用
        
        return d!
    }
    
    //カウンターと累積時間をリセットする
    func resetCheck(now: Date){
        //引数の時間と基準時刻を比較して、86400より大きい場合、次の日（もしくはそれ以上）になったとみなす
        //時間差を計算
        let elapsedtime = now.timeIntervalSince(standardtime)
        //時間差が86400以上であればリセット（24時間）
        if(elapsedtime >= 86400){
            oncounter = 0       //オンになった回数
            offcounter = 0     //使ってない
            lightontimeseconds = 0      //使ってない
            lightofftimeseconds = 0     //使ってない
            elapsedTime = 0     //累積時間
            
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
    
    //18:48かどうかを調べる
    func isAfterNoon() -> Bool {
        let now = Date()
        let calendar = Calendar.current
        let hour:Int = calendar.component(.hour, from: now)
        let minute:Int = calendar.component(.minute, from: now)
        let second:Int = calendar.component(.second, from: now)
        if(hour == 18 && minute == 48 && second == 0 ){
            return true
        }else{
            return false
        }
    }
    
    //23:50かどうかを調べる
    func isMidNight() -> Bool {
        let now = Date()
        let calendar = Calendar.current
        let hour:Int = calendar.component(.hour, from: now)
        let minute:Int = calendar.component(.minute, from: now)
        let second:Int = calendar.component(.second, from: now)
        if(hour == 23 && minute == 50 && second == 0 ){
            return true
        }else{
            return false
        }
    }
    
    //00:00かどうか確かめる
    func isMidNight2() -> Bool {
        let now = Date()
        let calendar = Calendar.current
        let hour:Int = calendar.component(.hour, from: now)
        let minute:Int = calendar.component(.minute, from: now)
        let second:Int = calendar.component(.second, from: now)
        if(hour == 0 && minute == 0 && second == 0 ){
            return true
        }else{
            return false
        }
    }
    
    //夜時間帯かどうかを調べる
    //現在時刻が22:00から23:59であれば true, それ以外であればfalseを返す
    func isJuujiTime() -> Bool {
        let now = Date()
        let calendar = Calendar.current
        let hour:Int = calendar.component(.hour, from: now)
        
        if(hour >= 22 && hour < 24){
            return true
        }else{
            return false
        }
    }
    
    //深夜時間帯かどうかを調べる
    //現在時刻が0:01から3:59であれば true, それ以外であればfalseを返す
    func isNightTime() -> Bool {
        let now = Date()
        let calendar = Calendar.current
        let hour:Int = calendar.component(.hour, from: now)
        
        if(hour >= 0 && hour < 4){
            return true
        }else{
            return false
        }
        
    }
    
    //画面がついた時刻をセット
    func setLightOn(){
        lightontime = Date()
        //今使っていなかった時間（画面が消えていた時間＝直近の画面が消えた時間から何秒たったか）を計算する
        lightofftimeseconds = lightontime.timeIntervalSince1970
        lightontimeseconds = lightofftime.timeIntervalSince1970
        offduration = lightofftimeseconds - lightontimeseconds
        //画面が消えていた時間を累積ライト消えていた時間に追加
        total_offtime = total_offtime + offduration
        //画面がついた回数を増やす
        oncounter = oncounter + 1
        //リセットのチェック
        self.resetCheck(now: lightontime)
        
    }
    
    //画面が消えた時刻をセット
    func setLightOff(){
        lightofftime = Date()
        //今使っていた時間（画面がついていた時間＝直近のライトがついた時間から何秒たったか）を計算する
        lightontimeseconds = lightontime.timeIntervalSince1970
        lightofftimeseconds = lightofftime.timeIntervalSince1970
        onduration = lightofftimeseconds - lightontimeseconds
        //画面がついていた時間を累積ライト点灯時間に追加
        total_ontime = total_ontime + onduration
        //画面が消えた回数を増やす
        offcounter = offcounter + 1
        //リセットのチェック
        //self.resetCheck(now: lightofftime)
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


