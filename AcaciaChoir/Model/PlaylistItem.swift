//
//  PlaylistItem.swift
//  AcaciaChoir
//
//  Created by JooYoung Kim on 10/29/25.
//

import Foundation

struct PlaylistItem: Identifiable, Codable, Equatable, Hashable {
    var id: String         // YouTube Playlist ID
    var title: String
    var description: String
    var thumbnailURL: String?
    
    // 말머리 배열 추출: description 맨 앞에서 [TOKEN] [ANOTHER] ... 형식 반복 추출
    public var parsedGroups: [String] {
        var groups: [String] = []
        var cursor = description[...]
        while let open = cursor.firstIndex(of: "["),
              open == cursor.startIndex,                         // 반드시 맨 앞에서만
              let close = cursor.firstIndex(of: "]") {
            let inner = cursor[cursor.index(after: open)..<close]
            if inner.contains(":") {
                if let group = (inner.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()).components(separatedBy: ":").first {
                    groups.append(group)
                }
            }
            // 다음 토큰으로 이동
            let nextStart = cursor.index(after: close)
            cursor = cursor[nextStart...].drop(while: { $0.isWhitespace })
        }
        return groups
    }
    // 외부 채널 영상 인지 구분
    public var parsedIsExternal: [Bool] {
        var isExternals: [Bool] = []
        var cursor = description[...]
        while let open = cursor.firstIndex(of: "["),
              open == cursor.startIndex,                         // 반드시 맨 앞에서만
              let close = cursor.firstIndex(of: "]") {
            let inner = cursor[cursor.index(after: open)..<close]
            if inner.contains(":") {
                let arr = (inner.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()).components(separatedBy: ":")
                if arr.count > 1 {
                    isExternals.append(arr[1] == "external")
                }
            }
            // 다음 토큰으로 이동
            let nextStart = cursor.index(after: close)
            cursor = cursor[nextStart...].drop(while: { $0.isWhitespace })
        }
        return isExternals
    }
    
    // 대표 그룹 키. 없으면 others
    public var groupKey: String {
        parsedGroups.first ?? "others"
    }
    
    public var isExternal: Bool {
        parsedIsExternal.first ?? true
    }
    
    // 말머리 제거된 설명
    public var cleanDescription: String {
        PlaylistItem.stripLeadingTags(in: description)
    }
    
    // 말머리 제거된 제목. 제목엔 말머리를 안 다는 정책이지만 안전상 동일 처리
    public var cleanTitle: String {
        PlaylistItem.stripLeadingTags(in: title)
    }
    
    // 정렬 보조용 키: 최신 우선, 그다음 제목
    public var sortHint: String {
//        let ts = publishedAt?.timeIntervalSince1970 ?? 0
//        // 내림차순 정렬을 위해 마이너스 부호를 붙여 문자열화
//        return String(format: "%015.0f", -ts) + cleanTitle.lowercased()
        return cleanTitle.lowercased()
    }
    
    private static func stripLeadingTags(in text: String) -> String {
        // 맨 앞의 [ ... ] 블록들만 제거
        let pattern = #"^\s*(\[[^\]]+\]\s*)+"#
        if let regex = try? NSRegularExpression(pattern: pattern) {
            let range = NSRange(text.startIndex..., in: text)
            let trimmed = regex.stringByReplacingMatches(in: text, options: [], range: range, withTemplate: "")
            return trimmed.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
