//
//  TweetViewController.swift
//  Twitter
//
//  Created by Celeste Gambardella on 10/13/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

    @IBOutlet weak var tweetBarButton: UIBarButtonItem!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var tweetTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // styling the bar button items
        tweetBarButton.style = .done
        cancelBarButton.tintColor = .white

        // Do any additional setup after loading the view.
        tweetTextView.becomeFirstResponder()
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func tweet(_ sender: Any) {
         
        if (!tweetTextView.text.isEmpty && tweetTextView.isEqual(" ")) {
            
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
