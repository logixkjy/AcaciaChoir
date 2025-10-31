//
//  VideoDetailView.swift
//  PlayListApp
//
//  Created by JooYoung Kim on 4/5/25.
//

//
//  VideoDetailView.swift
//  PlayListApp
//
//  Created by JooYoung Kim on 4/5/25.
//
import SwiftUI
import WebKit
import ComposableArchitecture

struct VideoDetailView: View {
    let video: YouTubeVideo
    
    init(video: YouTubeVideo) {
        self.video = video
    }
    
    @Environment(\.dismiss) private var dismiss
    @State private var isDescriptionExpanded = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black01.ignoresSafeArea()
                
                ZStack(alignment: .bottom) {
                    VStack(spacing: 0) {
                        YouTubePlayerView(videoId: video.id)
                            .aspectRatio(16/9, contentMode: .fit)
                            .overlay(alignment: .topLeading) {
                                Button(action: { dismiss() }) {
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 20, weight: .semibold))
                                        .padding(8)
                                        .foregroundColor(.primary)
                                        .background(.ultraThinMaterial)
                                        .clipShape(Circle())
                                }
                                .padding(.top, 12)
                                .padding(.leading, 12)
                            }
                        
                        Divider()
                        
                        ScrollViewReader { proxy in
                            ScrollView {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text(video.title)
                                        .font(.title2)
                                        .bold()
                                    
                                    Text(video.description)
                                        .font(.body)
                                        .foregroundColor(.gray)
                                        .lineLimit(isDescriptionExpanded ? nil : 3)
                                    
                                    HStack {
                                        if video.description.count > 0 {
                                            Button(isDescriptionExpanded ? "접기" : "자세히보기") {
                                                withAnimation {
                                                    isDescriptionExpanded.toggle()
                                                }
                                            }
                                            .font(.subheadline)
                                            .foregroundColor(.blue)
                                        }
                                    }
                                    
                                    Divider()
                                }
                                .padding()
                            }
                        }
                        BannerSlot()
                    }
                }
            }
        }
    }
}

