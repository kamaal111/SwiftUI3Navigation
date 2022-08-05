//
//  ContentView.swift
//  SwiftUI3Navigation
//
//  Created by Kamaal M Farah on 05/08/2022.
//

import SwiftUI

enum NavigationLinkScreens: String, Hashable, Codable, CaseIterable {
    case first
    case second
    case stacked

    enum Stacked: String, Hashable, Codable, CaseIterable {
        case first
        case second
    }
}

enum ButtonScreens: String, Hashable, Codable, CaseIterable {
    case first
    case second
}

enum StackSelection: String, Hashable, CaseIterable {
    case first
    case second
}

struct ContentView: View {
    @State private var selection: StackSelection = .first

    var body: some View {
        #if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .phone {
            TabView(selection: $selection) {
                ForEach(StackSelection.allCases, id: \.self) { tabItem in
                    SelectionScreen(selection: selection)
                        .tag(tabItem)
                        .tabItem {
                            Image(systemName: "globe")
                            Text(tabItem.rawValue)
                        }
                }
            }
        } else {
            NavigationSplitView(sidebar: {
                ForEach(StackSelection.allCases, id: \.self) { item in
                    Button(action: { selection = item }) {
                        Label(item.rawValue, systemImage: "globe")
                    }
                }
            }, detail: {
                SelectionScreen(selection: selection)
            })
        }
        #else
        NavigationView {
            VStack {
                ForEach(StackSelection.allCases, id: \.self) { item in
                    Button(action: { selection = item }) {
                        Label(item.rawValue, systemImage: "globe")
                    }
                }
            }
            .toolbar(content: {
                Button(action: toggleSidebar) {
                    Label("Toggle Sidebar", systemImage: "sidebar.left")
                        .foregroundColor(.accentColor)
                }
            })
            SelectionScreen(selection: selection)
        }
        #endif
    }

    #if os(macOS)
    private func toggleSidebar() {
        guard let firstResponder = NSApp.keyWindow?.firstResponder else { return }
        firstResponder.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
    #endif
}

struct SelectionScreen: View {
    @State private var navigationPath = NavigationPath()

    let selection: StackSelection

    var body: some View {
        NavigationStack(path: $navigationPath) {
            Form {
                Section("NavigationLink") {
                    ForEach(NavigationLinkScreens.allCases, id: \.self) { screen in
                        NavigationLink(value: screen) {
                            Text("Go to \(screen.rawValue) navigation link screen")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
                Section("Buttons") {
                    ForEach(ButtonScreens.allCases, id: \.self) { screen in
                        Button(action: { navigationPath.append(screen) }) {
                            Text("Go to \(screen.rawValue) button screen")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
            }
            .navigationDestination(for: NavigationLinkScreens.self, destination: NavigationLinkScreen.init(_:))
            .navigationDestination(for: ButtonScreens.self, destination: ButtonScreen.init(_:))
            .navigationTitle("SwiftUI3 Nav \(selection.rawValue)")
        }
        .onChange(of: navigationPath) { newValue in
            print("navigation path", newValue)
        }
        .onChange(of: selection) { newValue in
            #if os(iOS)
            if UIDevice.current.userInterfaceIdiom == .pad {
                var navigationPath = self.navigationPath
                while !navigationPath.isEmpty {
                    navigationPath.removeLast()
                }
                self.navigationPath = navigationPath
            }
            #else
            var navigationPath = self.navigationPath
            while !navigationPath.isEmpty {
                navigationPath.removeLast()
            }
            self.navigationPath = navigationPath
            #endif
        }
    }
}

struct NavigationLinkScreen: View {
    let currentScreen: NavigationLinkScreens

    init(currentScreen: NavigationLinkScreens) {
        self.currentScreen = currentScreen
    }

    init(_ currentScreen: NavigationLinkScreens) {
        self.init(currentScreen: currentScreen)
    }

    var body: some View {
        VStack {
            switch currentScreen {
            case .first:
                Text("First")
            case .second:
                Text("Second")
            case .stacked:
                ForEach(NavigationLinkScreens.Stacked.allCases, id: \.self) { screen in
                    NavigationLink(value: screen) {
                        Text("Stack navigation \(screen.rawValue)")
                    }
                }
            }
        }
        .navigationTitle("Navigation Link")
        .navigationDestination(for: NavigationLinkScreens.Stacked.self) { screen in
            Text(screen.rawValue)
        }
    }
}

struct ButtonScreen: View {
    let currentScreen: ButtonScreens

    init(currentScreen: ButtonScreens) {
        self.currentScreen = currentScreen
    }

    init(_ currentScreen: ButtonScreens) {
        self.init(currentScreen: currentScreen)
    }

    var body: some View {
        switch currentScreen {
        case .first:
            Text("First")
        case .second:
            Text("Second")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
