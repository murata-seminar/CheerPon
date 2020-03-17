//
//  NameInputViewController.swift
//  LockUnLockTest
//
//  Created by kmurata on 2020/03/13.
//  Copyright © 2020 kmurata seminar. All rights reserved.
//

import UIKit

class NameInputViewController: UIViewController {

    var username: String = ""
    
    @IBOutlet weak var name_text: UITextField!
    
    @IBOutlet weak var notice_text: UILabel!
    
    //遷移元から受け取るクロージャのプロパティ
    var resultHandler: ((String) -> Void)?
    
    @IBAction func cancel_button(_ sender: Any) {
        //username = name_text.text ?? "no name"
        
    }
    
    
    @IBAction func Set_button(_ sender: Any) {
        
        username = name_text.text!

        
        if let handler = self.resultHandler{
            handler(username)
        }
        
        //元に戻る
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    //https://ayafitpay.com/swift4-move-view/
    //↓こっちでやってみる
    //https://qiita.com/ichikawa7ss/items/df8cd87e66ada42cb560
    //@IBAction func resistration_button(_ sender: Any) {
        //username = name_text.text ?? "no name"
        
        //if self.presentingViewController is ViewController{
            //let count = (self.navigationController?.viewControllers.count)!
            //print(count)
            //let vc = self.navigationController?.viewControllers[count] as! ViewController
            //let vc = self.presentingViewController as! ViewController
            //vc.username = username
            //self.navigationController?.popViewController(animated: true)
        //}
        
        //self.username = "no name"
        
        //if let handler = self.resultHandler{
        //    handler(username)
        //}
        
        //元に戻る
        //self.dismiss(animated: true, completion: nil)
    //}
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //notice_text.lineBreakMode = .byWordWrapping
        notice_text.text = "あなたのお名前を入力し、\n設定ボタンを押してください\n一度設定すると変更できません"
        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
