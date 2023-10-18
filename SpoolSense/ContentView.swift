//
//  ContentView.swift
//  SpoolSense
//
//  Created by Beau Butner on 10/16/23.
//

import SwiftUI

struct ContentView: View {
    @Environment(MainViewModel.self) private var mainContext
    @Environment(SpoolSenseApi.self) private var api
    
    var body: some View {
        if mainContext.session == nil {
            LoginView()
        } else {
            MainNavigation()
        }
    }
}

#Preview {
    @State var api = SpoolSenseApi()
    @State var mainContext = MainViewModel(api: api)
    
    return ContentView()
        .environment(api)
        .environment(mainContext)
}
