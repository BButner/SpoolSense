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
    
    var body: some View {
//        ZStack {
//            if mainContext.session == nil {
//                LoginView(isCheckingLogin: $isCheckingLogin)
//            } else {
//                MainNavigation()
//            }
//            
//            VStack {
//                GeometryReader { geometry in
//                }
//                Spacer()
//                ProgressView()
//                Spacer()
//            }
//            .background(Color(.systemGroupedBackground))
//            .opacity(isCheckingLogin ? 1 : 0)
//            .animation(.spring, value: isCheckingLogin)
//        }
        VStack {
            Text("testing up here")
            Spacer()
            Text("testing this is a long test")
            Spacer()
            DragConfirm(text: "Swipe to Test", isLoading: $loading, isComplete: $complete, isError: $error)
                .onChange(of: loading) {
                    Task {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                            complete = true
                        }
                    }
                }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    @State var api = SpoolSenseApi()
    @State var mainContext = MainViewModel(api: api)
    
    return ContentView()
        .environment(api)
        .environment(mainContext)
}
