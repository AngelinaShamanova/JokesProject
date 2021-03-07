//
//  ImageModel.swift
//  Involta-Test
//
//  Created by Angelina on 07.03.2021.
//

import Foundation

struct ImageModel: Decodable {
    let results: [Results]
}

struct Results: Decodable {
    let image: String
}
