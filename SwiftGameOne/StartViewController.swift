//
//  StartViewController.swift
//  SwiftGameOne
//
//  Created by Monstar on 16/7/25.
//  Copyright © 2016年 Monstar. All rights reserved.
//

import UIKit
import AVFoundation

let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height

class StartViewController: UIViewController , UIActionSheetDelegate, AVAudioPlayerDelegate {
    
    @IBOutlet weak var score: UILabel!
    
    var timer:NSTimer!
    var boomTimer:NSTimer!
    var belowImg:UIImageView!
    var audioPlayer:AVAudioPlayer!
    var boomAudioPlayer:AVAudioPlayer!
    
    var letfTime:Int = 99999
    var boomLeftTime:Int = 999
    var mark:Int = 0
    var GameOn: Bool!// true为正在游戏 false为游戏结束
    
    var index:UInt32!
    var boomIndex:UInt32!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        belowImg = UIImageView(frame: CGRectMake(self.view.frame.size.width/2-35, 0.85*self.view.frame.size.height+10, 70, 15))

        belowImg.image = UIImage(named: "belowBg.png")
        self.view.addSubview(belowImg)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(StartViewController.handlePanGesture(_:)))
        self.view .addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(StartViewController.handleTapGesture(_:)))
        
        self.view.addGestureRecognizer(tapGesture)
        
        tapGesture.numberOfTapsRequired = 1
        
        self.view.addGestureRecognizer(tapGesture)
        
        score.text = "当前积分" + String(mark)
        
        GameOn = true
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        playBgMusic()
        // 启用计时器，控制每秒执行一次tickDown方法
        timer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(1),
                                                       target:self,selector:#selector(StartViewController.tickDown),
                                                       userInfo:nil,repeats:true)
        
        // 启用计时器，控制每秒执行一次tickDown方法
        boomTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(1),
                                                           target:self,selector:#selector(StartViewController.boomDown),
                                                           userInfo:nil,repeats:true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        audioPlayer.stop()
        if GameOn == true {
            timer.invalidate()
            timer = nil
            boomTimer.invalidate()
            boomTimer = nil
        }
    }
    
    func playBgMusic(){
        let musicPath = NSBundle.mainBundle().pathForResource("bgMusic", ofType: "wav")
        //指定音乐路径
        let url = NSURL(fileURLWithPath: musicPath!)
        audioPlayer = try? AVAudioPlayer(contentsOfURL: url, fileTypeHint: nil)
        audioPlayer.numberOfLoops = -1
        //设置音乐播放次数，-1为循环播放
        audioPlayer.volume = 1
        //设置音乐音量，可用范围为0~1
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    func playBoomMusic(){
        let musicPath = NSBundle.mainBundle().pathForResource("boomMusic", ofType: "wav")
        //指定音乐路径
        let url = NSURL(fileURLWithPath: musicPath!)
        boomAudioPlayer = try? AVAudioPlayer(contentsOfURL: url, fileTypeHint: nil)
        boomAudioPlayer.numberOfLoops = 1
        //设置音乐播放次数，-1为循环播放
        boomAudioPlayer.volume = 1
        //设置音乐音量，可用范围为0~1
        boomAudioPlayer.prepareToPlay()
        boomAudioPlayer.play()
    }
    //隐藏顶部状态栏
    override func prefersStatusBarHidden()->Bool{
        return true
    }
    

    @IBAction func backBtn(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //手势
    
    func handlePanGesture(sender:UIPanGestureRecognizer) {
        //得到拖的过程中的xy坐标
        let location:CGPoint = sender.locationInView(self.view)
        belowImg.frame = CGRectMake(location.x - 35, belowImg.frame.origin.y, belowImg.frame.size.width, belowImg.frame.size.height)
    }
    func handleTapGesture(sender:UITapGestureRecognizer) {
        
        let location:CGPoint = sender.locationInView(self.view)
        belowImg.frame = CGRectMake(location.x - 35, belowImg.frame.origin.y, belowImg.frame.size.width, belowImg.frame.size.height)
    }
    func show() {
        var img = UIImageView(frame:CGRectMake(CGFloat(index), 0, 50, 50))
        {
            willSet(frameChange){
            
            }
        }
        img.image = UIImage(contentsOfFile:NSBundle.mainBundle().pathForResource(String(arc4random_uniform(5)), ofType: "png")!)
        img.tag = letfTime
        self.view.addSubview(img)
        UIView.animateWithDuration(5, delay: 0, options: .CurveLinear, animations: {
            img.frame = CGRectMake(CGFloat(self.index), SCREEN_HEIGHT, 50, 50)
            }, completion: nil)
    }
    func boomShow() {
        print(boomLeftTime)
        var img = UIImageView(frame:CGRectMake(CGFloat(boomIndex), 0, 50, 80)){
            willSet(frameChange){
            }
        }
        img.image = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("boom", ofType:"png")!)
        img.tag = boomLeftTime
        self.view.addSubview(img)
        
        if arc4random_uniform(2) == 0{
            UIView.animateWithDuration(2.5,delay: 0,options: .CurveLinear, animations: { 
                img.frame = CGRectMake(CGFloat(self.boomIndex)-50, SCREEN_HEIGHT, 50, 80)
            
                },completion: nil)
        }else{
            UIView.animateWithDuration(2.5,delay: 0,options: .CurveLinear, animations: { 
                img.frame = CGRectMake(CGFloat(self.boomIndex)-50, SCREEN_HEIGHT, 50, 80)
                
            },completion: nil)
        }
    }
    func boomDown()  {
        if GameOn == true{
            //如果剩余时间小于等于0
            if boomLeftTime <= 0{
                //取消定时器
                boomTimer.invalidate()
            }
            if boomLeftTime <= 997{
                let img = self.view.viewWithTag(boomLeftTime + 1)as!UIImageView
                
                if img.frame.origin.x > belowImg.frame.origin.x - 35{
                    if img.frame.origin.x < belowImg.frame.origin.x + 55
                    {
                        let aimg = self.view.viewWithTag(boomLeftTime + 1)as!UIImageView
                        aimg.hidden = true
                        mark = mark - 5
                        playBoomMusic()
                        gameOver()
                    }
                }
            }
            if boomLeftTime <= 994{
                let img = self.view.viewWithTag(boomLeftTime + 4)as!UIImageView
                img.removeFromSuperview()
            }
            boomLeftTime -= 1
            //修改UIDatePicker的剩余时间
            boomIndex = UInt32(SCREEN_WIDTH*0.87)
            boomIndex = arc4random_uniform(boomIndex)
            boomShow()
            
        }else{
            boomTimer.invalidate()
            boomTimer = nil
        }

    }
    
    func tickDown()  {
        if GameOn == true {
            if letfTime <= 0 {
                //取消定时器
                timer.invalidate()
            }
            if letfTime <= 99995{
                let img = self.view.viewWithTag(letfTime + 3)as!UIImageView
               
                if img.frame.origin.x > belowImg.frame.origin.x - 35{
                    if img.frame.origin.x < belowImg.frame.origin.x + 55 {
                        let aimg = self.view.viewWithTag(letfTime + 3)as!UIImageView
                        aimg.hidden = true;
                        
                        mark = mark + 1
                        score.text = "当前分数:" + String(mark)
                    }else{
                        mark = mark - 1
                        gameOver()
                    }
                    
                }else{
                    mark = mark - 1
                    gameOver()
                }
            }
            if letfTime <= 99994{
                let img = self.view.viewWithTag(letfTime + 4)as!UIImageView
                img.removeFromSuperview()
            }
            letfTime -= 1;
            //修改UIDatePicker的剩余时间
            index = UInt32(SCREEN_WIDTH * 0.87)
            index = arc4random_uniform(index)
            show()
        }else{
            timer.invalidate()
            timer = nil
        }
    }
    
    
    func gameOver() {
        if mark < 0 {
            GameOn = false
            self.mark = 0
            self.score.text = "当前分数：" + String(self.mark)
            
            let alertController = UIAlertController(title: "Game Over",
                                                    message: "是否继续？", preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: {
                action in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.Destructive, handler: {
                action in
                self.GameOn = true
                self.letfTime = 99999
                self.boomLeftTime = 999
                self.score.text = "当前分数：" + String(self.mark)
                
                // 启用计时器，控制每秒执行一次tickDown方法
                self.timer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(1),
                    target:self,selector:#selector(StartViewController.tickDown),
                    userInfo:nil,repeats:true)
                
                self.boomTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(1),
                    target:self,selector:#selector(StartViewController.boomDown),
                    userInfo:nil,repeats:true)
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }else {
            score.text = "当前分数：" + String(mark)
        }
    }
}