//
//  GameProccessor.swift
//  Killer
//
//  Created by  qztcm09 on 16/6/27.
//  Copyright © 2016年  qztcm09. All rights reserved.
//

import Foundation

class GameProccessor: NSObject {
    
    //    var game:Game?
    
    func start() -> Bool {
        
        DispatchQueue.main.async(execute: {
            
            Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(GameProccessor.run), userInfo: nil, repeats: true)
            
        })
        return true
    }
    func processVote() {
        print("processVote")
        if votingcounter.resulter().count == 1 {
            let n = Int((votingcounter.resulter()[0]))
            (killerServer.sGame?.players?.object(at: n!) as! Player ).State = (killerServer.sGame?.players?.object(at: n!) as! Player ).State % 10
            
        }else{
            print("dismiss")
        }
        
    }
    
    func run() -> Bool {
        
        if killerServer.sGame?.gameState == "night" {
            killerServer.sGame?.gameState = "daytime"
            votingcounter.voteinit()
        }else {
            self.processVote()
            killerServer.sGame?.gameState = "night"
            
        }
        
        var msgtosend=[String:String]()
        msgtosend["cmd"]="update"
        msgtosend["GameStat"] = "\(killerServer.sGame!.gameState)"
        for i in 0..<(killerServer.sGame?.players?.count)! {
            let pla = killerServer.sGame?.players?.object(at: i) as! Player
            msgtosend["S\(i)"] = "\(pla.State)"
            msgtosend["R\(i)"] = "\(pla.Role)"
            
        }
        killerServer.sendMessageToAll(msg: msgtosend as NSDictionary)
        return true
    }
    
    
}
