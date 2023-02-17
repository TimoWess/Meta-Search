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
    @State var directory: URL? = nil
    @State var allFiles: [FileMetaData] = []
    @State var searchName = ""
    @State var searchExtension = ""
    @State var searchOwner = ""
    @State private var searchSizeStart = ""
    @State private var searchSizeEnd = ""
    @State private var creationDateStart = Date()
    @State private var creationDateEnd = Date()
    @State private var modificationDateStart = Date()
    @State private var modificationDateEnd = Date()
    @State private var checkCreationDate = false
    @State private var checkModificationDate = false
    let fm = FileManager.default
    
    func checkFile(file: FileMetaData) -> Bool {
        var result = true
        
        if !searchName.isEmpty {
            result = result && file.name.localizedCaseInsensitiveContains(searchName)
        }
        if !searchExtension.isEmpty {
            result = result && file.fileExtension.hasPrefix(searchExtension.drop(while: { char in
                char == "."
            }))
        }
        if !searchOwner.isEmpty {
            result = result && file.owner.localizedCaseInsensitiveContains(searchOwner)
        }
        
        return result
    }
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
                        self.allFiles.removeAll()
                        self.directory = panel.url
                        let fileEnumerator = fm.enumerator(at: self.directory!, includingPropertiesForKeys: nil)
                        while let file = fileEnumerator?.nextObject() as? URL  {
                            if !file.isDirectory {
                                let newFile = FileMetaData(file: file)
                                allFiles.append(newFile)
                            }
                        }
                    }
                }
            }
            VStack {
                TextField("Name", text: $searchName)
                TextField("Extension", text: $searchExtension)
                TextField("Owner", text: $searchOwner)
                VStack(alignment: .leading) {
                    Text("Size").font(.headline)
                    HStack {
                        TextField("Min", text: $searchSizeStart)
                        TextField("Max", text: $searchSizeEnd)
                    }
                }
                VStack(alignment: .leading) {
                    HStack {
                        Text("Creation Date").font(.headline)
                        Toggle("", isOn: $checkCreationDate.animation())
                        Spacer()
                    }
                    if checkCreationDate {
                        HStack {
                            DatePicker(
                                "From",
                                selection: $creationDateStart,
                                displayedComponents: [.date]
                            )
                            DatePicker(
                                "To",
                                selection: $creationDateEnd,
                                displayedComponents: [.date]
                            )
                        }
                    }
                }
                .padding(.vertical)
                VStack(alignment: .leading) {
                    HStack() {
                        Text("Modification Date").font(.headline)
                        Toggle("", isOn: $checkModificationDate.animation())
                        Spacer()
                    }
                    
                    if checkModificationDate {
                        HStack {
                            DatePicker(
                                "From",
                                selection: $modificationDateStart,
                                displayedComponents: [.date]
                            )
                            DatePicker(
                                "To",
                                selection: $modificationDateEnd,
                                displayedComponents: [.date]
                            )
                        }
                    }
                }
            }
            if (!allFiles.isEmpty) {
                List {
                    ForEach(allFiles.filter(checkFile)) { file in
                        HStack {
                            Text(file.url.path())
                            Spacer()
                            Text(String(format: "%.2f KB", Double(file.size) / 1000))
                        }.onTapGesture(count: 2) {
                            NSWorkspace.shared.activateFileViewerSelecting([file.url])
                        }
                    }
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
