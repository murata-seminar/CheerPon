//
//  myNotificationClass.swift
//  CHIAPON3
//
//  Created by kmurata on 2021/02/16.
//

import Foundation
import UserNotifications

class myNotificationClass {
    private var title: String = "title"
    private var body: String = "body"
    private var sound: UNNotificationSound = UNNotificationSound.default
    private var image_name: String = "normal"
    
    func sendMessage(){
        print("sendMessage")
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = sound
        
        //メッセージ毎に一意に決まるidentifierを生成: 現在時刻をもとに生成する
        let id = "\(Date().timeIntervalSince1970)"
        let image_id = "\(Date().timeIntervalSince1970)"
        
        //imageの処理
        // Bundle.main.urlメソッドでは、Assets.xcassets内の画像にアクセスできないので、フォルダに画像を直接追加する必要あり。
        // http://www.purple-flamingo.co/?p=72
        if let imageurl = Bundle.main.url(forResource: image_name, withExtension: "jpg"), let imageAttachment = try? UNNotificationAttachment(identifier: image_id, url: imageurl, options: nil) {
            content.attachments.append(imageAttachment)
        }

        
        // Send message immedeately
        let request = UNNotificationRequest(identifier: id, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        print("sendMessage done.")
    }
    
    func setTitle(str: String) {
        title = str
    }
    
    func setBody(str: String) {
        body = str
    }
    
    func setImageName(str: String) {
        image_name = str
    }
}

