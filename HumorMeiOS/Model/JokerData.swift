//
//  JokerData.swift
//  HumorMeiOS
//
//  Created by Ankush Ganesh on 24/01/23.
//

import Foundation


struct JokerData: Codable {
    let amount: Int
    let jokes: [Jokes]
}

struct Jokes: Codable {
    let category: String
    let joke: String
    let id: Int
}
