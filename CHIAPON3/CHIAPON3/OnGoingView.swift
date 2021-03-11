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
    
    //@State var text1: String = "Hello, world!"
    //@State var text2: String = "Hello, world!"
    
    @State var usagestatusdata: [UsageStatusData] = []
    
    @State private var password = "6091"
    @State private var inputText = ""
    @State private var checkPassword: Bool = false
    @State private var logdays: Int = 22
    
    var body: some View {
        VStack {
            Button(action: {
                //最初にデータをポスト
                postData()
                //そのあとアンケートサイトを開く
                if let url = URL(string: "https://muratalab.si.aoyama.ac.jp/dev/chiapon3/receive.php"){
                    UIApplication.shared.open(url, completionHandler: {completed in
                        print(completed)
                    })
                }
            }) {
                Text("アンケート回答（外部サイトへ進む）")
            }.frame(width: 300, height: 30)
            .foregroundColor(.black)
            .background(Color.orange)
            .cornerRadius(15, antialiased: true)
            SecureField("ここにパスワードを入力してください", text: $inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.alphabet)
                .padding()
            Button("パスワードを確認") {
                if inputText == password {
                    checkPassword = true
                }else{
                    checkPassword = false
                    
                }
                UIApplication.shared.closeKeyboard()
            }.frame(width: 200, height: 30)
            .foregroundColor(.black)
            .background(Color.orange)
            .cornerRadius(15, antialiased: true)
            
            if checkPassword {
                List {
                    Section(header: Text("日付\n回数　平均使用時間　平均未使用時間")){
                        ForEach(usagestatusdata){ data in
                            VStack {
                                Text("日付: " + data.date).frame(maxWidth: .infinity, alignment: .leading)
                                HStack {
                                    Text("回数: " + String(data.unlockedcount))
                                    Spacer()
                                    Text("使用: " + String(round(data.usedave*100)/100))
                                    Spacer()
                                    Text("未使用: " + String(round(data.unusedave*100)/100))
                                }
                            }

                        }
                    }
                }
                
            }
            Spacer()
        }
        .onAppear(perform: {
            //ここに、View表示時の処理を書く
            /*
            text1 = "msc.userid: \(msc.userid)"
            logData.fetchData()
            if logData.logs.count > 0 {
                text2 = "logData.userid: \(logData.logs[0].userid)"
            }else{
                text2 = "logData has no data"
            }
             */
            
            //過去７日間の日付を作る
            //現在日時の生成
            let day = Date()
            //let f = DateFormatter()
            //f.dateFormat = "yyyyMMddHHmmss"
            //let now = f.string(from: Date())
            //年月日部分を切り出してIntにキャスト
            //let date = Int(now[..<now.index(now.startIndex, offsetBy: 8)])
            //作った日付をもとに、構造体のリスト（入れ物）を作成
            makeUsageStatusData(date: day)
            //ログデータから１日あたりの使用状況を取得して計算してリストに入力
            getUnlockData()
            getLockData()
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
    
    //日付取り出し
    func dateExtractor(date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyyMMddHHmmss"
        //f.dateStyle = .long
        //f.timeStyle = .none
        return f.string(from: date)
    }
    
    //表示用構造体の生成
    func makeUsageStatusData(date: Date){
        var usagestatusdatum: UsageStatusData
        for i in 0 ... logdays{
            let tmpdate = Calendar.current.date(byAdding: .day, value: (i) * -1, to: date)!
            var tmpdatestring = dateExtractor(date: tmpdate)
            tmpdatestring = String(tmpdatestring[..<tmpdatestring.index(tmpdatestring.startIndex, offsetBy: 8)])
            print(i)
            usagestatusdatum = UsageStatusData(date: tmpdatestring, usedtime: 0.0, usedave: 0.0, usedvar: 0.0, unusedtime: 0.0, unusedave: 0.0, unusedvar: 0.0, unlockedcount: 0, lockedcount: 0)
            usagestatusdata.append(usagestatusdatum)
        }
        //print("makeUsageStatusData: \(usagestatusdata)")
    }
    
    //１日あたりのアンロック回数と利用時間を取得して計算
    func getUnlockData(){
        let tmpdata = getData(locked: false, unlocked: true)
        //利用時間の平均値と分散を求めるための配列を作成する
        var usagearray: [Double] = []
        
        for i in 0...logdays {
            usagearray = []
            for data in tmpdata {
                //日にちが一緒で、アンロックのフラグが立っているデータのみ処理
                if data.day[..<data.day.index(data.day.startIndex, offsetBy: 8)] == usagestatusdata[i].date && data.unlocked {
                    //アンロック回数を入れる
                    usagestatusdata[i].unlockedcount = usagestatusdata[i].unlockedcount + 1
                    //利用していなかった時間
                    // lockedの時のusage_timeは、unlockedduration
                    // unlockedの時のusage_timeは、lockedduration
                    usagestatusdata[i].unusedtime = usagestatusdata[i].unusedtime + data.current_usagetime
                    //さらに平均値と分散用の配列の処理
                    usagearray.append(data.current_usagetime)
                }else{
                    //print("miss: \(data)")
                }
            }
            //さらに分散と平均値を追加
            if usagearray.count >= 2 {
                usagestatusdata[i].unusedave = usagearray.average(usagearray)
                usagestatusdata[i].unusedvar = usagearray.variance(usagearray)
            }
        }
        //print("getUnlockData: \(usagestatusdata)")
    }
    
    //１日あたりのロック回数と利用時間を取得して計算
    func getLockData(){
        let tmpdata = getData(locked: true, unlocked: false)
        //利用時間の平均値と分散を求めるための配列を作成する
        var usagearray: [Double] = []
        
        for i in 0...logdays {
            usagearray = []
            //print(usagearray)
            for data in tmpdata {
                //日にちが一緒で、アンロックのフラグが立っているデータのみ処理
                if data.day[..<data.day.index(data.day.startIndex, offsetBy: 8)] == usagestatusdata[i].date && data.locked {
                    //ロック回数を入れる
                    usagestatusdata[i].lockedcount = usagestatusdata[i].lockedcount + 1
                    //利用していた時間
                    // lockedの時のusage_timeは、unlockedduration
                    // unlockedの時のusage_timeは、lockedduration
                    usagestatusdata[i].usedtime = usagestatusdata[i].usedtime + data.current_usagetime
                    //さらに平均値と分散用の配列の処理
                    usagearray.append(data.current_usagetime)
                }else{
                    //print("miss: \(data)")
                }
                //さらに分散と平均値を追加
                if usagearray.count >= 2 {
                    usagestatusdata[i].usedave = usagearray.average(usagearray)
                    usagestatusdata[i].usedvar = usagearray.variance(usagearray)
                }
            }
        }
        //print("get LockData: \(usagestatusdata)")
    }
    
    //データポスト用関数
    func postData(){
        
        print(usagestatusdata) //ポストするデータの元

        
        let urlString = "https://muratalab.si.aoyama.ac.jp/dev/chiapon3/receive.php"
        let request = NSMutableURLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        request.addValue("aplication/json", forHTTPHeaderField: "Content-Type")
        
        let params:[String:Any] = [
            "foo": "bar",
            "baz":[
                "a": 1,
                "b": 2,
                "c": 3]
        ]
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            
            let task:URLSessionTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) -> Void in
                let resultData = String(data: data!, encoding: .utf8)!
                //print("result:\(resultData)")
                //print("response:\(response)")
            })
            task.resume()
        }catch{
            print("Error:\(error)")
            return
        }

    }
}


struct OnGoingView_Previews: PreviewProvider {
    static var previews: some View {
        OnGoingView()
    }
}
