//
//  ViewController.swift
//  CXPlayer
//
//  Created by fengyan on 16/2/16.
//  Copyright © 2016年 fengyan. All rights reserved.
//

import UIKit
//import AVKit
//import AVFoundation
import MediaPlayer
/// GitHub开源库
import Alamofire
import Kingfisher


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var notificationCenter = NSNotificationCenter()
    var moviePlayer = MPMoviePlayerController()
    var MediaTableView = UITableView()
    let loadingAni = UIActivityIndicatorView()
    let refreshControl = UIRefreshControl()
    
    /// 加载视频时的背景图
    var backmovieplayer = UIImageView()
    
    /// 接收请求回来数据的存储
    var array=NSArray()
    var Marray=NSMutableArray()
    
    /// 视频url转码
    var urlStr:NSString!
    var urlString:NSString!
    var url:NSURL!
    
    /// 设置空值，swift中if不会默认和0作比较
    let optionname:String?=nil
    
//    var PlayView = AVPlayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.MediaTableView=UITableView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height), style: UITableViewStyle.Plain)
        MediaTableView.delegate=self
        MediaTableView.dataSource=self
        MediaTableView.registerClass(MediaCell.self, forCellReuseIdentifier: "video")
        view.addSubview(MediaTableView)
        loadingAni.activityIndicatorViewStyle=UIActivityIndicatorViewStyle.WhiteLarge
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "松开后自动刷新")
        MediaTableView.addSubview(refreshControl)
        refreshData()
    }
    func refreshData(){
        Alamofire.request(.GET,"http://c.3g.163.com/nc/video/list/V9LG4B3A0/y/0-5.html").responseJSON {  response  in
            if response.result.isSuccess {
             //  print("---\(response.response)")
              // print("q--q\(response.result.value)")
              self.array=(response.result.value?.objectForKey("V9LG4B3A0")) as! NSArray
                for dic in self.array {
                    let medol = MediaModel()
                    medol.setModelValue(dic as! NSDictionary)
                    self.Marray.addObject(medol)
                }
                self.refreshControl.endRefreshing()
                self.MediaTableView.reloadData()
                
            }
            else{
               print("l====l\(response.result.error)")
            }
            
        }
    }
    /**
    *  支持横竖屏显示
    */
    func supportedInterfaceOrientations(OptionSetType:UIInterfaceOrientationMask)-> UIInterfaceOrientationMask{
        return UIInterfaceOrientationMask.All
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Marray.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = MediaTableView.dequeueReusableCellWithIdentifier("video", forIndexPath: indexPath) as! MediaCell
        let model = Marray[indexPath.row] as! MediaModel
        cell.selectionStyle=UITableViewCellSelectionStyle.None
        cell.btnimage.kf_setImageWithURL(NSURL(string: model.imageName)!, placeholderImage: Image(named: "1"))
        cell.Labeltitle.text=model.title;
        cell.playcountLabel.text=String(model.playCount)
        var second = String()
        if model.playLength%60 < 10{
            second = "0" + String(model.playLength%60)
        }
        else{
            second = String(model.playLength%60)
        }
        cell.playtimeLabel.text="\(model.playLength/60):\(second)";
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 280
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if moviePlayer.playbackState==MPMoviePlaybackState.Playing || moviePlayer.playbackState==MPMoviePlaybackState.Paused {
            backmovieplayer.removeFromSuperview()
            moviePlayer.view.removeFromSuperview()
            moviePlayer.stop()
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = Marray[indexPath.row] as! MediaModel
        urlStr = model.mp4_url
        urlString=urlStr!.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        url=NSURL(string: String(urlString))
       // let path = NSBundle.mainBundle().pathForResource("emoji zone", ofType: "mp4")
        if moviePlayer.view != optionname{
            moviePlayer.view.removeFromSuperview()
            backmovieplayer.removeFromSuperview()
        }
        moviePlayer.contentURL=url
        moviePlayer.view.autoresizingMask = UIViewAutoresizing.None
        moviePlayer.view.frame=CGRectMake(10, CGFloat(indexPath.row)*280+20, view.frame.size.width-20, 210)
        loadingAni.frame=CGRectMake(moviePlayer.view.bounds.width/2-18.5, moviePlayer.view.bounds.height/2-18.5, 37, 37)
        MediaTableView.addSubview(moviePlayer.view)
        backmovieplayer.frame=CGRectMake(0, 0, view.frame.size.width-20, 210)
        backmovieplayer.image=UIImage(named: "night_sidebar_cellhighlighted_bg")
        moviePlayer.view.addSubview(backmovieplayer)
        backmovieplayer.addSubview(loadingAni)
        addNotification()
        loadingAni.startAnimating()
        
    }
    func addNotification(){
        notificationCenter=NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: Selector("mediaPlayerPlaybackStateChange:"), name: MPMoviePlayerPlaybackStateDidChangeNotification, object: moviePlayer)
        if moviePlayer.respondsToSelector(Selector("loadState"))  {
            moviePlayer.prepareToPlay()
        }
        else{
            moviePlayer.play()
        }
        notificationCenter.addObserver(self, selector: Selector("mediaPlayerPlayFinished:"), name: MPMoviePlayerPlaybackDidFinishNotification, object: moviePlayer)
       
    }
    /**
     *  播放状态改变，注意播放完成时的状态是暂停
     *
     *  @param notification 通知对象
     */
    func mediaPlayerPlaybackStateChange(notification:NSNotification){
        loadingAni.stopAnimating()
        backmovieplayer.removeFromSuperview()
        if moviePlayer.loadState != MPMovieLoadState.Unknown{
            switch(moviePlayer.playbackState){
            case MPMoviePlaybackState.Playing:
                print("正在播放...")
            case MPMoviePlaybackState.Paused:
                print("暂停播放...")
            case MPMoviePlaybackState.Stopped:
                print("停止播放....")
            default:
                print("播放状态:\(moviePlayer.playbackState)")
            }
        }
        notificationCenter.removeObserver(self, name: MPMoviePlayerPlaybackStateDidChangeNotification, object: moviePlayer)
        notificationCenter.removeObserver(self, name: MPMoviePlayerPlaybackDidFinishNotification, object: moviePlayer)
   }
    /**
    *  播放完成
    *
    *  @param notification 通知对象
    */
    func mediaPlayerPlayFinished(notification:NSNotification){
    //NSLog(@"播放完成.%li",self.moviePlayer.playbackState);
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

