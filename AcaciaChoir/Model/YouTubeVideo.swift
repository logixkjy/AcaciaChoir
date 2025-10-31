//
//  YouTubeVideo.swift
//  AcaciaChoir
//
//  Created by JooYoung Kim on 10/29/25.
//

import Foundation

struct YouTubeVideo: Equatable, Identifiable, Hashable {
    let id: String
    let title: String
    let description: String
    let thumbnailURL: String
    let publishedAt: Date?
    let duration: String?
    let videoOwnerChannelTitle: String
}
