//
//  PostService.swift
//  helpDesk
//
//  Created by Thuis on 12-11-15.
//  Copyright © 2015 Amerion IT. All rights reserved.
//

import Foundation
import UIKit

class PostService {
    
    var settings:Settings!
    
    init(){
        self.settings = Settings()
    }
    
    func getPosts(callback:(NSDictionary)->()) {
        print("get posts")
        request(settings.viewPosts,callback: callback)
    }
    
    func request(url:String,callback:(NSDictionary)->()) {
        
    }
}