//
//  OnGoingView.swift
//  CHIAPON3
//
//  Created by kmurata on 2021/02/20.
//

import SwiftUI

struct OnGoingView: View {
    
    @EnvironmentObject var msc: mySettingClass
    //Realmの処理
    @StateObject var logData: LogViewModel = LogViewModel()
    
    @State var text1: String = "Hello, world!"
    @State var text2: String = "Hello, world!"
    
    @State var usagestatusdata: [UsageStatusData] = []
    
    var body: some View {
        VStack{
            Text("Hello, World!")
            Text(text1)
            Text(text2)
        }
        .onAppear(perform: {
            //ここに、View表示時の処理を書く
            text1 = "msc.userid: \(msc.userid)"
            logData.fetchData()
            if logData.logs.count > 0 {
                text2 = "logData.userid: \(logData.logs[0].userid)"
            }else{
                text2 = "logData has no data"
            }
            
            //過去７日間の日付を作る
            //現在日時の生成
            let f = DateFormatter()
            f.dateFormat = "yyyyMMddHHmmss"
            let now = f.string(from: Date())
            //年月日部分を切り出してIntにキャスト
            let date = Int(now[..<now.index(now.startIndex, offsetBy: 8)])
            //作った日付をもとに、構造体のリスト（入れ物）を作成
            makeUsageStatusData(date: date ?? 0)
            //ログデータから１日あたりのアンロック回数を取得して計算してリストに入力
            getUnlockData()
            //getData(locked: true)
            //ログデータから１日あたりの使用時間を計算してリストに入力
            //リスト表示
        })
    }
    
    //ログデータから計算
    func getData(locked: Bool = false, unlocked: Bool = false) -> Array<Log>{
        //フェッチ
        logData.fetchData()
        //データから該当するデータを抽出
        var tmplogs: [Log] = []
        for log in logData.logs {
            if log.locked == locked && log.unlocked == unlocked {
                tmplogs.append(log)
            }
        }
        //debug
        //print("\(logData.logs.count)件中\(tmplogs.count)件検出")
        return tmplogs
    }
    
    //表示用構造体の生成
    func makeUsageStatusData(date: Int){
        var usagestatusdatum: UsageStatusData
        for i in 0 ... 7{
            usagestatusdatum = UsageStatusData(date: (date - i), usagetime:0.0, usagecount: 0)
            usagestatusdata.append(usagestatusdatum)
        }
        print("makeUsageStatusData: \(usagestatusdata)")
    }
    
    //１日あたりのアンロック回数を取得して計算
    func getUnlockData(){
        let tmpdata = getData(locked: false, unlocked: true)
        for data in tmpdata {
            for i in 0...7 {
                if Int(data.day[..<data.day.index(data.day.startIndex, offsetBy: 8)]) == usagestatusdata[i].date {
                    usagestatusdata[i].usagecount = usagestatusdata[i].usagecount + 1
                }else{
                    //print("miss: \(data)")
                }
            }
        }
        print("getUnlockData: \(usagestatusdata)")
    }
}

struct OnGoingView_Previews: PreviewProvider {
    static var previews: some View {
        OnGoingView()
    }
}
