//
//  SpoolSenseApp.swift
//  SpoolSense
//
//  Created by Beau Butner on 10/16/23.
//

import SwiftUI

@main
struct SpoolSenseApp: App {
    @State private var spoolApi: SpoolSenseApi
    @State private var mainViewModel: MainViewModel
    @State private var overlayManager: OverlayManager = OverlayManager()
    
    init() {
        let api = SpoolSenseApi()
        self.spoolApi = api
        self.mainViewModel = MainViewModel(api: api)
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .environment(spoolApi)
                    .environment(mainViewModel)
                    .environment(overlayManager)
                
                if let overlay = overlayManager.currentOverlay {
                    overlay.content
                }
            }
            .animation(.default, value: overlayManager.overlayQueue)
        }
    }
}
