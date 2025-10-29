//
//  PlaylistGroup.swift
//  AcaciaChoir
//
//  Created by JooYoung Kim on 10/29/25.
//

import Foundation

struct PlaylistGroup: Identifiable, Codable, Equatable, Hashable {
    var id: String { title }
    var title: String
    var playlists: [PlaylistItem]
}
