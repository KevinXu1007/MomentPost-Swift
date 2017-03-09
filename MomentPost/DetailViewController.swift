//
//  DetailViewController.swift
//  MomentPost
//
//  Created by Chenggang Xu on 7/4/16.
//  Copyright © 2016 Chenggang Xu. All rights reserved.
//

import UIKit

protocol DetailViewControllerDelegate {
    func getUserInfo(content: String)->UserInfo
}

class DetailViewController: UIViewController {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var postTime: UILabel!
    @IBOutlet weak var moment: UITextView!
    
    var delegate: DetailViewControllerDelegate? = nil

    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.postTime {
                label.text = detail.valueForKey("posttime")!.description
            }
            if let label = self.moment {
                label.text = detail.valueForKey("moment")!.description
            }
            if let label = self.userName {
                let email = detail.valueForKey("email")!.description!
                let user = self.delegate?.getUserInfo(email)
                label.text = user!.lastname! + "," + user!.firstname!
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

