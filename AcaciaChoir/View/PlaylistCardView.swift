//
//  PlaylistCardView.swift
//  PlayListApp
//
//  Created by JooYoung Kim on 4/18/25.
//

import SwiftUI

struct PlaylistCardView: View {
    let item: PlaylistItem

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                AsyncImage(url: URL(string: item.thumbnailURL ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(16/9, contentMode: .fit)
                        .frame(width: 260, height: 146.25)
                        .clipped()
                        .cornerRadius(8)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 260, height: 146.25)
                        .cornerRadius(8)
                }
            }

            // 제목 표시
            Text(item.title)
                .font(.subheadline)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(width: 260, alignment: .leading) // 텍스트 너비 맞추기
        }
    }
}
