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
    
    @State private var isCheckingLogin: Bool = true
    @State private var loading: Bool = false
    @State private var complete: Bool = false
    @State private var error: Bool = false
    @State private var popupQueue: DispatchQueue = DispatchQueue(label: "popupQueue")
    
    var body: some View {
        ZStack {
            if mainContext.session == nil {
                LoginView(isCheckingLogin: $isCheckingLogin)
            } else {
                MainNavigation()
            }
            
            VStack {
                GeometryReader { geometry in
                }
                Spacer()
                ProgressView()
                Spacer()
            }
            .background(Color(.systemGroupedBackground))
            .opacity(isCheckingLogin ? 1 : 0)
            .animation(.spring, value: isCheckingLogin)
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
