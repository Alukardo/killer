//
//  ViewController.swift
//  hangge_756
//
//  Created by hangge on 16/4/4.
//  Copyright © 2016年 hangge.com. All rights reserved.
//

import UIKit


class FirstViewController: UIViewController,NetServiceDelegate,NetServiceBrowserDelegate,ClientDelegate{
    
    //消息输入框
    @IBOutlet weak var textFiled: UITextField!
    //消息输出列表
    @IBOutlet weak var textView: UITextView!
    
    
   
    var browser:Browser?
    //socket服务端封装类对象
    
    //socket客户端类对象
    var socketClient:TCPClient?
    
    var ServiceList:NSMutableArray?
    var targetServer:Int = 0
    
    let localServer:String = local
    
    var msg:NSDictionary?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ServiceList = NSMutableArray()
        killerClient.delegate = self
    }
    
    //“发送消息”按钮点击
    @IBAction func sendMsg(_ sender: AnyObject) {
        let content=textFiled.text!
        let message=["cmd":"msg","content":content]
        killerClient.delegate = self
        killerClient.sendMessage(msgtosend: message as NSDictionary)
        textFiled.text=nil
    }
    //MARK: - ClientDelegate
    func getServersMessage(_ msg:NSDictionary){
        self.msg = msg
        let cmd:String=self.msg!["cmd"] as! String
        switch(cmd){
        case "msg":
            self.textView.text = self.textView.text +
                (msg["from"] as! String) + ": " + (msg["content"] as! String) + "\n"
        default:
            print(msg)
        }

    }
    
    
    
}
