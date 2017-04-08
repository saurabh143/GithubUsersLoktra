//
//  GithubCommitsViewController.swift
//  GithubUsersLoktra
//
//  Created by Saurabh Yadav on 08/04/17.
//  Copyright © 2017 Saurabh Yadav. All rights reserved.
//

import UIKit
import MBProgressHUD
import SDWebImage

class GithubCommitsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var githubCommitsTableView: UITableView!
    var token : String?
    var commitsData : [Commits]?
    override func viewDidLoad() {
        super.viewDidLoad()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.getRailsCommits(accessToken: token!)
    }
    
    
    func getRailsCommits(accessToken: String) {
        let urlString = "https://api.github.com/repos/rails/rails/commits?per_page=25"
        if let url = NSURL(string: urlString) {
            let req = NSMutableURLRequest(url: url as URL)
            req.addValue("application/json", forHTTPHeaderField: "Accept")
            req.addValue("token \(accessToken)", forHTTPHeaderField: "Authorization")
            let task = URLSession.shared.dataTask(with: req as URLRequest) { data, response, error in
                if let data = data {
                    do{
                        let dict = try JSONSerialization.jsonObject(with: data, options: [])
                        self.commitsData = Commits.modelsFromDictionaryArray(array: dict as! NSArray)
                        
                        print (self.commitsData!)
                        DispatchQueue.main.async {
                            self.githubCommitsTableView.delegate = self
                            self.githubCommitsTableView.dataSource = self
                            self.githubCommitsTableView.reloadData()
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        
                    }catch{
                        DispatchQueue.main.async {
                        MBProgressHUD.hide(for: self.view, animated: true)
                            self.showAlertForSomethingWentWrong()
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        self.showAlertForSomethingWentWrong()
                    }
                }
                
            }
            task.resume()
        }
    }
    
    func showAlertForSomethingWentWrong(){
        let alert = UIAlertController.init(title: "Alert", message: "Commits Not Found.", preferredStyle: .alert)
        let action = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

extension GithubCommitsViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.commitsData?.count)!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let constraintRect = CGSize(width: self.view.frame.size.width - 69, height: CGFloat.greatestFiniteMagnitude)
        let cellObject = self.commitsData?[indexPath.row]
        let stringDesc = "Commit: \(cellObject!.commit!.message!)"
        
        let fontSize:CGFloat = 13

        let boundingBox = stringDesc.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: fontSize)], context: nil)
        
        return boundingBox.height + 30 + 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let commitCell = self.githubCommitsTableView.dequeueReusableCell(withIdentifier: "GithubUserTableViewCell") as? GithubUserTableViewCell else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "GithubUserTableViewCell") as? GithubUserTableViewCell
            return cell!
        }
        
        let cellObject = self.commitsData?[indexPath.row]
        commitCell.commitIdLabel.text = "Commit Id: \(cellObject!.sha!)"
        commitCell.commitMessageLabel.text = "Commit: \(cellObject!.commit!.message!)"
        commitCell.userNameLabel.text = cellObject?.author?.login
        commitCell.userImageView.sd_setImage(with: URL.init(string: (cellObject?.author?.avatar_url)!))
        
        return commitCell
    }
}
