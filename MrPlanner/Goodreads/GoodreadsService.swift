//
//  GoodreadsService.swift
//  MrPlanner
//
//  Created by Mohammad Gharari on 5/12/19.
//  Copyright © 2019 Mohammad Gharari. All rights reserved.
//

import Foundation
import SwiftyXMLParser
import Alamofire
import OAuthSwift

import Foundation

enum LoginState: String {
    case LoggedIn
    case LoggedOut
}

extension Notification.Name {
    static var loginStateChanged: Notification.Name {
        return .init(rawValue: LoginState.LoggedIn.rawValue)
    }
}


class GoodreadsService {
    static var sharedInstance = GoodreadsService()
    
    var isLoggedIn = LoginState.LoggedOut {
        didSet {
            NotificationCenter.default.post(name: .loginStateChanged, object: nil)
        }
    }
    
    
    var oauthswift: OAuthSwift?
    var id: String?
    
    
    func loginToGoodreadsAccount(sender: UIViewController, completion: (() -> ())?) {
        
        
        let oauthswift = OAuth1Swift(
            consumerKey: Bundle.main.localizedString(forKey: "goodreads_key", value: nil, table: "Secrets"),
            consumerSecret: Bundle.main.localizedString(forKey: "goodreads_secret", value: nil, table: "Secrets"),
            requestTokenUrl: "https://www.goodreads.com/oauth/request_token",
            authorizeUrl: "https://www.goodreads.com/oauth/authorize?mobile=1",
            accessTokenUrl: "https://www.goodreads.com/oauth/access_token"
        )
        
        self.oauthswift = oauthswift
        oauthswift.allowMissingOAuthVerifier  = true
        oauthswift.authorizeURLHandler = SafariURLHandler(viewController: sender, oauthSwift: self.oauthswift!)
        
        let authToken = AuthStorageService.readAuthToken()
        let authSecret = AuthStorageService.readTokenSecret()
        
        if authToken.isEmpty || authSecret.isEmpty {
            let _ = oauthswift.authorize(
                withCallbackURL: URL(string: "MrPlanner://oauth-callback/goodreads")!,
                success: { credential, response, parameters in
                        AuthStorageService.saveAuthToken(credential.oauthToken)
                        AuthStorageService.saveTokenSecret(credential.oauthTokenSecret)
                        self.isLoggedIn = .LoggedIn
                    self.loginToUser(oauthswift, completion: completion)
            },
                failure: { error in
                    print("Error Error: \(error.localizedDescription)", terminator: "")
            })
        }
        else {
            oauthswift.client.credential.oauthToken = authToken
            oauthswift.client.credential.oauthTokenSecret = authSecret
            self.isLoggedIn = .LoggedIn
            loginToUser(oauthswift, completion: completion)
        }
        
    }
    
    
    func logoutOfGoodreadsAccount() {
        AuthStorageService.removeAuthToken()
        AuthStorageService.removeTokenSecret()
        oauthswift = nil
        isLoggedIn = .LoggedOut
        
    }
    
    func loginToUser(_ oauthswift: OAuth1Swift, completion: (() -> ())?) {
        
        let _ = oauthswift.client.get(
            "https://www.goodreads.com/api/auth_user",
            success: { response in
                let xml = try! XML.parse(response.string!)
                guard let id = xml["GoodreadsResponse", "user"].attributes["id"] else {
                    return
                }
                self.id = id
                
                completion?()
        }, failure: { error in
            print(error)
        })
    }
    
    func loadBooks(sender: UIViewController, completion: @escaping ([Book]) -> ()) {
        var returnResult = [Book]()
        guard let _ = self.id else {
            loginToGoodreadsAccount(sender: sender) {
                self.loadBooks(sender: sender, completion: completion)
            }
            return
        }
        
        let parameters: Parameters = ["key": Bundle.main.localizedString(forKey: "goodreads_key", value: nil, table: "Secrets"), "user_id":id, "v":"2"]
        
        var components = URLComponents(string: "https://www.goodreads.com/review/list")
        components?.queryItems = [
            URLQueryItem(name: "key", value: "\(Bundle.main.localizedString(forKey: "goodreads_key", value: nil, table: "Secrets"))"),
            URLQueryItem(name: "id", value: "\(id ?? "")"),
        URLQueryItem(name: "v", value: "2")]
        
        if let url = components?.url
        {
            Alamofire.request(url).response { response in
                let xml = XML.parse(response.data!)
                //let count = xml["GoodreadsResponse", "reviews",0,"review"].all?.count
                for item in xml["GoodreadsResponse", "reviews",0,"review"] {
        
                    //let book = Book(xml: books[0, "review",i,"book"])
                    let book = Book(xml: item["book"])
                    returnResult.append(book)
                }
                
                completion(returnResult)
                
            }
        }
        
        
        
        
        
    }
    
    func loadShelves(sender: UIViewController, completion: (([Shelf]) -> ())?) {
        guard let _ = self.id else {
            loginToGoodreadsAccount(sender: sender) {
                self.loadShelves(sender: sender, completion: completion)
            }
            return
        }
    
    
        var components = URLComponents(string: "https://www.goodreads.com/shelf/list.xml")
        components?.queryItems = [
            URLQueryItem(name: "key", value:"\(Bundle.main.localizedString(forKey: "goodreads_key", value: nil, table: "Secrets"))"),
            URLQueryItem(name: "user_id", value:"\(id ?? "")")]
    
        if let url = components?.url
        {
            Alamofire.request(url).response { response in
                let xml = XML.parse(response.data!)
                let shelves = xml["GoodreadsResponse", "shelves", "user_shelf"].map {
                    return Shelf(id: $0["id"].text, name: $0["name"].text, book_count: $0["book_count"].int) }
                completion?(shelves)
                
            }
        }
    }
    
    
    func searchForBook(title: String, completion: @escaping (Book) -> ())
    {
        var components = URLComponents(string: "https://www.goodreads.com/search/index.xml")
        components?.queryItems = [
            URLQueryItem(name: "key", value:"\(Bundle.main.localizedString(forKey: "goodreads_key", value: nil, table: "Secrets"))"),
            URLQueryItem(name: "q", value:"\(title)")]
        if let url = components?.url
        {
            Alamofire.request(url).response { response in
                let xml = XML.parse(response.data!)
                let results = xml["GoodreadsResponse", "search", "results", "work"]
                let bestResult = Book(xml: results[0, "best_book"])
                
                completion(bestResult)
            }
        }
    }
    
}
