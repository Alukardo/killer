//
//  SecondViewController.swift
//  Killer
//
//  Created by  qztcm09 on 16/6/11.
//  Copyright © 2016年  qztcm09. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController,UITableViewDelegate,ClientDelegate{
    
    @IBOutlet weak var PlayPand: UIView!
    @IBOutlet weak var commit: UIButton!
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var pID: UILabel!
    @IBOutlet weak var role: UILabel!
    //MARK:
    //-----------------------------------------
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.brown
        //self.PlayPand.backgroundColor = UIColor.brownColor()
        
        //self.PlayPand.bounds = CGRectMake(8, 32, UIScreen.mainScreen().bounds.width-16, UIScreen.mainScreen().bounds.width-16)
        
        killerClient.delegate = self
        self.initGameBroard(killerClient.numOFP)
        killerClient.sendMessage(msgtosend: ["cmd":"info"])
        killerClient.sendMessage(msgtosend: ["cmd":"update"])
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    //MARK:
    //-----------------------------------------
    func initGameBroard(_ numofPlayer:Int){
        
        
        let width = self.PlayPand.frame.width
        let height = self.PlayPand.frame.height
        let busize = CGFloat(20)
        
        for i in 0 ..< numofPlayer {
            let playerButton = UIButton.init(type: .custom)
            playerButton.setTitle("\(i)", for: UIControlState())
            playerButton.tag = 16+i
            let location = LogicUnity().locatePlayer(width/2, centerY: height/2, r: width/3, angle: CGFloat(360*i/numofPlayer))
            playerButton.frame = CGRect(x: location.x-busize/2, y: location.y-busize/2, width: busize, height: busize)
            
            playerButton.backgroundColor = UIColor.yellow
            playerButton.addTarget(self, action: #selector(SecondViewController.choose(_:)) , for: UIControlEvents.touchUpInside)
            self.PlayPand.addSubview(playerButton)
        }
        
    }
    func choose(_ sender: UIButton){
        self.info.text = sender.currentTitle
    }
    
    @IBAction func commit(_ sender: UIButton) {
        
        killerClient.delegate = self
        
        killerClient.sendMessage(msgtosend: ["cmd":"update"])
        
        if killerClient.CGame?.gameState == "daytime" {
            if self.commit.currentTitle == "Choose a Player" {
                killerClient.sendMessage(msgtosend: ["cmd":"vote","taget":"-1","voter":"\(killerClient.Pid)"])
            }else{
                killerClient.sendMessage(msgtosend: ["cmd":"vote","taget":self.commit.currentTitle!,"voter":"\(killerClient.Pid)"])
            }
        }
        
    }
    func getServersMessage(_ msg:NSDictionary) {
        
        if msg["cmd"] as? String == "info" {
            self.pID.text = msg["ID"] as? String
            self.role.text = msg["Role"] as? String
            killerClient.Pid = Int(msg["ID"] as! String)!
            killerClient.Role = msg["Role"] as? String
            
            if killerClient.Pid != -1 {
                (self.PlayPand.subviews[killerClient.Pid] as! UIButton).isEnabled = false
            }
            
            
            
        }
        else if msg["cmd"] as? String == "update"{
            
            switch msg["GameStat"] as! String {
            case "daytime":
                self.PlayPand.backgroundColor =  UIColor.white
            case "night":
                self.PlayPand.backgroundColor =  UIColor.black
            default:
                break
            }
            if killerClient.numOFP != -1 {
                
                
                for i in 0..<killerClient.numOFP{
                    
                    if killerClient.Role == "K"  {
                        
                        if msg["R\(i)"] as? String == "K" {
                            (self.PlayPand.subviews[i] as! UIButton).isEnabled = false
                            
                            if msg["S\(i)"] as? String == "10" || msg["S\(i)"] as? String == "11" {
                                self.PlayPand.subviews[i].backgroundColor = UIColor(red: 255, green: 0, blue: 0, alpha: 1)
                            }else{
                                self.PlayPand.subviews[i].backgroundColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.3)
                            }
                        }
                        else{
                            if msg["S\(i)"] as? String == "10" || msg["S\(i)"] as? String == "11" {
                                self.PlayPand.subviews[i].backgroundColor = UIColor(red: 255, green: 255, blue: 0, alpha: 1)
                            }else{
                                self.PlayPand.subviews[i].backgroundColor = UIColor(red: 255, green: 255, blue: 0, alpha: 0.3)
                            }
                        }
                        
                    }
                    if killerClient.Role == "P"  {
                        
                        if msg["R\(i)"] as? String == "P" {
                            
                            (self.PlayPand.subviews[i] as! UIButton).isEnabled = false
                            
                            if msg["S\(i)"] as? String == "10" || msg["S\(i)"] as? String == "11" {
                                self.PlayPand.subviews[i].backgroundColor = UIColor(red: 0, green: 255, blue: 0, alpha: 1)
                            }else{
                                self.PlayPand.subviews[i].backgroundColor = UIColor(red: 0, green: 255, blue: 0, alpha: 0.3)
                            }
                        }
                        else if msg["R\(i)"] as? String == "K"{
                            
                            switch msg["S\(i)"] as! String {
                            case "11":
                                self.PlayPand.subviews[i].backgroundColor = UIColor(red: 255, green: 0, blue: 0, alpha: 1)
                            case "10":
                                self.PlayPand.subviews[i].backgroundColor = UIColor(red: 255, green: 255, blue: 0, alpha: 1)
                            case "01":
                                self.PlayPand.subviews[i].backgroundColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.3)
                            case "00":
                                self.PlayPand.subviews[i].backgroundColor = UIColor(red: 255, green: 255, blue: 0, alpha: 0.3)
                            default:
                                break
                            }
                        }
                        else if msg["R\(i)"] as? String == "C"{
                            
                            switch msg["S\(i)"] as! String {
                            case "11":
                                self.PlayPand.subviews[i].backgroundColor = UIColor(red: 0, green: 0, blue: 255, alpha: 1)
                            case "10":
                                self.PlayPand.subviews[i].backgroundColor = UIColor(red: 255, green: 255, blue: 0, alpha: 1)
                            case "01":
                                self.PlayPand.subviews[i].backgroundColor = UIColor(red: 0, green: 0, blue: 255, alpha: 0.3)
                            case "00":
                                self.PlayPand.subviews[i].backgroundColor = UIColor(red: 255, green: 255, blue: 0, alpha: 0.3)
                            default:
                                break
                            }
                        }
                        
                    }
                    if killerClient.Role == "C"{
                        if i != killerClient.Pid{
                            switch msg["S\(i)"] as! String {
                            case "11":
                                self.PlayPand.subviews[i].backgroundColor = UIColor(red: 255, green: 255, blue: 0, alpha: 1)
                            case "10":
                                self.PlayPand.subviews[i].backgroundColor = UIColor(red: 255, green: 255, blue: 0, alpha: 1)
                            case "01":
                                self.PlayPand.subviews[i].backgroundColor = UIColor(red: 255, green: 255, blue: 0, alpha: 0.3)
                            case "00":
                                self.PlayPand.subviews[i].backgroundColor = UIColor(red: 255, green: 255, blue: 0, alpha: 0.3)
                            default:
                                break
                            }
                        }else{

                            switch msg["S\(i)"] as! String {
                            case "11":
                                self.PlayPand.subviews[i].backgroundColor = UIColor(red: 0, green: 0, blue: 255, alpha: 1)
                            case "10":
                                self.PlayPand.subviews[i].backgroundColor = UIColor(red: 0, green: 0, blue: 255, alpha: 1)
                            case "01":
                                self.PlayPand.subviews[i].backgroundColor = UIColor(red: 0, green: 0, blue: 255, alpha: 0.3)
                            case "00":
                                self.PlayPand.subviews[i].backgroundColor = UIColor(red: 0, green: 0, blue: 255, alpha: 0.3)
                            default:
                                break
                            }
                        }
                        
                        
                    }
                    
                }
                
            }
            
        }
    }
    
    
}

