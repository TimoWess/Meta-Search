//
//  ContentView.swift
//  Meta Search
//
//  Created by Timo Wesselmann on 02.02.23.
//

import SwiftUI

extension URL {
    var isDirectory: Bool {
        (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }
}

extension String {
    func fuzzyMatchCaseInsensitive(_ needle: String) -> Bool {
        if needle.isEmpty { return true }
        var remainder = needle.lowercased()[...]
        for char in self.lowercased() {
            if char == remainder[remainder.startIndex] {
                remainder.removeFirst()
                if remainder.isEmpty { return true }
            }
        }
        return false
    }
}

struct ContentView: View {
    @EnvironmentObject var fileListVM: FileListViewModel
    
    var body: some View {
        VStack {
            StartView()
            InputFormView()
            FileListView()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
