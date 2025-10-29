//
//  AcaciaChoirApp.swift
//  AcaciaChoir
//
//  Created by JooYoung Kim on 10/28/25.
//

import SwiftUI
import ComposableArchitecture

@main
struct AcaciaChoirApp: App {
    var body: some Scene {
        WindowGroup {
            PlaylistHomeView(
                store: Store(
                    initialState: PlaylistFeature.State(),
                    reducer: {
                        PlaylistFeature()
                    }
                )
            )
        }
    }
}
