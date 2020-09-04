//
//  myNoificationMessages.swift
//  LockUnLockTest
//
//  Created by kmurata on 2020/02/13.
//  Copyright © 2020 kmurata seminar. All rights reserved.
//

import Foundation

class myNotificationMessages{
    
    //ちあぽんのセリフ
    var cheerpon_Morning: [String] = ["早起きは三文の徳だよ！ワタシもあなたの為に早起きしたよ！！","まだ眠い？ワタシも眠たいよ〜ワタシのこと起こしに来て〜🛌","寒くて朝起きるの大変だけど、今日も1日頑張ろう！","ワタシを開いてから今日も1日スタートさせよう！","ワタシに会いに来たらスマホをどれだけ使っているかわかるよ！"]
    var cheerpon_AfterNoon: [String] = ["今日の昼食は何かな？スマホを離れてゆっくり食べてね🍽","家族や友達とコミュニケーションしながらお昼を楽しんでね！","今日やるべきことを今からやったら、きっとすぐ終わるよ♪","午後も始まったばかり！スマホの電池なくならないように気を付けて！","ワタシのもぐもぐタイムだよ🍭"]
    var cheerpon_Night: [String] = ["お腹空いたぁ🤤夕ご飯食べた？","今日ももう少しでおしまい。スマホを使わないように頑張ってね😉","近くの人とお話ししてみたら何か良いことあるかも🤗","明日はもう少し休憩してちょうだいね😌","スマホの使用量が減ってたらワタシも嬉しい！"]
    
    //ちあぽんのセリフあおりバージョン
    var aori_Morning: [String] = ["エラく早起きだな！仕方ないから早起きしてやったわ！！","まだ眠いだろwコッチにも起こしに来い!","本当に起きてるのか？無理だろw","まだ１日スタートしたところだなw","どれだけスマホ使ってるか教えてやってもいいぞw"]
    var aori_AfterNoon: [String] = ["メシ食ってる時もスマホ離せない奴発見","スマホ触ってないでたまには他人と話せば？","早くやることやんねーと今日中に終わらんな♪","やっと午後が始まったな！そんな調子で電池もつの？","お前がスマホ見てる間にメシ食っとくわ"]
    var aori_Night: [String] = ["腹へったな！スマホ触りすぎて夕飯食う暇もないんじゃねーのw","今日ももうすぐ終わるというのにスマホをやめられない奴w","スマホやってないで誰かと話せばいいのに・・あ、そんな友達いないとか？","明日はもっと休憩した方がいいんじゃねーの？","スマホ使用量、もっと増やすか？"]
    
    
    
    
    var cheerpon_Counter_Morning: [String] = ["今日は朝から体を動かしてみたらどうかな？","スマホを使わない1日を作ってみない〜？","スマホを使いすぎないように、ワタシが応援してるよ！","ワタシがスマホの使いすぎの抑制のお手伝いをするよ😊","今日も1日頑張って！たまにはワタシに会いに来てね🎀"]
    var cheerpon_Counter_Noon: [String] = ["でも、午前中スマホ使いすぎてない〜？","お昼の時はスマホを見ないようにしよう🍳","休憩休憩🎶体と一緒にスマホも休ませよう！","スマホをお休みしてみない？","午後もスマホ使いすぎないように頑張ってね！"]
    var cheerpon_Counter_Afternoon: [String] = ["できるだけ使わないように気をつけよう☺️","ゆっくりできるからワタシ嬉しい！","スマホの使い過ぎを減らすには、まず開く回数から減らしてみよう🐾","スマホ開いてるのワタシ見てるよ👀","スマホを使う前に、先に他のことしておこう🚗"]
    //var cheerpon_Counter_daytime: [String] = ["また開いちゃった❓使わないように気をつけよう☺️","こんなに呼ばれてワタシびっくり！","スマホの使い過ぎを減らすには、まず開く回数から減らしてみよう🐾","スマホ開いてるのワタシ見てるよ👀","スマホを使う前に、先に他のことしておこう🚗"]
    var cheerpon_Counter_Night : [String] = ["今日も残りあと少し！やり残したことはない？","明日の予定は確認できてる？明日はゆっくり休めるかなあ🤔","もう夜になっちゃったね。お風呂は入った？🛁","今日は他にやることない？1日あっという間だね〜🙃","私は寝る支度中〜あなたも他にやることない？"]
    var cheerpon_Counter_MidNight : [String] = ["ふわぁ寝てた〜どうしたの？もう寝よう🛌","まだ起きてたの？もう寝よう😴","スマホを閉じてゆっくり休んでね。","ワタシは今夢見てたよ。。食べ物がいっぱいの…","早寝早起きのリズムが大事だよ！"]
    
    //あおりセリフ
    //05:00-11:00
    var aori_Counter_Morning : [String] = ["起きて早々にひたすらスマホすか？w","目真っ赤www","SNS?動画?ゲーム?それ以上にやるべきことがあるんじゃない?w","今日も1日、目を酷使でーすww","今日も1日時間を無駄にしそうだねwww"]

    //(11:00~13:00)
    var aori_Counter_Noon : [String] = ["その集中力逆にすごいね！！","How stupid can you get?","逆にずっとスマホ使っていれば頭良くなるんじゃない？w","スマホを使わない休憩の仕方はないのか？w","今日絶対1日充電持たねえよw"]

    //(13:00~18:00)
    var aori_Counter_Afternoon : [String] = ["集中力ありすぎて草","スマホいじってる時間は有益？w","将来失明するんじゃねえのww","やることあるんじゃなかったのかw","今日はずっとだらだら？あっ・・・(察し)"]
       
    //(18:00~23:00)
    var aori_Counter_Night : [String] = ["お前の将来が不安だなw","ま〜たいじってるよw","そんなに周りの人の事気になる？w","知ってる？スマホを長時間使うと脳内物質のバランスが崩れて神経細胞が死滅するんだよw","どうせ寝るまでずっとスマホ見てるんだろw"]
    
    //(23:00~05:00)
    var aori_Counter_MidNight : [String] = ["...まだやっとるんか！！","そろそろ目ん玉取れんじゃないの？w","スマホ凝視してる時の自分の顔見たことある？なかなかすごいよw","将来失明しても知らねえよww","暇を持て余した神々の遊びw"]

    
    //タイトル作成用
    var title_aori_pre : [String] = ["やれやれ、", "おいおい、", "マジかよ、", "バカな、", "えっ、"]
    var title_aori_post : [String] = ["分しか我慢できないのか", "分しか経ってないぞ", "分だけ頑張ったなwww", "分間休んだだけ・・・", "分以上待てないのかw"]
    var title_cheerpon_pre : [String] = ["すごい！", "やった！", "嬉しい！", "えぇっ！", "うん！"]
    var title_cheerpon_post : [String] = ["分も我慢できたね！", "分も経ったよ", "分も頑張ったね！", "分間も休めた！", "分も待てたね！"]
    //コメント取得
    //配列名を指定するとランダムで要素を返してくれる
    func getComment(comments: [String]) -> String {
        let random = (Int)(arc4random_uniform(UInt32(comments.count)))
        return comments[random]
    }
    
    /* アンロック時の通知を生成 */
    //タイトル生成
    func getTitleUnlocked(cheerpontype: String, intlockedduration: Int) -> String{
        var title: String = "がんばれ"
        
        if cheerpontype == "aori" {
            title = getComment(comments: title_aori_pre) + "\(intlockedduration)" + getComment(comments: title_aori_post)
        }
        
        if cheerpontype == "cheerpon" {
            title = getComment(comments: title_cheerpon_pre) + "\(intlockedduration)" + getComment(comments: title_cheerpon_post)
        }
        
        return title
    }
    
    
    //本文生成
    func getBodyUnlocked(cheerpontype: String) -> String {
        var bodystring: String = "スマホ使わないようにね！"
        
        if cheerpontype == "aori" {
            if checkTime(from: 5, to: 11) {    //午前
                bodystring = getComment(comments: aori_Counter_Morning)
            }else if checkTime(from: 11, to: 13){  //お昼
                bodystring = getComment(comments: aori_Counter_Noon)
            }else if checkTime(from: 13, to: 18){  //午後
                bodystring = getComment(comments: aori_Counter_Afternoon)
            }else if checkTime(from: 18, to: 23){  //夜
                bodystring = getComment(comments: aori_Counter_Night)
            }else{  //深夜（上記以外）
                bodystring = getComment(comments: aori_Counter_MidNight)
            }
        }
        
        if cheerpontype == "cheerpon" {
            if checkTime(from: 5, to: 11) {    //午前
                bodystring = getComment(comments: cheerpon_Counter_Morning)
            }else if checkTime(from: 11, to: 13){  //お昼
                bodystring = getComment(comments: cheerpon_Counter_Noon)
            }else if checkTime(from: 13, to: 18){  //午後
                bodystring = getComment(comments: cheerpon_Counter_Afternoon)
            }else if checkTime(from: 18, to: 23){  //夜
                bodystring = getComment(comments: cheerpon_Counter_Night)
            }else{  //深夜（上記以外）
                bodystring = getComment(comments: cheerpon_Counter_MidNight)
            }
        }
        
        return bodystring
    }
    
    
    /* 時間のチェック */
    //現在時刻がfromからtoであれば true, それ以外であればfalseを返す
    func checkTime(from: Int, to: Int) -> Bool {
        let now = Date()
        let calendar = Calendar.current
        let hour:Int = calendar.component(.hour, from: now)
        
        if(hour >= from && hour < to){
            return true
        }else{
            return false
        }
    }
}
