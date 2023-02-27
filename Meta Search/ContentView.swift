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
