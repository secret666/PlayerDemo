//
//  ViewController1.swift
//  PlayerDemo
//
//  Created by secret on 16/1/7.
//  Copyright © 2016年 secret. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices

class ViewController1: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ChooseFileDelegate {
    var moviePlayer:MPMoviePlayerController!
    var moviePlayerController:MPMoviePlayerViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        // Do any additional setup after loading the view.
        
        
        //加载MP4路径
        let filePath:String = NSBundle.mainBundle().pathForResource("movie", ofType: "mp4")!
         moviePlayer = MPMoviePlayerController(contentURL: NSURL.fileURLWithPath(filePath))
        moviePlayer.view.frame = self.view.bounds
        moviePlayer.view.backgroundColor = UIColor.redColor()
        self.view.addSubview(moviePlayer.view)
        moviePlayer.play()
        //controlStyle播放方式  None 什么都没有，即进度条，暂停键等均没有  Embedded 只留有一部分，暂停，进度条，全屏键   Fullscreen 全部都在
        moviePlayer.controlStyle = .Fullscreen
        //scalingMode 缩放 AspectFill 等比等宽扩大  AspectFit正常大小 Fill 满屏  None没有变化
        moviePlayer.scalingMode = .AspectFill
        
        
        moviePlayerController = MPMoviePlayerViewController(contentURL: NSURL.fileURLWithPath(filePath))
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "moviePlayerNotificationMethod:", name: MPMoviePlayerDidEnterFullscreenNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "moviePlayerNotificationMethod:", name: MPMoviePlayerDidExitFullscreenNotification, object: nil)
    }
    
    
    
    func moviePlayerNotificationMethod(info:NSNotification) {
        print("info --------- \(info)")
        switch info.name {
        case "MPMoviePlayerDidEnterFullscreenNotification":
            moviePlayer.play()
        case "MPMoviePlayerDidExitFullscreenNotification":
            moviePlayer.pause()
        default :
            moviePlayer.stop()
        }
    }
    
    func takeCamera(sender:AnyObject){
        //检查相机是否可用
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            print("没有相机")
            return
        }else{
            self.imagePickerControllerStatus(UIImagePickerControllerSourceType.Camera)
        }
    }
    
    func imagePickerControllerStatus(imageState:UIImagePickerControllerSourceType){
        let videoPicker = UIImagePickerController()
        videoPicker.delegate = self
        videoPicker.sourceType = imageState
        videoPicker.mediaTypes = [kUTTypeMovie as String]
        if imageState == UIImagePickerControllerSourceType.Camera{
            self.videoRecorderController(videoPicker)
        }
        videoPicker.allowsEditing = true
        self.presentViewController(videoPicker, animated: true) { () -> Void in
            
        }
    }
    
    func videoRecorderController(imagePicker:UIImagePickerController){
        imagePicker.videoMaximumDuration = 30
        imagePicker.videoQuality = UIImagePickerControllerQualityType.TypeMedium
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let paths:NSArray = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documensPath:String = paths[0] as! String
        var filePath = documensPath.stringByAppendingString("/video.mov")
        let infoDic:NSDictionary = info as NSDictionary
        let stateStr:NSString = infoDic.objectForKey(UIImagePickerControllerMediaType) as! NSString
        if stateStr.isEqualToString(kUTTypeMovie as String){
            let movieUrl:NSURL!
            let mediaUrl:NSURL = (infoDic.objectForKey(UIImagePickerControllerMediaURL) as? NSURL)!
            let mediaUrlStr = mediaUrl.absoluteString
            movieUrl = infoDic.objectForKey(UIImagePickerControllerMediaURL) as? NSURL
            let movieData = NSData(contentsOfURL: movieUrl)
            //            let error:NSError?
            
            if NSFileManager.defaultManager().fileExistsAtPath(filePath){
                let dateFormat:NSDateFormatter = NSDateFormatter()
                dateFormat.dateFormat = "yyyy-MM-dd-HH-mm"
                let dateStr = dateFormat.stringFromDate(NSDate())
                let fileName = "/video-\(dateStr).mov"
                filePath = documensPath.stringByAppendingString(fileName)
            }
            
            //因为第一次运行该路径并不存在，所以， 写入方法需写在判断文件是否存在的外面
            //            do{
            //
            //            }catch error{
            //
            //            }
            //            error = error
            
            if ((try! movieData?.writeToFile("\(filePath)", options: NSDataWritingOptions.DataWritingAtomic)) != nil) {
                let alert:UIAlertController = UIAlertController(title: "警告", message: "当前movie发生异常", preferredStyle: UIAlertControllerStyle.Alert)
                alert.showViewController(self, sender: nil)
            }else{
                self.moviePlayer.contentURL = NSURL.fileURLWithPath(filePath)
                self.moviePlayer.play()
            }
            
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                
            })
            
        }
    }
    
    func chooseVideoforLibrary(sender: AnyObject){
        self.imagePickerControllerStatus(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let chooseVC:ChooseFileTableViewController = segue.destinationViewController as! ChooseFileTableViewController
        chooseVC.delegate = self
    }
    
    func didChooseFileName(fileName: NSURL){
        moviePlayer.contentURL = fileName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
