//
//  PlaylistSectionView.swift
//  PlayListApp
//
//  Created by JooYoung Kim on 4/18/25.
//

import SwiftUI
import ComposableArchitecture

struct PlaylistSectionView: View {
    let group: PlaylistGroup
    let playlists: [PlaylistItem]
    let store: StoreOf<PlaylistFeature>
    
    @Binding private var isPresented: Bool
    @Binding private var isPresentedVideoList: Bool
    @Binding private var isGridLayout: Bool
    
    init(
        group: PlaylistGroup,
        playlists: [PlaylistItem],
        store: StoreOf<PlaylistFeature>,
        isPresented: Binding<Bool>,
        isPresentedVideoList: Binding<Bool>,
        isGridLayout: Binding<Bool>
    ) {
        self.group = group
        self.playlists = playlists
        self.store = store
        self._isPresented = isPresented
        self._isPresentedVideoList = isPresentedVideoList
        self._isGridLayout = isGridLayout
    }

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(group.title)
                        .font(.title2.bold())
                        .lineLimit(1) // 섹션 타이틀 한 줄로 제한
                        .truncationMode(.tail)
                    
                    Spacer()
                    
                    // 재생 목록이 3개 미만이면 전체 보기가 의미기 없어 노출하지 않는다.
                    if playlists.count > 2 {
                        
                        Button(action: {
                            viewStore.send(.selectGroup(group))
                            self.isPresented.toggle()
                        }) {
                            Text("전체보기")
                                .font(.subheadline)
                                .foregroundColor(.accentColor)
                        }
                    }
                }
                    
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 12) {
                        ForEach(playlists) { item in
                            PlaylistCardView(item: item)
                                .onTapGesture {
                                    viewStore.send(.selectPlaylist(item))
                                    self.isPresentedVideoList.toggle()
                                }
                        }
                    }
                    .padding(.horizontal, 4)
                }
            }
        }
    }
}
