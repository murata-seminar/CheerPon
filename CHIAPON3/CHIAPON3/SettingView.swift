//
//  SettingView.swift
//  CHIAPON3
//
//  Created by kmurata on 2021/02/18.
//

import SwiftUI

struct SettingView: View {

    //キャラクタ名
    @EnvironmentObject var msc: mySettingClass

    var body: some View {
        NavigationView{
            List {
                NavigationLink(
                    destination: NameSettingView(),
                    label: {
                        Text("キャラクタ名の設定：\(msc.username)")
                    })
                Text("実験用（記録）: ")
                Text("アンケート回答（外部サイトへ")
            }.navigationTitle("設定")
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
