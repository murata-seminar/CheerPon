//
//  myNotificationClass.swift
//  LockUnLockTest
//
//  Created by kmurata on 2020/02/07.
//  Copyright © 2020 kmurata seminar. All rights reserved.
//

import Foundation
import UserNotifications

class myNotificationClass{
    //プロパティ
    var title: String = "title"
    var body: String  = "本文"
    var sound: UNNotificationSound = UNNotificationSound.default
    var timer: TimeInterval = 0.1 //0はダメらしい
    var imagename: String = "normal"
    
    //通知処理
    func sendMessage(){
        print("ログ通知処理")
        //トリガーの設定
        let trigger: UNNotificationTrigger
        trigger = UNTimeIntervalNotificationTrigger(timeInterval: timer, repeats: false)
        //通知内容の設定
        let content = UNMutableNotificationContent()
        //通知のメッセージセット
        content.title = self.title
        content.body = self.body
        content.sound = self.sound
        //identifierを作る
        //UNIXタイムを使う
        let current = "\(Date().timeIntervalSince1970)"
        let current_image = "\(Date().timeIntervalSince1970)"
        
        //画像の処理
        if let imageurl = Bundle.main.url(forResource: imagename, withExtension: "jpg"), let imageAttachment = try? UNNotificationAttachment(identifier: current_image, url: imageurl, options: nil){
            content.attachments.append(imageAttachment)
            print("iamge icon was created.")
        }
        
        //通知スタイルを指定
        let request = UNNotificationRequest(identifier: current, content: content, trigger: trigger)
        print("設定")
        //通知をセット
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        print("送信:" + current + ": " + content.body)
    }
    
    //画像の処理
    func setImage(status: String){
        imagename = status
    }
    
    //24時に通知
    //    func sendMessage24h(){
    //        var notificationTime = DateComponents()
    //        let trigger24: UNNotificationTrigger
    //
    //        // トリガー設定
    //        notificationTime.hour = 0
    //        notificationTime.minute = 0
    //        trigger24 = UNCalendarNotificationTrigger(dateMatching: notificationTime, repeats: false)
    //
    //        let content24 = UNMutableNotificationContent()
    //
    //        //通知のメッセージセット
    //        content24.title = self.title
    //        content24.body = self.body
    //        content24.sound = self.sound
    //        //通知スタイルを指定
    //        let request24 = UNNotificationRequest(identifier: "tapNotificationButton", content: content24, trigger: trigger24)
    //
    //        //通知をセット
    //        UNUserNotificationCenter.current().add(request24, withCompletionHandler: nil)
    //
    //    }
    
    
}


