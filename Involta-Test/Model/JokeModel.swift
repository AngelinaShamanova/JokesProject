//
//  JokeModel.swift
//  Involta-Test
//
//  Created by Angelina on 07.03.2021.
//

import Foundation

struct JokeModel: Decodable, Equatable, Encodable {
    
    static func == (lhs: JokeModel, rhs: JokeModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: Int
    let type: String
    let setup: String
    let punchline: String
}
