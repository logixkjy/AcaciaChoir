//
//  RootView.swift
//  OldHymns
//
//  Created by JooYoung Kim on 9/25/25.
//

// Views/RootView.swift  (슬라이드 컨테이너)
import SwiftUI
import ComposableArchitecture

struct RootView: View {
    @State private var isSplash: Bool = true
    
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        ZStack(alignment: .leading) {
            if isSplash {
                SplashView(isSplash: $isSplash)
                    .preferredColorScheme(.dark)
            } else {
                PlaylistHomeView(
                    store: Store(
                        initialState: PlaylistFeature.State(),
                        reducer: {
                            PlaylistFeature()
                        }
                    )
                )
                .onChange(of: scenePhase) { newPhase in
                    switch newPhase {
                    case .active:
                        AppOpenAdManager.shared.showAdIfAvailable()
                    case .background:
                        Task {
                            await AppOpenAdManager.shared.loadAd()
                        }
                        break
                    case .inactive:
                        break
                    @unknown default:
                        break
                    }
                }
            }
        }
    }
}
