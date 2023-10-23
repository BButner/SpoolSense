//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import SwiftUI

enum MenuOptions: Int, CaseIterable {
    case spools = 0
    case filaments = 1
    case cost = 2
    case settings = 3
    
    var title: String {
        switch self {
        case .spools:
            return "Spools"
        case .filaments:
            return "Filaments"
        case .cost:
            return "Cost"
        case .settings:
            return "Settings"
        }
    }
    
    var icon: Image {
        switch self {
        case .spools:
            return Image(systemName: "printer.fill")
        case .filaments:
            return Image(systemName: "sink.fill")
        case .cost:
            return Image(systemName: "chart.bar.xaxis")
        case .settings:
            return Image(systemName: "gearshape.fill")
        }
    }
    
    @ViewBuilder func view() -> some View {
        switch self {
        case .spools:
            withAnimation {
                SpoolsView()
            }
        case .filaments:
            withAnimation {
                FilamentsView()
            }
        case .cost:
            withAnimation {
                Text("Costs")
            }
        case .settings:
            withAnimation {
                Text("Settings")
            }
        }
    }
}


struct MainNavigation: View {
    @Environment(MainViewModel.self) private var mainContext
    @State private var selectedTab: Int = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(MenuOptions.allCases, id: \.rawValue) { menuOption in
                menuOption.view()
                    .tabItem {
                        menuOption.icon

                        Text(menuOption.title)
                    }
            }
        }
        .onAppear {
            if let window = keyWindow {
                window.backgroundColor = .black
            }
        }
        .task {
            await mainContext.loadInitialData()
        }
    }
}

extension MainNavigation {
    var keyWindow: UIWindow? {
        UIApplication.shared
            .connectedScenes.lazy
            .compactMap { $0.activationState == .foregroundActive ? ($0 as? UIWindowScene) : nil }
            .first(where: { $0.keyWindow != nil })?
            .keyWindow
    }
}

#Preview {
    @State var api = SpoolSenseApi()
    @State var mainContext = MainViewModel(api: api)
    
    return MainNavigation()
        .environment(api)
        .environment(mainContext)
}
