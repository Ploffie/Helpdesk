//
//  Post.swift
//  helpDesk
//
//  Created by Thuis on 12-11-15.
//  Copyright © 2015 Amerion IT. All rights reserved.
//

import Foundation

class Post {
    var id:Int
    var response:Int
    
    init(id:Int, response:Int) {
        self.id = id
        self.response = response
    }
    
    func toJSON() -> String {
        return ""
    }
    
}