//
//  GithubUserTableViewCell.swift
//  GithubUsersLoktra
//
//  Created by Saurabh Yadav on 08/04/17.
//  Copyright © 2017 Saurabh Yadav. All rights reserved.
//

import UIKit

class GithubUserTableViewCell: UITableViewCell {

    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var commitIdLabel: UILabel!
    @IBOutlet weak var commitMessageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.userImageView.layer.cornerRadius = 45
        self.userImageView.layer.borderColor = UIColor.black.cgColor
        self.userImageView.layer.borderWidth = 0.5
        self.userImageView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
