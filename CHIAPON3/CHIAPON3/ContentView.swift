//
//  ContentView.swift
//  CHIAPON3
//
//  Created by kmurata on 2021/02/15.
//

import SwiftUI

struct ContentView: View {
    
    var mnc: myNotificationClass = myNotificationClass()
    
    @State var chiapon_message: String = "スマホの使用状況に応じて、\nアドバイスしてやってもいいぜ。\nたまには見に来いよ。"
    @State var label_current_time: String = "current time"
    @State var label_total_time: String = "total time"
    @State var label_unlocked: String = "Unlocked: 0"
    @State var label_locked: String = "Locked: 0"
    @State var counter_unlocked: Int = 0
    @State var counter_locked: Int = 0
    
    @State var image_name: String = "cheer"
    
    @State var counter: Int = 0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    let pub_unlocked = NotificationCenter.default.publisher(for: UIApplication.protectedDataDidBecomeAvailableNotification)
    let pub_locked = NotificationCenter.default.publisher(for: UIApplication.protectedDataWillBecomeUnavailableNotification)
    let pub_terminate = NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)
    var body: some View {
        VStack {
            Spacer()
            VStack {
                Text("今回の使用時間")
                Text(label_current_time).padding(.top, 1.0)
                    .onReceive(timer, perform: { time in
                        label_current_time = "\(time)"
                        countup()
                        label_total_time = "\(counter)"
                        if counter % 5 == 0 {
                            mnc.setTitle(str: "\(counter)時間たったよ")
                            mnc.setBody(str: chiapon_message)
                            mnc.setImageName(str: image_name)
                            mnc.sendMessage()
                        }
                })
            }.padding(.bottom, 20.0)
            
            VStack {
                Text("本日の総使用時間")
                Text(label_total_time).padding(.top, 1.0)
            }.padding(.bottom, 20.0)
            
            VStack {
                Text("本日のスマホ使用回数")
                Text(label_unlocked).padding(.top, 1.0)
                    .onReceive(pub_unlocked, perform: { _ in
                        self.counter_unlocked = self.counter_unlocked + 1
                        label_unlocked = "Unlocked: \(counter_unlocked)"
                    })
                    .onReceive(pub_locked, perform: { _ in
                        self.counter_locked = self.counter_locked + 1
                        label_locked = "Locked: \(counter_locked)"
                    })
            }.padding(.bottom, 20.0)
            Spacer()
            VStack(alignment: .trailing) {
                Text(chiapon_message).frame(maxWidth: .infinity, alignment: .center)
                Image(image_name).frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        //アプリkill時の処理
        .onReceive(pub_terminate, perform: { _ in
            //メッセージ送信
            mnc.setTitle(str: "アプリが終了してしまいました")
            mnc.setBody(str: "このままでは正常に動作しません。\nアプリを開き直してね！")
            mnc.sendMessage()
            print("Terminated!")
        })
    }
    
    func countup(){
        self.counter = self.counter + 1
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
