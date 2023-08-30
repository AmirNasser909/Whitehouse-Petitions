//
//  Petition.swift
//  Whitehouse Petitions
//
//  Created by MacBook Air on 30/08/2023.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
