//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Celeste Gambardella on 10/5/20.
//  Copyright © 2020 Dan. All rights reserved.
//
import UIKit

class HomeTableViewController: UITableViewController {
    var currentDate = Date()
    var tweetArray = [NSDictionary]()
    var tweetCount: Int!
    var numberOfTweets: Int!
    
    let myRefreshControl = UIRefreshControl()
    
    @IBOutlet weak var profileBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var logoutBarButtonItem: UIBarButtonItem!
    @IBOutlet var tweetTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // styling the bar button items
        profileBarButtonItem.tintColor = .white
        logoutBarButtonItem.style = .done
        
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        self.tableView.refreshControl = myRefreshControl
        self.tweetTable.refreshControl = myRefreshControl
        self.tweetTable.rowHeight = UITableView.automaticDimension
        self.tweetTable.estimatedRowHeight = 150
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTweets()
        
    }
    
    
    func getTimeElapsed(date: String) -> String {
        
        let dateFormat = "E, MMM d HH:mm:ss Z yyyy"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let currentDate = Date()
        let creationTime = dateFormatter.date(from: date)
        
        let dayHourMinuteSecond: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: creationTime!, to: currentDate)
        
        let seconds = "\(difference.second ?? 0)s"
        let minutes = "\(difference.minute ?? 0)m"
        let hours = "\(difference.hour ?? 0)h"
        let days = "\(difference.day ?? 0)d"
        let months = "\(difference.month ?? 0)M"
        if difference.month ?? 0 > 0 { return months }
        if difference.day ?? 0 > 0 { return days }
        if difference.hour ?? 0  > 0 { return hours }
        if difference.minute ?? 0  > 0 { return minutes }
        if difference.second ?? 0  > 0 { return seconds }
        return ""
        
    }
    
    @objc func loadTweets() {
        
        numberOfTweets = 20
        
        let homeUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let params = ["count": numberOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: homeUrl, parameters: params as [String: Any], success: { (tweets: [NSDictionary]) in
            
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
            
        }, failure: { (Error) in
            print("Could not recieve tweets! Oh no!! ")
        })
    }
    
    func loadMoreTweets() {
        
        let homeUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberOfTweets += 20
        
        let params = ["count": numberOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: homeUrl, parameters: params as [String: Any], success: { (tweets: [NSDictionary]) in
            
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
            
        }, failure: { (Error) in
            print("Could not recieve tweets! Oh no!! ")
        })
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweets()
        }
    }
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        
        cell.usernameLabel.text = user["name"] as? String
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        
        // getting tweet stats
        let retweetCount = "\(tweetArray[indexPath.row]["retweet_count"] ?? 0)"
        let favoriteCount = "\(tweetArray[indexPath.row]["favorite_count"] ?? 0)"
        let contentDate = tweetArray[indexPath.row]["created_at"] as! String
        let elapsedTime = getTimeElapsed(date: contentDate)
        
        // setting tweet stats
        cell.retweetCount.text = retweetCount
        cell.favoriteCount.text = favoriteCount
        cell.timeLabel.text = elapsedTime
        
        // getting profile image
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        
        // setting profile image
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
            
            cell.profileImageView.layer.masksToBounds = true
            cell.profileImageView.layer.cornerRadius = cell.profileImageView.bounds.width / 2
        }
        
        // setting favorited status
        cell.setFavorite(tweetArray[indexPath.row]["favorited"] as! Bool)
        
        
        return cell
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }
    
    /*
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}
