import UIKit

//服务器端口
var serverport = 8080


//服务端类
class Server: NSObject,NetServiceDelegate{
    
    var isMainSer = false
    var pnumber = 0
    var clients:[ChatUser]=[]
    var server:TCPServer?
    var serverRuning:Bool=false
    var netserverse:NetService?
    var delegate:ServerDelegate?
    var sGame:Game?
    
    
    //MARK:   --MainFunction--
    //启动服务
    func start(_ localServer:String) {
        if(self.serverRuning==true){
            self.stop()
        }
        print(localServer)
        self.server = TCPServer(addr:localServer, port: serverport)
        _ = self.server!.listen()
        self.serverRuning=true
        self.log("server started...")
        
        self.publish()
        
        DispatchQueue.global(priority:  DispatchQueue.GlobalQueuePriority.background).async(execute: {
            while self.serverRuning{
                let client=self.server!.accept()
                if let c=client{
                    DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.background).async(execute: {
                            self.handleClient(c)
                    })
                }
            }
        })
    }
    
    //停止服务
    func stop() {
        self.serverRuning=false
        _ = self.server!.close()
        //forth close all client socket
        for c:ChatUser in self.clients{
            c.kill()
        }
        self.log("server stoped...")
    }
    //MARK:   --SubFunction--
    //发布Bonjon服务
    func publish(){
        self.netserverse = NetService.init(domain: "local.", type: "_spider._tcp.", name: "",port: Int32(serverport))
        self.netserverse?.schedule(in: RunLoop.current, forMode: RunLoopMode.commonModes)
        self.netserverse?.delegate = self
        self.netserverse?.publish()
        
    }
    //注销Bonjon服务
    func unpublish(){
        self.netserverse?.stop()
        self.netserverse?.remove(from: RunLoop.current, forMode: RunLoopMode.commonModes)
        self.netserverse?.delegate = nil
        
    }
    
    //处理连接的客户端
    func handleClient(_ c:TCPClient){
        
        self.log("new client from:"+c.addr)
        
        let u=ChatUser()
        u.tcpClient=c
        u.id = pnumber
        self.clients.append(u)
        pnumber += 1
        
        delegate?.updateplayerList()
        u.socketServer=self
        u.messageloop()
    }
    //单个用户发送信息
    func sendMessageToUser(user u:ChatUser,msg m:NSDictionary){
        u.sendMsg(msg: m)
    }
    
    //全体用户信息发送
    func sendMessageToAll(msg m:NSDictionary){
        
        for user:ChatUser in self.clients{
            user.sendMsg(msg: m)
        }
    }
    //MARK:-----------------------------------------------------
    
    //处理各类消息命令
    func processUserMsg(user u:ChatUser,msg m:NSDictionary){
        self.log("\(u.username)[\(u.tcpClient!.addr)]:"+(m["cmd"] as! String))
        //boardcast message
        var msgtosend=[String:String]()
        let cmd = m["cmd"] as! String
        
        switch cmd {
        case "join":
            msgtosend["cmd"]="join"
            msgtosend["nickname"]=u.username
            msgtosend["addr"]=u.tcpClient!.addr
            self.sendMessageToAll(msg: msgtosend as NSDictionary)
            
        case "leave":
            msgtosend["cmd"]="leave"
            msgtosend["nickname"]=u.username
            msgtosend["addr"]=u.tcpClient!.addr
            self.sendMessageToAll(msg: msgtosend as NSDictionary)
        case "update":
            msgtosend["cmd"]="update"
            msgtosend["GameStat"] = "\(self.sGame!.gameState)"
            for i in 0..<(self.sGame?.players?.count)! {
                let pla = self.sGame?.players?.object(at: i) as! Player
                msgtosend["S\(i)"] = "\(pla.State)"
                msgtosend["R\(i)"] = "\(pla.Role)"
                
            }
            self.sendMessageToAll(msg: msgtosend as NSDictionary)
            
        case "begin":
            
            self.sGame = Game.init(number: self.pnumber)
            gameproccessor = GameProccessor()
            _ = gameproccessor?.start()
            msgtosend["cmd"]="begin"
            msgtosend["GameNum"] = "\(self.clients.count)"
            self.sendMessageToAll(msg: msgtosend as NSDictionary)
            self.unpublish()
        case "msg":
            msgtosend["cmd"]="msg"
            msgtosend["from"]=u.username
            msgtosend["content"]=(m["content"] as! String)
            self.sendMessageToAll(msg: msgtosend as NSDictionary)
            
        case "info":
            let i = u.id
            let p:Player = (self.sGame?.players![i])! as! Player
            msgtosend["cmd"]="info"
            msgtosend["ID"] = "\(i)"
            msgtosend["Role"] = p.Role
            //print("mark:"+p.Role)
            self.sendMessageToUser(user: u, msg: msgtosend as NSDictionary)
        case "vote":
            votingcounter.countingVote(m)
            print("vote")
            
            
        default:
            break
        }
    }
    
    //移除用户
    func removeUser(_ u:ChatUser){
        self.log("remove user [\(u.tcpClient!.addr)]")
        if let possibleIndex=self.clients.index(of: u){
            self.clients.remove(at: possibleIndex)
            self.processUserMsg(user: u, msg: ["cmd":"leave"])
        }
    }
    
    //日志打印
    func log(_ msg:String){
        print(msg)
    }
}

protocol ServerDelegate {
    
    func updateplayerList()
    
}
