//
//  GithubCommitsViewController.swift
//  GithubUsersLoktra
//
//  Created by Saurabh Yadav on 08/04/17.
//  Copyright © 2017 Saurabh Yadav. All rights reserved.
//

import Foundation

public class Commit {
	public var author : Author?
	public var message : String?
	public var url : String?
	public var comment_count : Int?

    public class func modelsFromDictionaryArray(array:NSArray) -> [Commit]
    {
        var models:[Commit] = []
        for item in array
        {
            models.append(Commit(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {

		if (dictionary["author"] != nil) { author = Author(dictionary: dictionary["author"] as! NSDictionary) }
		message = dictionary["message"] as? String
		url = dictionary["url"] as? String
		comment_count = dictionary["comment_count"] as? Int
	}

    public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.author?.dictionaryRepresentation(), forKey: "author")
		dictionary.setValue(self.message, forKey: "message")
		dictionary.setValue(self.url, forKey: "url")
		dictionary.setValue(self.comment_count, forKey: "comment_count")

		return dictionary
	}

}
