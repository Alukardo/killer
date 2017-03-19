//
//  VotingCounter.swift
//  Killer
//
//  Created by  qztcm09 on 16/7/3.
//  Copyright © 2016年  qztcm09. All rights reserved.
//

import Foundation
class VotingCounter: NSObject {
    
    var voteTars = [voteTar]()
    
    func voteinit(){
        
        self.voteTars.removeAll()
        print("work!")
    }
    
    func countingVote(_ msg:NSDictionary) {
        
        let targe = msg["taget"] as! String
        let voter = msg["voter"] as! String
        var find = false
        
        for v:voteTar in voteTars {
            
            if v.voteTarget == targe  {
                v.voter.append(voter)
                v.vconnter += 1
                find = true
                break
            }
        }
        if find == false {
            let ev = voteTar()
            ev.voteTarget = targe
            ev.voter.append(voter)
            ev.vconnter = 1
        }
        
    }
    
    func resulter() -> [String] {
        
        var max = -1
        var dis:[String] = []
        
        for v:voteTar in voteTars {
            
            if v.vconnter > max {
                max = v.vconnter
            }
            
        }
        
        if max != -1 {
            for v:voteTar in voteTars {
                if v.vconnter == max {
                    dis.append(v.voteTarget!)
                }
            }
        }
        
        voteTars.removeAll()
        
        return dis
    }
    
}
class voteTar: NSObject {
    var voteTarget:String?
    var voter:[String] = []
    var vconnter:Int = 0
}
