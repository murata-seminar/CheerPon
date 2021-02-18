//
//  NameSettingView.swift
//  CHIAPON3
//
//  Created by kmurata on 2021/02/18.
//

import SwiftUI

struct NameSettingView: View {
    
    @Environment(\.presentationMode) var presentation
    @EnvironmentObject var msc: mySettingClass
    @State var tmp_string: String = ""
    
    var body: some View {
        VStack{
            Text("キャラクタ名を入力し、\n決定ボタンをタップしてください")
                .frame(alignment: .center)
                .padding(.init(top: 10, leading: 20, bottom: 10, trailing: 20))
            TextField(msc.username, text: $tmp_string)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 250)

            Button(action: {
                msc.username = tmp_string
                self.presentation.wrappedValue.dismiss()
            }, label: {
                Text("決定")
                    .frame(width: 100, height: 30, alignment: .center)
                    .foregroundColor(.white)
                    .font(.title2)
                    .background(Color.red)
                    .cornerRadius(15, antialiased: true)
            })
        }.navigationTitle(Text("キャラクタ名の設定"))
        Spacer()
    }
}

struct NameSettingView_Previews: PreviewProvider {
    static var previews: some View {
        NameSettingView()
    }
}
