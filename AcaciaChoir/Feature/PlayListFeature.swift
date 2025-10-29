//
//  PlayListFeature.swift
//  AcaciaChoir
//
//  Created by JooYoung Kim on 10/28/25.
//

import ComposableArchitecture
import Foundation

// MARK: - PlaylistFeature
struct PlaylistFeature: Reducer {
    struct State: Equatable {
        var playlists: [PlaylistItem] = []
        var isLoading: Bool = false
        var errorMessage: String? = nil
        
        var selectedGroup: PlaylistGroup? = nil
        var selectedPlaylist: PlaylistItem? = nil
        
        var sectionOrder: [String] = ["성가 합창", "합창대회", "크리스마스", "부활절", "기타", "others"]
        
        var groupedPlaylists: [PlaylistGroup] {
            let grouped = Dictionary(grouping: playlists, by: { $0.groupKey })
            let orderMap = Dictionary(uniqueKeysWithValues: sectionOrder.enumerated().map { ($0.element, $0.offset) })
            
            return grouped
                .map { key, value in
                    PlaylistGroup(
                        title: key,
                        playlists: value.sorted { $0.sortHint < $1.sortHint }
                    )
                }
                .sorted { a, b in
                    let ia = orderMap[a.title] ?? Int.max
                    let ib = orderMap[b.title] ?? Int.max
                    if ia != ib { return ia < ib }
                    // 섹션 순서가 같거나 둘 다 미지정이면 타이틀로 정렬
                    return a.title.localizedStandardCompare(b.title) == .orderedAscending
                }
        }
    }

    enum Action: Equatable {
        case onAppear
        case refresh
        case playlistsLoaded([PlaylistItem])
        case playlistsFailed(String)
        
        case selectGroup(PlaylistGroup)
        case selectPlaylist(PlaylistItem)
    }

    @Dependency(\.youTubeClient) var youTubeClient

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
                
            case .onAppear, .refresh:
                state.isLoading = true
                state.errorMessage = nil
                return .run { send in
                    do {
                        let playlists = try await youTubeClient.fetchPlaylistsByChannel()
                        await send(.playlistsLoaded(playlists))
                    } catch {
                        await send(.playlistsFailed("재생목록을 불러오지 못했습니다."))
                    }
                }

            case let .playlistsLoaded(playlists):
                state.playlists = playlists
                state.isLoading = false
                state.errorMessage = nil
                return .none

            case let .playlistsFailed(message):
                state.errorMessage = message
                state.isLoading = false
                return .none
                
            case let .selectGroup(item):
                state.selectedGroup = item
                return .none
                
            case let .selectPlaylist(item):
                state.selectedPlaylist = item
                return .none
                
            }
        }
    }
}
