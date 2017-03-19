//
//  ChatUser.swift
//  Killer
//
//  Created by  qztcm09 on 16/6/18.
//  Copyright © 2016年  qztcm09. All rights reserved.
//

import Foundation
//客户端管理类（便于服务端管理所有连接的客户端）
class ChatUser:NSObject{
    
    
    var socketServer:Server?
    var tcpClient:TCPClient?
    
    var id:Int = 0
    var username:String = ""
    
    //循环 接收&发送 消息
    func messageloop(){
        while true{
            if let msg=self.readMsg(){
                self.processMsg(msg)
            }else{
                self.removeme()
                break
            }
        }
    }
    
    //解析收到的消息
    func readMsg()->NSDictionary?{
        //read 4 byte int as type
        if let data=self.tcpClient!.read(4){
            if data.count==4{
                let ndata=Data(bytes: UnsafePointer<UInt8>(data), count: data.count)
                var len:Int32=0
                (ndata as NSData).getBytes(&len, length: data.count)
                if let buff=self.tcpClient!.read(Int(len)){
                    let msgd:Data=Data(bytes: UnsafePointer<UInt8>(buff), count: buff.count)
                    let msgi:NSDictionary=(try!
                        JSONSerialization.jsonObject(with: msgd,
                                                     options: .mutableContainers)) as! NSDictionary
                    return msgi
                }
            }
        }
        return nil
    }
    
    
    //处理收到的消息
    func processMsg(_ msg:NSDictionary){
        if msg["cmd"] as! String=="join"{
            self.username=msg["nickname"] as! String
        }
        self.socketServer!.processUserMsg(user: self, msg: msg)
    }
    
    //发送消息
    func sendMsg(msg:NSDictionary){
        let jsondata=try? JSONSerialization.data(withJSONObject: msg, options:
            JSONSerialization.WritingOptions.prettyPrinted)
        var len:Int32=Int32(jsondata!.count)
        let data:Data=NSMutableData(bytes: &len, length: 4) as Data
        _ = self.tcpClient!.send(data: data)
        _ = self.tcpClient!.send(data: jsondata!)
        
    }
    
    //移除该客户端
    func removeme(){
        self.socketServer!.removeUser(self)
    }
    
    //关闭连接
    func kill(){
        _ = self.tcpClient!.close()
    }
}
