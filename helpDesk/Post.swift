//
//  Post.swift
//  helpDesk
//
//  Created by Thuis on 18-12-15.
//  Copyright © 2015 Amerion IT. All rights reserved.
//

import Foundation

class Post {
    var id:Int
    var title:String
    var author:String
    var content:String
    
    init(id:Int,title:String,author:String,content:String) {
        self.id = id
        self.title = title
        self.author = author
        self.content = content
    }
    
    func toJSON() -> String {
        return "{\"Post\":{\"id\":\(id),\"title\":\"\(title)\",\"author\":\"\(author)\",\"content\":\"\(content)\"}}"
    }
}