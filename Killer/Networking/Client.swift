//
//  Client.swift
//  Killer
//
//  Created by  qztcm09 on 16/6/11.
//  Copyright © 2016年  qztcm09. All rights reserved.
//

import UIKit

 class Client: NSObject,NetServiceDelegate,NetServiceBrowserDelegate{
    
    
    //socket客户端类对象
    
    let clientName=["cmd":"join","nickname":"Player\(Int(arc4random()%1000))"]
    
    var socketClient:TCPClient?
    var Service:NetService?
    var delegate:ClientDelegate?
    
    var CGame:Game?
    var numOFP = -1
    var Pid = -1
    var Role:String?
    

    
    //MARK:
    func connect(_ service:NetService){
        service.delegate = self
        service.resolve(withTimeout: 1.0)
    }
    //连接服务端Tool
    func processClientSocket(_ address:String){
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.background).async(execute: {
            () -> Void in
            self.socketClient=TCPClient(addr: address, port: 8080)
            //连接服务器
            let (success,msg)=self.socketClient!.connect(timeout: 5)
            if success{
                DispatchQueue.main.async(execute: {
                    self.alert("connect success", after: {
                    })
                })
                //发送用户名给服务器（这里使用随机生成的）
                self.sendMessage(msgtosend: self.clientName as NSDictionary)
                
                //不断接收服务器发来的消息
                while true{
                    if let msg=self.readMessage(){
                        DispatchQueue.main.async(execute: {
                            //self.processMessage(msg)
                            self.delegate?.getServersMessage(msg)
                            
                        })
                    }else{
                        DispatchQueue.main.async(execute: {
                            //self.disconnect()
                        })
                        break
                    }
                }
            }else{
                DispatchQueue.main.async(execute: {
                    self.alert(msg,after: {
                    })
                })
            }
        })
        
    }
    //发送消息
    func sendMessage(msgtosend:NSDictionary){
        let msgdata=try? JSONSerialization.data(withJSONObject: msgtosend,
                                                                options: .prettyPrinted)
        var len:Int32=Int32(msgdata!.count)
        let data:Data=NSMutableData(bytes: &len, length: 4) as Data
        _ = self.socketClient!.send(data:data)
        _ = self.socketClient!.send(data:msgdata!)
    }
    
    //用于读取并解析服务端发来的消息
    func readMessage()->NSDictionary?{
        //read 4 byte int as type
        if let data=self.socketClient!.read(4){
            if data.count==4{
                let ndata=Data(bytes: UnsafePointer<UInt8>(data), count: data.count)
                var len:Int32=0
                (ndata as NSData).getBytes(&len, length: data.count)
                if let buff=self.socketClient!.read(Int(len)){
                    let msgd:Data=Data(bytes: UnsafePointer<UInt8>(buff), count: buff.count)
                    let msgi:NSDictionary =
                        (try! JSONSerialization.jsonObject(with: msgd,
                            options: .mutableContainers)) as! NSDictionary
                    return msgi
                }
            }
        }
        return nil
    }
    //弹出消息框
    func alert(_ msg:String,after:()->(Void)){
        print(msg)
    }
    
    func netServiceDidResolveAddress(_ sender: NetService) {
        if sender.addresses != nil {
            let connaddress = IPUnity().ip(from: sender.addresses?.first)
            self.processClientSocket(connaddress! as String)
        }
                
    }
}

protocol ClientDelegate {
    
    func getServersMessage(_ msg:NSDictionary)
    
}
