//
//  FileListView.swift
//  Meta Search
//
//  Created by Timo Wesselmann on 18.02.23.
//

import SwiftUI

struct FileListView: View {
    @State var selectedFile: FileMetaData?
    @EnvironmentObject var fileListVM: FileListViewModel
    
    func shortenDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
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
        if fileListVM.checkCreationDate && fileListVM.creationDateStart < fileListVM.creationDateEnd {
            result = result && (fileListVM.creationDateStart ... fileListVM.creationDateEnd).contains(file.creationDate)
        }
        if fileListVM.checkModificationDate && fileListVM.modificationDateStart < fileListVM.modificationDateEnd {
            result = result && (fileListVM.modificationDateStart ... fileListVM.modificationDateEnd).contains(file.modificationDate)
        }
        
        return result
    }
    
    var body: some View {
        List {
            ForEach(fileListVM.allFiles.filter({ checkFile(file: $0, options: fileListVM.checkOptions) })) { file in
                HStack {
                    VStack(alignment: .leading) {
                        Text(file.url.path())
                        Text("Owner: \(file.owner)").font(.caption)
                    }
                    Spacer()
                    VStack {
                        HStack {
#if DEBUG
                            Text(String(format: "%.2f KB", Double(file.size) / 1000))
#endif
                            Text(SizeUnits.getBiggestUnitRepresentation(size: file.size))
                        }
                        Text("C: \(shortenDate(date: file.creationDate))")
                        Text("M: \(shortenDate(date: file.modificationDate))")
                    }
                }
                .listRowBackground(self.selectedFile?.id == file.id ? Color.accentColor : Color.clear)
                .onTapGesture(count: 2) {
                    NSWorkspace.shared.activateFileViewerSelecting([file.url])
                }
                .simultaneousGesture(TapGesture().onEnded {
                    self.selectedFile = file
                })
            }
        }
    }
}

struct FileListView_Previews: PreviewProvider {
    static var previews: some View {
        FileListView()
            .environmentObject(FileListViewModel.example)
    }
}
