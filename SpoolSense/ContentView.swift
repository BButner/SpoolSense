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
    @Environment(OverlayManager.self) private var overlayManager
    
    @State private var isCheckingLogin: Bool = true
    @State private var loading: Bool = false
    @State private var complete: Bool = false
    @State private var error: Bool = false
    @State private var popupQueue: DispatchQueue = DispatchQueue(label: "popupQueue")
    
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
            DragConfirm(text: "Swipe to Test", isLoading: $loading, isComplete: $complete, isError: $error, successView: AnyView(exampleSuccessView()), errorView: AnyView(exampleErrorView()))
                .onChange(of: loading) {
                    Task {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                            complete = true
                        }
                    }
                }
        }
        .padding()
    }
    
    func exampleSuccessView() -> some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                Text("Success!")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                Spacer()
            }
            
            Spacer()
            
            Button("Close") {
                overlayManager.dequeueOverlay()
            }
        }
    }
    
    func exampleErrorView() -> some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                Text("Error!")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                Spacer()
            }
            
            Spacer()
            
            Button("Done") {
                overlayManager.dequeueOverlay()
            }
        }
    }
}

#Preview {
    @State var api = SpoolSenseApi()
    @State var mainContext = MainViewModel(api: api)
    @State var overlayManager: OverlayManager = OverlayManager()
    
    return ContentView()
        .environment(api)
        .environment(mainContext)
        .environment(overlayManager)
}
