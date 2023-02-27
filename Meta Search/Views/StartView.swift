//
//  StartView.swift
//  Meta Search
//
//  Created by Timo Wesselmann on 19.02.23.
//

import SwiftUI

struct StartView: View {
    @EnvironmentObject var fileListVM: FileListViewModel
    let fm = FileManager.default
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Button("Select Folder", action: selectDirectory)
        }
    }
    
    func selectDirectory() {
        withAnimation {
            let panel = NSOpenPanel()
            panel.allowsMultipleSelection = false
            panel.canChooseFiles          = false
            panel.canChooseDirectories    = true
            if panel.runModal() == .OK {
                fileListVM.reset()
                fileListVM.directory = panel.url
                fileListVM.populateFileList()
            }
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
            .environmentObject(FileListViewModel())
    }
}

