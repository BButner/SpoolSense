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
    
    init() {
        let api = SpoolSenseApi()
        self.spoolApi = api
        self.mainViewModel = MainViewModel(api: api)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(spoolApi)
                .environment(mainViewModel)
        }
    }
}
