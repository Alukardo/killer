//
//  Player.swift
//  Killer
//
//  Created by  qztcm09 on 16/6/22.
//  Copyright © 2016年  qztcm09. All rights reserved.
//

import Foundation

class Player: NSObject {
    
    var playID:Int = 0
    
    var Role:String = ""
    
    var State:Int = 10 // （十位）生1／死0   （个位）验1/为0
    
    func setplayID(_ id:Int) {
        
        self.playID  = id
    }
    func getplayID()->Int {
        
        return self.playID
    }
    
    func kill(_ index:Int) -> Bool {
        
        return true
    }
    
    func check(_ index:Int) -> Bool {
        
        return true
        
    }
    func vote(_ index:Int) -> Bool {
        
        return true
    }
    func speak() {}
    
}
