//
//  FileListView.swift
//  Meta Search
//
//  Created by Timo Wesselmann on 18.02.23.
//

import SwiftUI

struct FileListView: View {
    let allFiles: [FileMetaData]
    let checkOptions: CheckFileOptions
    @State var selectedFile: FileMetaData?
    
    func checkFile(file: FileMetaData, options: CheckFileOptions) -> Bool {
        var result = true
        
        if let searchName = options.searchName {
            if !searchName.isEmpty {
                result = result && file.name.localizedCaseInsensitiveContains(searchName)
            }
        }
        if let searchExtension = options.searchExtension {
            if !searchExtension.isEmpty {
                result = result && file.fileExtension.hasPrefix(searchExtension.drop(while: { $0 == "." }))
            }
        }
        if let searchOwner = options.searchOwner {
            if !searchOwner.isEmpty {
                result = result && file.owner.localizedCaseInsensitiveContains(searchOwner)
            }
        }
        if let searchSizeStart = options.searchSizeStart, let selectedUnitMin = options.selectedUnitMin {
            if let minSize = Double(searchSizeStart) {
                let minMultiplier = selectedUnitMin.getUnitMultiplier()
                result = result && minSize * minMultiplier <= Double(file.size)
            }
        }
        if let searchSizeEnd = options.searchSizeEnd, let selectedUnitMax = options.selectedUnitMax {
            if let maxSize = Double(searchSizeEnd) {
                let maxMultiplier = selectedUnitMax.getUnitMultiplier()
                result = result && Double(file.size) <= maxSize * maxMultiplier
            }
        }
        
        return result
    }
    
    var body: some View {
        List {
            ForEach(allFiles.filter({ checkFile(file: $0, options: checkOptions) })) { file in
                HStack {
                    Text(file.url.path())
                    Spacer()
#if DEBUG
                    Text(String(format: "%.2f KB", Double(file.size) / 1000))
#endif
                    Text(SizeUnits.getBiggestUnitRepresentation(size: file.size))
                }
                .listRowBackground(self.selectedFile?.id == file.id ? Color.accentColor : Color.clear)
                .onTapGesture {
                    self.selectedFile = file
                }
                .onTapGesture(count: 2) {
                    NSWorkspace.shared.activateFileViewerSelecting([file.url])
                }
            }
        }
    }
}

struct FileListView_Previews: PreviewProvider {
    static var previews: some View {
        FileListView(allFiles: [.init(file: URL(string: "file:///Users/kerail/.zshrc")!)], checkOptions: .init())
    }
}
