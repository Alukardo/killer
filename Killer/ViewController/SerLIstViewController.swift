//
//  ViewController.swift
//  hangge_756
//
//  Created by hangge on 16/4/4.
//  Copyright © 2016年 hangge.com. All rights reserved.
//

import UIKit

class SerListViewController: UIViewController,NetServiceDelegate,NetServiceBrowserDelegate,UITableViewDelegate,UITableViewDataSource,BrowserDelegate{
    
    @IBOutlet weak var ServersList: UITableView!
    
    var browser:Browser?
    //socket客户端类对象
    var socketClient:TCPClient?
    
    var ServiceList:NSMutableArray?
    var targetServer:Int = 0
    let localServer:String = local
    
    var msg:NSDictionary?
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.ServiceList = NSMutableArray()
        
        self.browser =  Browser()
        self.browser?.delegate = self
        _ = self.browser?.start()
        
    }
    
    @IBAction func createServer(_ sender: UIButton) {
        
        
        
        //启动服务器
        killerServer.start(localServer)
        killerServer.isMainSer = true
                
        let popTime = DispatchTime.now() + Double(Int64(1.0)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: popTime) {
           
            killerClient.processClientSocket(self.localServer)
            
        }


        

        
    }
    
    @IBAction func updataServerList(_ sender: UIButton) {
        
        _ = self.browser?.start()

        
    }
    @IBAction func connectTargetServer(_ sender: UIButton) {
        
        
        killerClient.connect((self.ServiceList?.object(at: self.targetServer))! as! NetService)
            
        
    }
    //MARK: - BrowserDelegate
    func updateServerList(_ servers:NSMutableArray?){
        
        self.ServiceList = servers
        self.ServersList?.reloadData()
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (self.ServiceList?.count)!
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "server", for: indexPath)
        cell.textLabel?.text = (self.ServiceList!.object(at: (indexPath as NSIndexPath).row) as AnyObject).name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.targetServer = (indexPath as NSIndexPath).row
        print(self.targetServer)
        
    }
    
    
}
