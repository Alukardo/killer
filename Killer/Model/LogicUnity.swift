//
//  LogicUnity.swift
//  Killer
//
//  Created by  qztcm09 on 16/6/22.
//  Copyright © 2016年  qztcm09. All rights reserved.
//

import Foundation
import CoreGraphics


class LogicUnity: NSObject {
    
    
    func locatePlayer(_ centerX:CGFloat,centerY:CGFloat,r:CGFloat,angle:CGFloat) -> CGPoint {
        
        let radian = CGFloat(M_PI/180.0) * angle
        let x = centerX + cos(radian) * r
        let y = centerY + sin(radian) * r
        return CGPoint(x: x, y: y)
    }
    
    
}
