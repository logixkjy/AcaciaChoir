//
//  PlaylistsResponse.swift
//  AcaciaChoir
//
//  Created by JooYoung Kim on 10/29/25.
//

struct PlaylistsResponse: Decodable {
    let items: [Item]
    let nextPageToken: String?
    
    struct Item: Decodable {
        let id: String
        let snippet: Snippet
        
        struct Snippet: Decodable {
            let title: String // "title": "마음에 가득한 의심을 깨치고 - 미디",
            let description: String // "description": "[성가 합창]",
            let publishedAt: String // "publishedAt": "2025-07-24T11:52:40.521044Z",
            let thumbnails: Thumbnails
            
            struct Thumbnails: Decodable {
                let medium: Thumbnail?
                
                struct Thumbnail: Decodable {
                    let url: String
                }
            }
        }
    }
}
