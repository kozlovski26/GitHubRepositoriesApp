//
//  Model.swift
//  GithubRepositoriesApp
//
//  Created by Bar kozlovski on 10/06/2019.
//  Copyright © 2019 Bar kozlovski. All rights reserved.
//

import Foundation


//MARK:  Repository class

//Class with all parameter from the repository

class Repository {
    
    
    var full_name:String
    var stargazers_count:Int
    var avatar_url:URL
    var description:String?
    var id:Int
    var watchers:Int
    var score:Double
    var created_at:String
    
    init(id:Int = 0,stargazers_count:Int = 0,avatar_url:URL = URL(string: "www")!,description:String = " ",full_name:String = "",watchers:Int = 0,score:Double = 0,created_at:String = "") {
        
        self.id = id
        self.stargazers_count = stargazers_count
        self.avatar_url = avatar_url
        self.description = description
        self.full_name = full_name
        self.score = score
        self.watchers = watchers
        self.created_at = created_at
    }
    
    
}

//MARK: Page class


//For managing the page's location

class Page {
    
    
    var currentPage:Int = 1
    var nextPage:Int = 1
    var lastPage:Int = 2
    
    init(currentPage:Int = 1 ,nextPage:Int = 1 ,lastPage:Int = 2) {
        self.currentPage = currentPage
        self.nextPage = nextPage
        self.lastPage = lastPage
    }
}
