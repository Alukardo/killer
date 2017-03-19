//
//  Game.swift
//  Killer
//
//  Created by  qztcm09 on 16/6/22.
//  Copyright © 2016年  qztcm09. All rights reserved.
//

import Foundation
class Game: NSObject {
    
    var gameID = arc4random()
    
    var players:NSMutableArray? = []
    
    var isStart = false
    
    var gameState:String = "night"
    
    var numOfPlayers:Int?
    
    var numOfKillers:Int?
    
    var numOfPolices:Int?
    
    var numOfCommonP:Int?
    
    var votingCounter = VotingCounter()
    
    var timer:Timer?
    
    init(number:Int) {
        
        self.numOfPlayers = number
        switch number {
        case 1...5:
            self.numOfKillers = 1
            self.numOfPolices = 1
        case 6...10:
            self.numOfKillers = 2
            self.numOfPolices = 2
        case 11...14:
            self.numOfKillers = 3
            self.numOfPolices = 3
        case 15...16:
            self.numOfKillers = 4
            self.numOfPolices = 4
        default:
            self.numOfKillers = -1
            self.numOfPolices = -1
            
        }
        self.numOfCommonP = number - self.numOfPolices! - self.numOfKillers!
        
        for i in 0..<number {
            
            let player = Player()
            
            player.setplayID(i)
            
            //player.chatUser = killerServer.clients[i]
            
            self.players?.add(player)
        }
        
        for i in 0..<number {
            
            let ri  = i + Int(arc4random_uniform(UInt32(number-i)))
            let temp = (self.players?.object(at: i) as! Player).getplayID()
            (self.players?.object(at: i) as! Player).setplayID((self.players?.object(at: ri) as! Player).getplayID())
            (self.players?.object(at: ri) as! Player).setplayID(temp)
            
        }
        
        for i in 0..<number {
            if (self.players?.object(at: i) as! Player).getplayID() < numOfKillers!  {
                (self.players?.object(at: i) as! Player).Role = "K"
            }else if(self.players?.object(at: i) as! Player).getplayID() < numOfKillers! + numOfPolices!  {
                (self.players?.object(at: i) as! Player).Role = "P"
            }else{
                (self.players?.object(at: i) as! Player).Role = "C"
            }
            
        }
        
        for i in 0..<number{
            
            print(((self.players?.object(at: i) as! Player).Role as String) + " ")
        }
        
        self.isStart = true
        self.gameState = "night"
        
        super.init()
    }
    
    func Announce(_ i:Int) ->String {
        
        return (self.players?.object(at: i) as! Player).Role
        
    }
    
    func isEnd() -> Int {
        if self.numOfPolices == 0 || self.numOfCommonP == 0 {
            return -1
        }else if self.numOfKillers == 0{
            return 1
        }else{
            return 0
        }
    }
    
}


protocol GameDelegate {
    
    
    
}



