//
//  TweetCell.swift
//  Twitter
//
//  Created by Celeste Gambardella on 10/5/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetContent: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoriteCount: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    
    var favorited:Bool = false
    var retweeted:Bool = false
    var tweetId:Int = -1
    var favCount:Int = -1
    var reCount:Int = -1
    
    func setFavorite(_ isFavorited:Bool) {
        favorited = isFavorited
        if (favorited) {
            favButton.setImage(UIImage(named:"favor-icon-red"), for: UIControl.State.normal)
        } else {
            favButton.setImage(UIImage(named:"favor-icon"), for: UIControl.State.normal)
        }
    }
    
    func setRetweet(_ isRetweeted:Bool) {
        retweeted = isRetweeted
        if (isRetweeted) {
            retweetButton.setImage(UIImage(named:"retweet-icon-green"), for: UIControl.State.normal)
            
//            retweetButton.isEnabled = false
            
        } else {
            retweetButton.setImage(UIImage(named:"retweet-icon"), for: UIControl.State.normal)
            
//            retweetButton.isEnabled = true
        }
    }
    
    @IBAction func favoriteTweet(_ sender: Any) {
        
        let tobeFavorited = !favorited
        
        if (tobeFavorited) {
            TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {
                    self.setFavorite(true)
                }, failure: { (error) in
                    print("Favorite did not succeed: \(error)")
                })
            
            favCount += 1
            favoriteCount.text = String(favCount)
            
        } else {
            TwitterAPICaller.client?.unfavoriteTweet(tweetId: tweetId, success: {
                self.setFavorite(false)
            }, failure: { (error) in
                print("Unfavorite did not succeed: \(error)")
            })
            
            favCount -= 1
            if (favCount > -1) {
                favoriteCount.text = String(favCount)
            } else {
                favoriteCount.text = String(0)
            }
            
        }
    }
    
    @IBAction func retweetTweet(_ sender: Any) {
        let tobeRetweet = !retweeted
        
        if (tobeRetweet) {
            TwitterAPICaller.client?.retweet(tweetId: tweetId, success: {
                self.setRetweet(true)
                }, failure: { (error) in
                    print("Retweet did not succeed: \(error)")
                })
           
            reCount += 1
            retweetCount.text = String(reCount)
            
        } else {
            TwitterAPICaller.client?.unretweet(tweetId: tweetId, success: {
                self.setRetweet(false)
            }, failure: { (error) in
                print("Error undoing retweet: \(error)")
            })
            
            reCount -= 1
            
            if (reCount > -1) {
                retweetCount.text = String(reCount)
            } else {
                retweetCount.text = String(0)
            }
            
        }
    }
    
    @IBAction func replyTwwet(_ sender: Any) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
