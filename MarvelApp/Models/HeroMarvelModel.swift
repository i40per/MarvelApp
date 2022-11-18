//
//  HeroMarvelModel.swift
//  MarvelApp
//
//  Created by Evgenii Lukin on 31.10.2022.
//

import Foundation

struct HeroMarvelModel: Decodable {
    
    let id: Int
    let name: String
    let description: String
    let modified: String
    let thumbnail: Thumbnail
}

struct Thumbnail: Decodable {
    
    let path: String
    let `extension`: String
    var url: URL? {
        return URL(string: path + "." + `extension`)
    }
}

//MARK: - Protokol Hashable

extension HeroMarvelModel: Hashable {
    
    static func == (lhs: HeroMarvelModel, rhs: HeroMarvelModel) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
