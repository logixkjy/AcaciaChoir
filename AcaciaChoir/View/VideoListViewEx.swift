//
//  VideoListViewEx.swift
//  AcaciaChoir
//
//  Created by JooYoung Kim on 10/29/25.
//


import SwiftUI

extension VideoListView {
    struct VideoRowView: View {
        let video: YouTubeVideo
        let isExternal: Bool
        
        var body: some View {
            HStack(alignment: .top, spacing: 12) {
                ZStack(alignment: .topLeading) {
                    // 썸네일 이미지
                    AsyncImage(url: URL(string: video.thumbnailURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(16/9, contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                    }
                    .frame(width: 160, height: 90)
                    .clipped()
                    .cornerRadius(8)
                    
                    if isExternal {
                        Text("출처 \(video.videoOwnerChannelTitle)")
                            .font(.caption2.weight(.semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(4)
                            .padding(6)
                    }
                    // ⏱ 재생 시간 오버레이
                    if let duration = video.duration {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Text(duration)
                                    .font(.caption2.weight(.semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.black.opacity(0.7))
                                    .cornerRadius(4)
                                    .padding(6)
                            }
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(video.title)
                        .font(.headline)
                        .lineLimit(2)
                }
                
                Spacer()
            }
            .padding(.vertical, 4)
        }
    }
    
    struct VideoGridCard: View {
        let video: YouTubeVideo
        let isExternal: Bool
        
        var body: some View {
            VStack(alignment: .leading, spacing: 6) {
                ZStack(alignment: .topLeading) {
                    let url = video.thumbnailURL
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
                    
                    if isExternal {
                        Text("출처 \(video.videoOwnerChannelTitle)")
                            .font(.caption2.weight(.semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(4)
                            .padding(6)
                    }
                    // ⏱ 재생 시간 오버레이
                    if let duration = video.duration {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Text(duration)
                                    .font(.caption2.weight(.semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.black.opacity(0.7))
                                    .cornerRadius(4)
                                    .padding(6)
                            }
                        }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous)) // ZStack에 적용해야 테두리 일괄 클립
                .contentShape(Rectangle())
                
                // 3) 제목: 고정 폭 제거, 가변 폭 + 줄바꿈
                Text(video.title)
                    .font(.subheadline)
                    .lineLimit(1)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true) 
            }
        }
    }
}
