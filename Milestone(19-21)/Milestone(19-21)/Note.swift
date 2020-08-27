//
//  Note.swift
//  Milestone(19-21)
//
//  Created by Игорь Клюжев on 15.08.2020.
//  Copyright © 2020 Игорь Клюжев. All rights reserved.
//

import UIKit

class Note: NSObject, Codable {
    var title: String
    var body: String
    
    init(title: String, body: String) {
        self.title = title
        self.body = body
    }
    override init() {
        self.title = ""
        self.body = ""
    }
}
