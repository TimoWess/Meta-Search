//
//  Meta_SearchApp.swift
//  Meta Search
//
//  Created by Timo Wesselmann on 02.02.23.
//

import SwiftUI

@main
struct Meta_SearchApp: App {
    @StateObject var fileListVM = FileListViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(fileListVM)
        }
    }
}
