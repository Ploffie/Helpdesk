//
//  PostService.swift
//  helpDesk
//
//  Created by Thuis on 18-12-15.
//  Copyright © 2015 Amerion IT. All rights reserved.
//

import UIKit

class PostService {
    
    var names = [String]()
    
    do {
    let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
    
    if let blogs = json["blogs"] as? [[String: AnyObject]] {
    for blog in blogs {
    if let name = blog["name"] as? String {
    names.append(name)
    }
    }
    }
    } catch {
    print("error serializing JSON: \(error)")
    }
    
    print(names) // ["Bloxus test", "Manila Test"]
    
    if let blogs = json["blogs"] as? [[String: AnyObject]] {
        // if we get "blogs" from the JSON
        // AND we can cast it to an array of dictionaries
        // then this code will execute
    }}
