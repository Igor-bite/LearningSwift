//
//  Person.swift
//  Project10
//
//  Created by Игорь Клюжев on 30.07.2020.
//  Copyright © 2020 Игорь Клюжев. All rights reserved.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
