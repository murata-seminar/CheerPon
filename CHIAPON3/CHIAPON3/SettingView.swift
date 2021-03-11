//
//  SettingView.swift
//  CHIAPON3
//
//  Created by kmurata on 2021/02/18.
//

import SwiftUI
import Foundation

struct SettingView: View {

    //キャラクタ名
    @EnvironmentObject var msc: mySettingClass
    
    //閉じるボタン用
    @Environment(\.presentationMode) var presentationMode
    
    //Realmの処理
    @StateObject var logData: LogViewModel = LogViewModel()

    var body: some View {
        NavigationView{
            List {
                NavigationLink(
                    destination: NameSettingView(),
                    label: {
                        Text("キャラクタ名の設定：\(msc.username)")
                    })
                NavigationLink(
                    destination: OnGoingView(),
                    label: {
                        Text("実験用（記録）: ")
                    })
                /*
                Button(action: {
                    //最初にデータをポスト
                    //postData()
                    //そのあとアンケートサイトを開く
                    if let url = URL(string: "https://muratalab.si.aoyama.ac.jp/dev/chiapon3/receive.php"){
                        UIApplication.shared.open(url, completionHandler: {completed in
                            print(completed)
                        })
                    }
                }) {
                    Text("アンケート回答（外部サイトへ進む）")
                }
                 */
                //Text("アンケート回答（外部サイトへ")
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    HStack {
                        Spacer()
                        Text("この画面を閉じる").foregroundColor(Color.blue)
                    }
                })
            }.navigationTitle("設定")
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
