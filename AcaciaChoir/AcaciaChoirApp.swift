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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                AttAuthentication.requestIfNeeded()
            }
        }
    }
}
