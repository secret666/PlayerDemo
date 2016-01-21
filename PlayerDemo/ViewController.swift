//
//  ViewController.swift
//  PlayerDemo
//
//  Created by secret on 16/1/6.
//  Copyright © 2016年 secret. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices
import AVKit

class ViewController: UIViewController,ChooseFileDelegate {
    
    var moviePlayer:AVPlayerViewController!
    var moviePlayerViewController:AVPlayerViewController!
    
    var filePath:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        filePath = NSBundle.mainBundle().pathForResource("movie", ofType: "mp4")!
//        (contentURL: NSURL.fileURLWithPath(filePath))
        moviePlayer = AVPlayerViewController()
        
        moviePlayer.view.frame = CGRectMake(20, 30, 200, 200)
        moviePlayer.view.backgroundColor = UIColor.redColor()
        self.view.addSubview(moviePlayer.view)
        
        
//        moviePlayer.controlStyle = .Embedded
//        moviePlayer.scalingMode = .AspectFit
        
        (contentURL: NSURL.fileURLWithPath(filePath))
        moviePlayerViewController = AVPlayerViewController(nibName: filePath, bundle: NSBundle.mainBundle())
        
//        let longpress:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "playMovieFullOrSmall:")
//        moviePlayer.view.addGestureRecognizer(longpress)
    }
    
    @IBAction func movieButton(sender: UIButton) {
        
        switch sender.tag{
            
        case 101:
            
            
            
            break
        case 102:
            break
        case 103:
            break
        default :
            break
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let chooseVC:ChooseFileTableViewController = segue.destinationViewController as! ChooseFileTableViewController
        chooseVC.delegate = self
    }
    
    func didChooseFileName(fileNmae: String) {
        print("fileName ---------- \(fileNmae)")
        filePath = NSBundle.mainBundle().pathForResource(fileNmae, ofType: "mp4")!
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

