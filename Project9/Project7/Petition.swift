//
//  petition.swift
//  Project7
//
//  Created by Игорь Клюжев on 23.07.2020.
//  Copyright © 2020 Игорь Клюжев. All rights reserved.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
