//
//  SimpleRow.swift
//  CHIAPON3
//
//  Created by kmurata on 2021/02/25.
//

import SwiftUI

struct SimpleRow: View {
    var body: some View {
        VStack {
            Text("日付").frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                Text("アンロック回数")
                Spacer()
                Text("平均使用時間")
                Spacer()
                Text("平均未使用時間")
            }
        }
    }
}

struct SimpleRow_Previews: PreviewProvider {
    static var previews: some View {
        SimpleRow()
    }
}
