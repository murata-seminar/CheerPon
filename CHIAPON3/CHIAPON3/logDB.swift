//
//  logDB.swift
//  CHIAPON3
//
//  Created by kmurata on 2021/02/19.
//

import Foundation
import RealmSwift
import Firebase

//Swift2.0っぽい書き方でやってみる
//https://note.com/dngri/n/na87140a78f2f
//https://www.youtube.com/watch?v=lx6C6pcL-0M&amp%3Bfeature=emb_logo
class Log: Object, Identifiable{
    @objc dynamic var id = 0
    @objc dynamic var timestamp = 0.0
    @objc dynamic var day = ""
    @objc dynamic var userid = "0"
    @objc dynamic var username = "no_name"
    @objc dynamic var locked = false
    @objc dynamic var unlocked = false
    @objc dynamic var current_usagetime = 0.0
    //メッセージ送信をする場合, しない場合はmessageが""とする
    @objc dynamic var message = ""
    @objc dynamic var chiapon = "normal"   //cheer, aori
    @objc dynamic var type = "scheduled"    //scheduled, unlocked, continued
    
    override static func primaryKey() -> String? {
        "id"
    }
}

class LogViewModel: ObservableObject{
    //Firestore
    private let db = Firestore.firestore()
    
    @Published var logs: [Log] = []
    
    
    init(){
        fetchData()
    }
    
    /* ------------------------------------------------------ */
    /*  for realm   management                                */
    /* ------------------------------------------------------ */
    func fetchData() {
        guard let dbRef = try? Realm() else {
            print("realm fetch fatel error")
            return
        }
        let results = dbRef.objects(Log.self)
        self.logs = results.compactMap({(log) -> Log? in
            return log
        })
        print("logs size: \(logs.count)")
    }
    
    func addData(addlog: Log){
        let log = addlog

        do{
            let dbRef = try Realm()
            try dbRef.write{
                dbRef.add(log)
            }
        }catch let error{
            print("realm wtite error on add: \(error.localizedDescription)")
        }
    }
    
    func deleteAll(){
        do{
            let dbRef = try Realm()
            try dbRef.write{
                dbRef.deleteAll()
            }
        }catch let error{
            print("realm delete error on add: \(error.localizedDescription)")
        }
    }
    
    func removeDB(){
        do{
            if let fileURL = Realm.Configuration.defaultConfiguration.fileURL{
                print("\(fileURL)")
                let realmURLs = [fileURL, fileURL.appendingPathExtension("lock"), fileURL.appendingPathExtension("note"), fileURL.appendingPathExtension("management")]
                for URL in realmURLs{
                    try FileManager.default.removeItem(at: URL)
                }
            }
        }catch let error{
            print("realm remove db error on add: \(error.localizedDescription)")
        }
    }
    
    /* ------------------------------------------------------ */
    /*  for firestore management                              */
    /* ------------------------------------------------------ */
    func addFirestore(addlog: Log){
        /*
         @objc dynamic var id = 0
         @objc dynamic var timestamp = 0.0
         @objc dynamic var day = ""
         @objc dynamic var userid = "0"
         @objc dynamic var username = "no_name"
         @objc dynamic var locked = false
         @objc dynamic var unlocked = false
         @objc dynamic var current_usagetime = 0.0
         //メッセージ送信をする場合, しない場合はmessageが""とする
         @objc dynamic var message = ""
         @objc dynamic var chiapon = "normal"   //cheer, aori
         @objc dynamic var type = "scheduled"    //scheduled, unlocked, continued
         
         */
        //追加するデータの生成
        let data: [String: Any] = ["id": addlog.id,
                                   "timestamp": addlog.timestamp,
                                   "day": addlog.day,
                                   "userid": addlog.userid,
                                   "username": addlog.username,
                                   "locked": addlog.locked,
                                   "unlocked": addlog.unlocked,
                                   "current_usagetime": addlog.current_usagetime,
                                   "message": addlog.message,
                                   "chiapon": addlog.chiapon,
                                   "type": addlog.type]
        //ドキュメント名を生成
        let documentname = addlog.userid + String(addlog.timestamp)
        //DBに追加
        db.collection("CHIAPON3").document(documentname).setData(data){ error in
            if let error = error {
                print("addFirestore: " + error.localizedDescription)
                return
            }
        }
    }
    
}

/*
 // UIKITライフサイクルの例でやろうとして失敗
 //https://www.raywenderlich.com/12235561-realm-with-swiftui-tutorial-getting-started
class LogDB: Object{
    @objc dynamic var id = 0
    @objc dynamic var timestamp = 0.0
    @objc dynamic var message = ""
    @objc dynamic var userid = 0
    @objc dynamic var username = "no_name"
    @objc dynamic var chiapon = "cheer"   //cheer, aori
    @objc dynamic var type = "scheduled"    //scheduled, unlocked, continued
    
    override static func primaryKey() -> String? {
        "id"
    }
}


struct Log: Identifiable{
    let id: Int
    let timestamp: Double
    let message: String
    let userid: Int
    let username: String
    let chiapon: String
    let type: String
}

extension Log {
    init(logDB: LogDB){
        id = logDB.id
        timestamp = logDB.timestamp
        message = logDB.message
        userid = logDB.userid
        username = logDB.username
        chiapon = logDB.chiapon
        type = logDB.type
    }
}


final class LogStore: ObservableObject {
    private var logResults: Results<LogDB>
    
    //logResutlsにDBのデータをセット
    init(realm: Realm){
        logResults = realm.objects(LogDB.self)
    }
    
    var logs: [Log] {
        logResults.map(Log.init)
    }
}

extension LogStore {
    //データ追加
    func create(){
        objectWillChange.send()
        
        do{
            let realm = try Realm()
            let logDB = LogDB()
            logDB.id = UUID().hashValue
            logDB.timestamp = Date().timeIntervalSince1970
            logDB.message = "仮のメッセージ"
            logDB.userid = 0
            logDB.username = "no_name"
            logDB.chiapon = "temp affection"
            logDB.type = "temp type"
            
            try realm.write{
                realm.add(logDB)
            }
        }catch let error{
            print(error.localizedDescription)
        }
    }
    
    //データ更新
    func update(logID: Int){
        objectWillChange.send()
        
        do{
            let realm = try Realm()
            try realm.write{
                realm.create(LogDB.self, value: ["id": logID, "message": "change message", "timestamp": Date().timeIntervalSince1970], update: .modified)
            }
        }catch let error{
            print(error.localizedDescription)
        }
    }
    
    //データ削除
    func delete(logID: Int){
        objectWillChange.send()
        
        guard let logDB = logResults.first(where: {$0.id == logID}) else {
            return
        }
        
        do{
            let realm = try Realm()
            try realm.write{
                realm.delete(logDB)
            }
        }catch let error{
            print(error.localizedDescription)
        }
    }
    
    //データ全削除
    func deleteAll(){
        objectWillChange.send()
        
        do{
           let realm = try Realm()
            try realm.write{
                realm.deleteAll()
            }
        }catch let error{
            print(error.localizedDescription)
        }
    }
    
}

*/
