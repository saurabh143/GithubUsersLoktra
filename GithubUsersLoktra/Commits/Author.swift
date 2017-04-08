//
//  GithubCommitsViewController.swift
//  GithubUsersLoktra
//
//  Created by Saurabh Yadav on 08/04/17.
//  Copyright © 2017 Saurabh Yadav. All rights reserved.
//

import Foundation

public class Author {
	public var login : String?
	public var id : Int?
	public var avatar_url : String?
	public var gravatar_id : String?
	public var url : String?
	public var html_url : String?
	public var followers_url : String?
	public var following_url : String?
	public var gists_url : String?
	public var starred_url : String?
	public var subscriptions_url : String?
	public var organizations_url : String?
	public var repos_url : String?
	public var events_url : String?
	public var received_events_url : String?
	public var type : String?
	public var site_admin : String?

    public class func modelsFromDictionaryArray(array:NSArray) -> [Author]
    {
        var models:[Author] = []
        for item in array
        {
            models.append(Author(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {

		login = dictionary["login"] as? String
		id = dictionary["id"] as? Int
		avatar_url = dictionary["avatar_url"] as? String
		gravatar_id = dictionary["gravatar_id"] as? String
		url = dictionary["url"] as? String
		html_url = dictionary["html_url"] as? String
		followers_url = dictionary["followers_url"] as? String
		following_url = dictionary["following_url"] as? String
		gists_url = dictionary["gists_url"] as? String
		starred_url = dictionary["starred_url"] as? String
		subscriptions_url = dictionary["subscriptions_url"] as? String
		organizations_url = dictionary["organizations_url"] as? String
		repos_url = dictionary["repos_url"] as? String
		events_url = dictionary["events_url"] as? String
		received_events_url = dictionary["received_events_url"] as? String
		type = dictionary["type"] as? String
		site_admin = dictionary["site_admin"] as? String
	}
		
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.login, forKey: "login")
		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.avatar_url, forKey: "avatar_url")
		dictionary.setValue(self.gravatar_id, forKey: "gravatar_id")
		dictionary.setValue(self.url, forKey: "url")
		dictionary.setValue(self.html_url, forKey: "html_url")
		dictionary.setValue(self.followers_url, forKey: "followers_url")
		dictionary.setValue(self.following_url, forKey: "following_url")
		dictionary.setValue(self.gists_url, forKey: "gists_url")
		dictionary.setValue(self.starred_url, forKey: "starred_url")
		dictionary.setValue(self.subscriptions_url, forKey: "subscriptions_url")
		dictionary.setValue(self.organizations_url, forKey: "organizations_url")
		dictionary.setValue(self.repos_url, forKey: "repos_url")
		dictionary.setValue(self.events_url, forKey: "events_url")
		dictionary.setValue(self.received_events_url, forKey: "received_events_url")
		dictionary.setValue(self.type, forKey: "type")
		dictionary.setValue(self.site_admin, forKey: "site_admin")

		return dictionary
	}

}
