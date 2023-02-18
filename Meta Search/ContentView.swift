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
    let fm = FileManager.default
    @StateObject var fileListVM = FileListViewModel()
    
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
            VStack {
                TextField("Name", text: $fileListVM.searchName)
                TextField("Extension", text: $fileListVM.searchExtension)
                TextField("Owner", text: $fileListVM.searchOwner)
                VStack(alignment: .leading) {
                    Text("Size").font(.headline)
                    HStack {
                        TextField("Min", text: $fileListVM.searchSizeStart)
                        Picker("", selection: $fileListVM.selectedUnitMin) {
                            ForEach(SizeUnits.allCases) {
                                Text($0.rawValue.uppercased())
                            }
                        }
                        TextField("Max", text: $fileListVM.searchSizeEnd)
                        Picker("", selection: $fileListVM.selectedUnitMax) {
                            ForEach(SizeUnits.allCases) {
                                Text($0.rawValue.uppercased())
                            }
                        }
                    }
                }
                VStack(alignment: .leading) {
                    HStack {
                        Text("Creation Date").font(.headline)
                        Toggle("", isOn: $fileListVM.checkCreationDate.animation())
                        Spacer()
                    }
                    if fileListVM.checkCreationDate {
                        HStack {
                            DatePicker(
                                "From",
                                selection: $fileListVM.creationDateStart,
                                displayedComponents: [.date]
                            )
                            DatePicker(
                                "To",
                                selection: $fileListVM.creationDateEnd,
                                displayedComponents: [.date]
                            )
                        }
                    }
                }
                .padding(.vertical)
                
                VStack(alignment: .leading) {
                    HStack() {
                        Text("Modification Date").font(.headline)
                        Toggle("", isOn: $fileListVM.checkModificationDate.animation())
                        Spacer()
                    }
                    if fileListVM.checkModificationDate {
                        HStack {
                            DatePicker(
                                "From",
                                selection: $fileListVM.modificationDateStart,
                                displayedComponents: [.date]
                            )
                            DatePicker(
                                "To",
                                selection: $fileListVM.modificationDateEnd,
                                displayedComponents: [.date]
                            )
                        }
                    }
                }
            }
            if (!fileListVM.allFiles.isEmpty) {
                FileListView(allFiles: fileListVM.allFiles, checkOptions: fileListVM.checkOptions)
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
