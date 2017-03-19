//
//  Browser.swift
//  Killer
//
//  Created by  qztcm09 on 16/6/16.
//  Copyright © 2016年  qztcm09. All rights reserved.
//

import Foundation

class Browser: NSObject,NetServiceDelegate,NetServiceBrowserDelegate{
    
    var servers:NSMutableArray?
    //var Services:NSMutableArray?
    
    var Service:NetService?
    var netServiceBrowser:NetServiceBrowser?
    var delegate:BrowserDelegate?
    
    //MARK: Function
    override init() {
        super.init()
        servers = []
        
    }
    
    func start()->Bool{
        
        
        
        if self.netServiceBrowser != nil {
            servers?.removeAllObjects()
            self.stop()
        }
        self.netServiceBrowser = NetServiceBrowser.init()
        if( (self.netServiceBrowser == nil) ) {
            return false
        }else{
            
            self.netServiceBrowser!.delegate = self
            self.netServiceBrowser!.searchForServices(ofType: "_spider._tcp.", inDomain: "local.")
            return true
        }
        
    }
    func stop(){
        
        if ( self.netServiceBrowser != nil ) {
            self.netServiceBrowser?.stop()
            self.netServiceBrowser = nil
        }
        self.servers?.removeAllObjects()
    }
    
    //MARK:NetServiceBrowserDelegate
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        //NSLog("FindService")
        if ((self.servers?.contains(service)) != nil) {
            self.servers?.add(service)
        }
        if moreComing {
            return
        }
        delegate?.updateServerList(self.servers)
        
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {
        self.servers?.remove(service)
        if moreComing {
            return
        }
        delegate?.updateServerList(self.servers)
        
    }
    
}
//MARK: BrowserDelegate
protocol BrowserDelegate {
    
    func updateServerList(_ servers:NSMutableArray?)
    
}

