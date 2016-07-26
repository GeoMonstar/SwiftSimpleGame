//
//  ViewController.swift
//  SwiftGameOne
//
//  Created by Monstar on 16/7/25.
//  Copyright © 2016年 Monstar. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(animated: Bool) {
        playBgMusic()
    }
    override func viewWillDisappear(animated: Bool) {
        audioPlayer.stop()
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    func playBgMusic() {
        let musicPath = NSBundle.mainBundle().pathForResource("startMusic", ofType: "wav")
        //指定音乐路径
        let url = NSURL(fileURLWithPath: musicPath!)
        audioPlayer = try?AVAudioPlayer(contentsOfURL: url,fileTypeHint: nil)
        audioPlayer.numberOfLoops = -1
        audioPlayer.volume = 0.5
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    @IBAction func StartGame(sender: AnyObject) {
        let sb = UIStoryboard(name:"Main",bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("StartViewController")as!StartViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
 
}
