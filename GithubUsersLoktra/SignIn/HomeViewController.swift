//
//  ViewController.swift
//  GithubUsersLoktra
//
//  Created by Saurabh Yadav on 08/04/17.
//  Copyright © 2017 Saurabh Yadav. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, GithubProtocol {


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func signInUsingWebView(_ sender: Any) {
        let signInVc = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        signInVc.loginDelegate = self
        self.present(signInVc, animated: true, completion:nil)
    }
}

//MARK:- protocol implementation

extension HomeViewController{
    
    func tokenGenerated(token : String){
        let githubCommitVC = self.storyboard?.instantiateViewController(withIdentifier: "GithubCommitsViewController") as? GithubCommitsViewController
        githubCommitVC?.token = token
        self.navigationController?.pushViewController(githubCommitVC!, animated: true)
    }
}

