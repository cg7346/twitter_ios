//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Celeste Gambardella on 10/14/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var tweetsCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    
    var profileDictionary = NSDictionary()
    var user = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("in profile")
        // Do any additional setup after loading the view.
//        print(prgofileDictionary)
        
        loadProfile()
        
    }
    

    @IBAction func backHome(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func loadProfile() {
        
        if (profileDictionary != nil) {
            let followersCount = profileDictionary["followers_count"] as! Int
            let followingCount = profileDictionary["friends_count"] as! Int
            let tweetsCount = profileDictionary["statuses_count"] as! Int
            let name = profileDictionary["name"] as! String
            let tagline = profileDictionary["description"] as! String
            
            
            followersCountLabel.text = String(followersCount)
            followingCountLabel.text = String(followingCount)
            tweetsCountLabel.text = String(tweetsCount)
            usernameLabel.text = name
            taglineLabel.text = tagline
            
            // getting profile image
            let imageUrl = URL(string: (profileDictionary["profile_image_url_https"] as? String)!)
            let data = try? Data(contentsOf: imageUrl!)

            // setting profile image
            if let imageData = data {
                profileImage.image = UIImage(data: imageData)
                
                profileImage.layer.masksToBounds = true
                profileImage.layer.cornerRadius = profileImage.bounds.width / 2
            }
        }
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
