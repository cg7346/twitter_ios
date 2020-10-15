//
//  TweetViewController.swift
//  Twitter
//
//  Created by Celeste Gambardella on 10/13/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var tweetBarButton: UIBarButtonItem!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var charCountLabel: UILabel!
    
    
    
    var data:Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        loadProfile()
        
        tweetTextView.delegate = self
        
        // styling the items
        self.tweetBarButton.style = .done
        self.cancelBarButton.tintColor = .white
        
        let borderColor : UIColor = UIColor(red: 0.9686, green: 0.9686, blue: 0.9686, alpha: 1.0)
        tweetTextView.layer.borderColor = borderColor.cgColor
        self.tweetTextView.layer.borderWidth = 1.0;
        self.tweetTextView.layer.cornerRadius = 8;
        
        // Do any additional setup after loading the view.
        tweetTextView.becomeFirstResponder()
                
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tweet(_ sender: Any) {
        
        if (!tweetTextView.text.isEmpty) {
            
            TwitterAPICaller.client?.postTweet(tweetString: tweetTextView.text,
                                               success: { self.dismiss(animated: true, completion: nil)},
                                               failure: { (error) in
                                                print("Error postiing tweet \(error)")
                                                self.dismiss(animated: true, completion: nil)
            })
        } else {
            
            //            self.dismiss(animated: true, completion: nil)
            let alert = UIAlertController(title: "Invalid Tweet", message: "No text entered.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Check the proposed new text character count
        // Set the max character limit
        let characterLimit = 140

        // Construct what the new text would be if we allowed the user's latest edit
        let newText = NSString(string: textView.text!).replacingCharacters(in: range, with: text)

//        let remainingChars = String(characterLimit - newText.count)
        
        // Update Character Count Label
        charCountLabel.text = String(characterLimit - newText.count) + "/140"

        // The new text should be allowed? True/False
        return newText.count < characterLimit

        // Allow or disallow the new text
    }
    
    func loadProfile() {
//        print("tweet")
//        print(data)
        // setting profile image
        if let imageData = data {
            
            // Sets the movie in the details view coontroller
            profileImage.image = UIImage(data: imageData)
            profileImage.layer.masksToBounds = true
            profileImage.layer.cornerRadius = profileImage.bounds.width / 2
            
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
