//
//  VideoDurationResponse.swift
//  AcaciaChoir
//
//  Created by JooYoung Kim on 10/29/25.
//

struct VideoDurationResponse: Decodable {
    let items: [Item]
    struct Item: Decodable {
        let id: String
        let contentDetails: ContentDetails
        
        struct ContentDetails: Decodable {
            let duration: String // ISO 8601 duration string
        }
    }
}
