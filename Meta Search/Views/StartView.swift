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
    @State var allFiles: [[FileAttributeKey : Any]] = []
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Button("Select Folder")
            {
                withAnimation {
                    let panel = NSOpenPanel()
                    panel.allowsMultipleSelection = false
                    panel.canChooseFiles          = false
                    panel.canChooseDirectories    = true
                    if panel.runModal() == .OK {
                        fileListVM.allFiles.removeAll()
                        fileListVM.directory = panel.url
                        let fileEnumerator = fm.enumerator(at: fileListVM.directory!, includingPropertiesForKeys: nil)
                        fileListVM.populateFileList(fileEnumerator: fileEnumerator)
                    }
                }
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
