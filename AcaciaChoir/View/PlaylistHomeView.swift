//
//  PlaylistHomeView.swift
//  AcaciaChoir
//
//  Created by JooYoung Kim on 10/28/25.
//

import SwiftUI
import ComposableArchitecture

struct PlaylistHomeView: View {
    let store: StoreOf<PlaylistFeature>
    
    @State private var searchText: String = ""
    @State private var sortAlphabetically: Bool = false
    
    @State private var isPresented = false
    @State private var isPresentedVideoList = false
    @State private var isGridLayout: Bool = true
    
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
        case search
    }
    
    let columns = [
        GridItem(.flexible()), GridItem(.flexible())
    ]
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationStack {
                ZStack {
                    Color.black01.ignoresSafeArea()
                    
                    VStack(spacing: 0) {
                        
                        HStack {
                            Text("아카시아 합창단 파트연습")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top, 16)
                        
                        HStack {
                            TextField("초성 또는 제목 검색", text: $searchText)
                                .textFieldStyle(.roundedBorder)
                                .focused($focusedField, equals: .search)
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                        
                        Group {
                            if viewStore.isLoading {
                                Spacer()
                                ProgressView("재생목록 불러오는 중...")
                                Spacer()
                            } else if let error = viewStore.errorMessage {
                                Spacer()
                                Text(error).foregroundColor(.red)
                                Spacer()
                            } else {
                                if !searchText.isEmpty {
                                    List(filteredPlaylists(from: viewStore.playlists)) { playlist in
                                        HStack(spacing: 12) {
                                            if let thumbnailURL = playlist.thumbnailURL {
                                                AsyncImage(url: URL(string:  thumbnailURL)) { image in
                                                    image
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: 100, height: 60)
                                                        .clipped()
                                                        .cornerRadius(6)
                                                } placeholder: {
                                                    ProgressView()
                                                        .frame(width: 100, height: 60)
                                                }
                                            }
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(playlist.cleanTitle)
                                                    .font(.headline)
                                                    .lineLimit(2)
                                                Text(playlist.cleanDescription)
                                                    .font(.caption)
                                                    .lineLimit(2)
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                        .padding(.vertical, 4)
                                        .onTapGesture {
                                            viewStore.send(.selectPlaylist(playlist))
                                            isPresentedVideoList.toggle()
                                        }
                                    }
                                    .listStyle(.plain)
                                    .padding(.top, 16)
                                } else {
                                    ScrollView {
                                        LazyVStack(spacing: 32, pinnedViews: [.sectionHeaders]) {
                                            ForEach(viewStore.groupedPlaylists, id: \.self) { item in
                                                PlaylistSectionView(
                                                    group: item,
                                                    playlists: item.playlists,
                                                    store: store,
                                                    isPresented: $isPresented,
                                                    isPresentedVideoList: $isPresentedVideoList,
                                                    isGridLayout: $isGridLayout
                                                )
                                            }
                                            Spacer().frame(height: 16)
                                        }
                                        .padding(.horizontal)
                                    }
                                    .padding(.top, 16)
                                }
                            }
                        }
                    }
                }
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("완료") {
                            focusedField = nil
                        }
                    }
                }
                .onAppear {
                    viewStore.send(.onAppear)
                }
                .fullScreenCover(isPresented: $isPresented) {
                    PlaylistView(
                        store: store,
                        group: viewStore.selectedGroup!,
                        isGridLayout: $isGridLayout
                    )
                }
                .fullScreenCover(isPresented: $isPresentedVideoList) {
                    VideoListView(
                        store: Store(
                            initialState: VideoListFeature.State(playlistItem: viewStore.selectedPlaylist!),
                            reducer: {
                                VideoListFeature()
                            }
                        ),
                        isGridLayout: $isGridLayout,
                        isMain: true
                    )
                }
            }
        }
    }
    
    private func filteredPlaylists(from playlists: [PlaylistItem]) -> [PlaylistItem] {
        let query = searchText.lowercased()
        
        let filtered = playlists.filter { playlist in
            let title = playlist.title.lowercased()
            let initials = getInitials(from: playlist.title)
            
            return query.isEmpty
            || title.contains(query)
            || initials.contains(query)
        }
        
        return sortAlphabetically
        ? filtered.sorted { $0.title < $1.title }
        : filtered
    }
    
    func getInitials(from text: String) -> String {
        let consonants = "ㄱㄲㄴㄷㄸㄹㅁㅂㅃㅅㅆㅇㅈㅉㅊㅋㅌㅍㅎ"
        var initials = ""
        
        for scalar in text.unicodeScalars {
            let value = scalar.value
            
            // 한글 음절: AC00 ~ D7A3
            if value >= 0xAC00 && value <= 0xD7A3 {
                let index = (value - 0xAC00) / 28 / 21
                let initial = consonants[consonants.index(consonants.startIndex, offsetBy: Int(index))]
                initials.append(initial)
            } else {
                initials.append(String(scalar))
            }
        }
        
        return initials
    }
}
