//
//  SignInViewController.swift
//  GithubUsersLoktra
//
//  Created by Saurabh Yadav on 08/04/17.
//  Copyright © 2017 Saurabh Yadav. All rights reserved.
//

import UIKit
protocol GithubProtocol{
    func tokenGenerated(token : String)
}

class SignInViewController: UIViewController, UIWebViewDelegate {

//    Client ID
//    ae854ae039ac0957994c
//    Client Secret
//    f59622002ae6c75e16a8a004fca490aa8c060ba5

    var loginDelegate : GithubProtocol?
    let clientId = "ae854ae039ac0957994c"
    let clientSecret = "f59622002ae6c75e16a8a004fca490aa8c060ba5"
    
    @IBOutlet weak var signInWebView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        signInWebView.delegate = self
        
        let urlString = "https://github.com/login/oauth/authorize?client_id=\(clientId)"
        if let url = URL(string: urlString) {
            let req = URLRequest(url: url)
            signInWebView.loadRequest(req)
        }
        signInWebView.delegate = self
        // Do any additional setup after loading the view.
    }
    //MARK:- Login and token
    // added login here, compare the host with the added callback url and proceed.
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let url = request.url, url.host == "loktra.com" {
            if let code = url.query?.components(separatedBy: "code=").last {
                let urlString = "https://github.com/login/oauth/access_token"
                if let tokenUrl = URL(string: urlString) {
                    var req = URLRequest(url: tokenUrl)
                    req.httpMethod = "POST"
                    req.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    req.addValue("application/json", forHTTPHeaderField: "Accept")
                    let params = [
                        "client_id" : clientId,
                        "client_secret" : clientSecret,
                        "code" : code
                    ]
                    req.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
                    let task = URLSession.shared.dataTask(with: req as URLRequest) { data, response, error in
                        if let data = data {
                            do {
                                if let content = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                                    if let accessToken = content["access_token"] as? String {
                                        self.loginDelegate?.tokenGenerated(token: accessToken)
                                        self.presentingViewController?.dismiss(animated: true, completion: nil)
                                        
                                    }
                                }
                            } catch {}
                        }
                    }
                    task.resume()
                }
            }
            return false
        }
        return true
    }

}
