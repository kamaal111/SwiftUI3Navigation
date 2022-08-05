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

struct ContentView: View {
    @State private var navigationPath = NavigationPath()

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
            .navigationTitle("SwiftUI3 Nav")
        }
        .onChange(of: navigationPath) { newValue in
            print("navigation path", newValue)
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
