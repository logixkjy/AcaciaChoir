//
//  PlaylistView.swift
//  AcaciaChoir
//
//  Created by JooYoung Kim on 10/29/25.
//

import SwiftUI
import ComposableArchitecture

struct PlaylistView: View {
    let store: StoreOf<PlaylistFeature>
    let group: PlaylistGroup
    @Environment(\.dismiss) private var dismiss
    
    @Binding private var isGridLayout: Bool
    
    @State private var isPresented = false
    
    @State private var selectedPlaylistItem: PlaylistItem? = nil
    
    @State private var toastMessage: String? = nil
    
    let columns = [
        GridItem(.flexible()), GridItem(.flexible())
    ]
    
    init(store: StoreOf<PlaylistFeature>, group: PlaylistGroup, isGridLayout: Binding<Bool>) {
        self.store = store
        self.group = group
        self._isGridLayout = isGridLayout
    }
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            let items = group.playlists.sorted(by: { $0.cleanTitle < $1.cleanTitle }) ?? []
            
            NavigationStack {
                ZStack {
                    Color.black01.ignoresSafeArea()
                    
                    VStack(spacing: 8) {
                        if viewStore.isLoading {
                            ProgressView("재생목록 불러오는 중...")
                        } else if let error = viewStore.errorMessage {
                            Text(error).foregroundColor(.red)
                        } else {
                            if isGridLayout {
                                ScrollView {
                                    LazyVGrid(columns: columns, spacing: 16) {
                                        ForEach(items) { playlist in
                                            VStack(alignment: .leading, spacing: 6) {
                                                ZStack {
                                                    if let url = playlist.thumbnailURL {
                                                        AsyncImage(url: URL(string: url)) { phase in
                                                            switch phase {
                                                            case .success(let image):
                                                                image
                                                                    .resizable()
                                                                    .scaledToFill()
                                                            case .failure(_):
                                                                Color.gray.opacity(0.25)
                                                            default:
                                                                Color.gray.opacity(0.15)
                                                            }
                                                        }
                                                        .aspectRatio(16/9, contentMode: .fit)
                                                    }
                                                }
                                                Text(playlist.title)
                                                    .font(.subheadline)
                                                    .lineLimit(1)
                                                    .multilineTextAlignment(.leading)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .fixedSize(horizontal: false, vertical: true)
                                            }
                                            .onTapGesture {
                                                viewStore.send(.selectPlaylist(playlist))
                                                isPresented.toggle()
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .transition(.opacity.combined(with: .scale))
                                }
                            } else {
                                List(items) { playlist in
                                    HStack(alignment: .top, spacing: 12) {
                                        if let url = playlist.thumbnailURL {
                                            ZStack(alignment: .center) {
                                                AsyncImage(url: URL(string: url)) { image in
                                                    image
                                                        .resizable()
                                                        .aspectRatio(16/9, contentMode: .fill)
                                                } placeholder: {
                                                    Rectangle()
                                                        .fill(Color.gray.opacity(0.2))
                                                }
                                            }
                                            .frame(width: 133, height: 100) // ✅ 고정
                                            .clipped()
                                            .cornerRadius(8)
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 6) {
                                            Text(playlist.title)
                                                .font(.headline)
                                                .lineLimit(2)
                                                .foregroundColor(.white)
                                        }
                                        
                                        Spacer()
                                    }
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        viewStore.send(.selectPlaylist(playlist))
                                        isPresented.toggle()
                                    }
                                }
                                .listStyle(.plain)
                                .transition(.opacity.combined(with: .scale))
                            }
                            
                        }
                    }
                }
                .navigationTitle(group.title)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            dismiss()
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 20, weight: .medium))
                                Text("홈")
                                    .font(.system(size: 18))
                            }
                            .foregroundColor(.primary)
                            .padding(8)
                        }
                    }
                    
                    // 오른쪽: 레이아웃 전환 버튼
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            withAnimation(.easeInOut) {
                                isGridLayout.toggle()
                            }
                        }) {
                            Image(systemName: isGridLayout ? "list.bullet" : "square.grid.2x2")
                                .imageScale(.large)
                                .padding(8)
                        }
                        .accessibilityLabel("레이아웃 전환")
                    }
                }
                .fullScreenCover(isPresented: $isPresented) {
                    VideoListView(
                        store: Store(
                            initialState: VideoListFeature.State(playlistItem: viewStore.selectedPlaylist!),
                            reducer: { VideoListFeature() }
                        ),
                        isGridLayout: $isGridLayout
                    )
                }
                .overlay(
                    Group {
                        if let message = toastMessage {
                            VStack {
                                Spacer()
                                Text(message)
                                    .padding()
                                    .background(Color.black.opacity(0.8))
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                    .padding(.bottom, 40)
                            }
                            .animation(.easeInOut, value: toastMessage)
                            .transition(.move(edge: .bottom))
                        }
                    }
                )
            }
        }
    }
}
