//
//  BookmarksViewController.swift
//  GithubUsersLoktra
//
//  Created by Saurabh Yadav on 27/04/17.
//  Copyright © 2017 Saurabh Yadav. All rights reserved.
//

import UIKit

class BookmarksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var githubCommitsTableView: UITableView!
    var commitsData : [Commits]?
    var filteredData : [Commits]?
    
    var isSearchActivated = false
    var bookmarkedObjects : [Commits]?
    
    var deleteBookmarkDelegate : DeleteBookmarkProtocol?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.githubCommitsTableView.delegate = self
        self.githubCommitsTableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        objectAtCell = self.commitsData?[(indexPath?.row)!]
        deleteBookmarkDelegate?.deleteCommitObjectFromCommitData(commitsObject: objectAtCell)
        self.commitsData?.remove(at: (indexPath?.row)!)
        self.githubCommitsTableView.reloadData()
    }
}


//MARK:- table view methods

extension BookmarksViewController{
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

extension BookmarksViewController{
    
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
    
}
