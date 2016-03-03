//
//  MediaCell.swift
//  CXPlayer
//
//  Created by fengyan on 16/2/16.
//  Copyright © 2016年 fengyan. All rights reserved.
//

import UIKit

class MediaCell: UITableViewCell {
   // let btn = UIImageView()
    let myImageView = UIImageView()
    let Labeltitle = UILabel()
    let btnimage = UIImageView()
    let playcountLabel = UILabel()
    let playcountImage = UIImageView()
    let playtimeLabel = UILabel()
    let playtimeImage=UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        laycell()
        return
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func laycell(){
//        btn.frame=CGRectMake(10, 20, UIScreen.mainScreen().bounds.width-20, 210)
//        contentView.addSubview(btn)
        btnimage.frame=CGRectMake(10, 20, UIScreen.mainScreen().bounds.width-20, 210)
       // btnimage.image=UIImage(named: "1.png")
        contentView.addSubview(btnimage)
        myImageView.frame=CGRectMake(UIScreen.mainScreen().bounds.width/2-30, 90, 40, 40)
        myImageView.image=UIImage(named: "audionews_index_play")
        btnimage.addSubview(myImageView)
        Labeltitle.frame=CGRectMake(10, 235, UIScreen.mainScreen().bounds.width, 20)
        Labeltitle.font=UIFont.systemFontOfSize(14)
        contentView.addSubview(Labeltitle)
        playcountLabel.frame=CGRectMake(30, 255, 250, 15)
        playcountLabel.font=UIFont.systemFontOfSize(10)
        contentView.addSubview(playcountLabel)
        playcountImage.frame=CGRectMake(10, 255, 15, 15)
        playcountImage.image=UIImage(named: "night_video_list_cell_count")
        contentView.addSubview(playcountImage)
        playtimeLabel.frame=CGRectMake(UIScreen.mainScreen().bounds.width-40, 255, 45, 15)
        playtimeLabel.font=UIFont.systemFontOfSize(10)
        contentView.addSubview(playtimeLabel)
        playtimeImage.frame=CGRectMake(UIScreen.mainScreen().bounds.width-60, 255, 15, 15)
        playtimeImage.image=UIImage(named: "night_audionews_indexheader_recent")
        contentView.addSubview(playtimeImage)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
    
}




