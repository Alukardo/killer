//
//  PlaListViewController.swift
//  Killer
//
//  Created by  qztcm09 on 16/6/27.
//  Copyright © 2016年  qztcm09. All rights reserved.
//

import UIKit

class PlaListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,ServerDelegate,ClientDelegate{
    
    @IBOutlet weak var playList: UITableView!
    @IBOutlet weak var startButton: UIButton!
    
   
    var  servermorr:Server = killerServer
    var  clientmorr:Client = killerClient
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.servermorr.delegate = self
        self.clientmorr.delegate = self
        
        if killerServer.isMainSer == true {
            self.startButton.isEnabled = true
        }else{
            self.startButton.isEnabled = false
        }
        

    }
    @IBAction func comandToBegin(_ sender: UIButton) {
        
        killerClient.sendMessage(msgtosend: ["cmd":"begin"])
        
    }
    func getServersMessage(_ msg:NSDictionary){
        
        let cmd:String=msg["cmd"] as! String
        
        switch(cmd){
        case "begin":
//            print("Game begin")
            killerClient.numOFP = Int(msg["GameNum"] as! String)!
            
            let myStoryBoard = self.storyboard
            let anotherView:UIViewController? = myStoryBoard?.instantiateViewController(withIdentifier: "game")
            anotherView?.loadView()
            self.present(anotherView!, animated: true, completion: nil)
            
        default: break
           
        }
    }
    func updateplayerList(){
        
//        print("work!!!")
        self.playList.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return killerServer.clients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "player", for: indexPath)
        cell.textLabel?.text = killerServer.clients[(indexPath as NSIndexPath).row].username
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
