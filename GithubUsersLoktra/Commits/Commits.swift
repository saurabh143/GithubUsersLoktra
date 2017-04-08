//
//  GithubCommitsViewController.swift
//  GithubUsersLoktra
//
//  Created by Saurabh Yadav on 08/04/17.
//  Copyright © 2017 Saurabh Yadav. All rights reserved.
//

import Foundation

public class Commits {
	public var sha : String?
	public var commit : Commit?
	public var url : String?
	public var html_url : String?
	public var comments_url : String?
	public var author : Author?

    public class func modelsFromDictionaryArray(array:NSArray) -> [Commits]
    {
        var models:[Commits] = []
        for item in array
        {
            models.append(Commits(dictionary: item as! NSDictionary)!)
        }
        return models
    }

    required public init?(dictionary: NSDictionary) {

		sha = dictionary["sha"] as? String
		if (dictionary["commit"] != nil) { commit = Commit(dictionary: dictionary["commit"] as! NSDictionary) }
		url = dictionary["url"] as? String
		html_url = dictionary["html_url"] as? String
		comments_url = dictionary["comments_url"] as? String
		if (dictionary["author"] != nil) { author = Author(dictionary: dictionary["author"] as! NSDictionary) }
	}

		
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.sha, forKey: "sha")
		dictionary.setValue(self.commit?.dictionaryRepresentation(), forKey: "commit")
		dictionary.setValue(self.url, forKey: "url")
		dictionary.setValue(self.html_url, forKey: "html_url")
		dictionary.setValue(self.comments_url, forKey: "comments_url")
		dictionary.setValue(self.author?.dictionaryRepresentation(), forKey: "author")
		
		return dictionary
	}

}
