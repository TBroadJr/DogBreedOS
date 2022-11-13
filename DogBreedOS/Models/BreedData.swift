//
//  BreedData.swift
//  DogBreedOS
//
//  Created by Tornelius Broadwater, Jr on 11/13/22.
//

import Foundation

struct BreedData: Codable {
    let name: String
    let temperament: String
    let lifeSpan: String
    let bredFor: String
    let breedGroup: String
    let weight, height: Dimension
    
    enum CodingKeys: String, CodingKey {
        case name, temperament
        case lifeSpan = "life_span"
        case bredFor = "bred_for"
        case breedGroup = "breed_group"
        case weight, height
    }
}

struct Dimension: Codable {
    let imperial: String
}
