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

protocol DeleteBookmarkProtocol {
    func deleteCommitObjectFromCommitData(commitsObject : Commits?)
}

class GithubCommitsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, DeleteBookmarkProtocol {
    
    @IBOutlet weak var searchTextField: UITextField!

    @IBOutlet weak var githubCommitsTableView: UITableView!
    
    var deleteBookmarkDelegate : DeleteBookmarkProtocol?
    var token : String?
    var commitsData : [Commits]?
    var filteredData : [Commits]?
    
    var isSearchActivated = false
    var bookmarkedObjects : [Commits]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if bookmarkedObjects == nil{
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.getRailsCommits(accessToken: token!)
        }else{
            commitsData = bookmarkedObjects
            self.githubCommitsTableView.delegate = self
            self.githubCommitsTableView.dataSource = self
        }
        
        self.searchTextField.delegate = self
    }
    
    //MARK:- get first 25 commits
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
    
    //MARK:- failure alert method
    func showAlertForSomethingWentWrong(){
        let alert = UIAlertController.init(title: "Alert", message: "Commits Not Found.", preferredStyle: .alert)
        let action = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func showBookmarkedCommits(_ sender: Any) {
        
        let bookmarkedObjects = self.commitsData?.filter({$0.isBookmarked == true})
        let commitController = self.storyboard?.instantiateViewController(withIdentifier: "BookmarksViewController") as? BookmarksViewController
//        commitController?.deleteBookmarkDelegate! = self
//        commitController?.bookmarkedObjects = bookmarkedObjects
        self.navigationController?.pushViewController(commitController!, animated: true)
    
    }
    
    
    func bookmarkToCell(sender : UIButton){
        
        guard let cell = sender.superview?.superview as? GithubUserTableViewCell else {
            return
        }
        let indexPath = self.githubCommitsTableView.indexPath(for: cell)
        guard let bookMarkedRowUnwrapped = indexPath?.row else {
            return
        }
        var bookMarkedRow = bookMarkedRowUnwrapped
        var objectAtCell : Commits?
        if self.isSearchActivated {
            objectAtCell = self.filteredData?[(indexPath?.row)!]
            objectAtCell?.isBookmarked = !(objectAtCell?.isBookmarked)!
            
            if objectAtCell?.isBookmarked == false{
                deleteBookmarkDelegate?.deleteCommitObjectFromCommitData(commitsObject: objectAtCell)
            }
            //replace the object in filterdata array
//            self.filteredData?.remove(at: bookMarkedRow)
//            if bookMarkedRow == self.filteredData?.count{
//                bookMarkedRow -= 1
//            }
//            self.filteredData?.insert(objectAtCell!, at: bookMarkedRow)
//            
//            // replace the object in commits data array
//            var indexCounterForCommitsArray = 0
//            for commitObj in self.commitsData! {
//                if commitObj.sha == objectAtCell?.sha{
//                    break
//                }else{
//                    indexCounterForCommitsArray+=1
//                }
//            }
//            
//            self.commitsData?.remove(at: indexCounterForCommitsArray)
//            if indexCounterForCommitsArray == self.commitsData?.count{
//               indexCounterForCommitsArray-=1
//            }
//            self.commitsData?.insert(objectAtCell!, at: indexCounterForCommitsArray)
            
        }else{
            objectAtCell = self.commitsData?[(indexPath?.row)!]
            objectAtCell?.isBookmarked = !(objectAtCell?.isBookmarked)!
            //replace the object in filterdata array
//            self.commitsData?.remove(at: bookMarkedRow)
//            if bookMarkedRow == self.filteredData?.count{
//                bookMarkedRow -= 1
//            }
//            self.commitsData?.insert(objectAtCell!, at: bookMarkedRow)
        }
        

        self.githubCommitsTableView.reloadData()
    }
}


//MARK:- table view methods

extension GithubCommitsViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.isSearchActivated && (self.filteredData?.count)! > 0{
            return (self.filteredData?.count)!
        }
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
        var cellObject : Commits?
        if self.isSearchActivated && (self.filteredData?.count)! > 0{
            cellObject = self.filteredData?[indexPath.row]
        }
        else{
            cellObject = self.commitsData?[indexPath.row]
        }
        
        commitCell.commitIdLabel.text = "Commit Id: \(cellObject!.sha!)"
        commitCell.commitMessageLabel.text = "Commit: \(cellObject!.commit!.message!)"
        commitCell.userNameLabel.text = cellObject?.author?.login
        commitCell.userImageView.sd_setImage(with: URL.init(string: (cellObject?.author?.avatar_url)!))
        commitCell.bookmarkButton.addTarget(self, action: #selector(bookmarkToCell(sender:)), for: .touchUpInside)
        if (cellObject?.isBookmarked)! && self.bookmarkedObjects == nil{
            commitCell.bookmarkButton.setTitle("yes", for: .normal)
        }else{
            
            commitCell.bookmarkButton.setTitle("BM", for: .normal)
        }
        return commitCell
    }
    
    
}

//MARK :- search delegate

extension GithubCommitsViewController{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.text == "" {
            isSearchActivated = false
            return true
        }
        
        filteredData = self.commitsData?.filter({
            
           ($0.commit?.message?.contains(textField.text!))! || ($0.author?.login?.contains(textField.text!))!
        })
        isSearchActivated = true
        print(self.filteredData?.count)
        self.githubCommitsTableView.reloadData()
        
        return true
    }

    func deleteCommitObjectFromCommitData(commitsObject: Commits?) {

        var indexCounterForCommitsArray = 0
        for commitObj in self.commitsData! {
            if commitObj.sha == commitsObject?.sha{
                break
            }else{
                indexCounterForCommitsArray+=1
            }
        }
        self.commitsData?.remove(at: indexCounterForCommitsArray)
        self.githubCommitsTableView.reloadData()
    }
}
