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
    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
    func checkFile(file: FileMetaData, options: CheckFileOptions) -> Bool {
        var results: [Bool] = []
        
        if !options.searchName.isEmpty {
            results.append(file.name.localizedCaseInsensitiveContains(options.searchName))
        }
        if !options.searchExtension.isEmpty {
            results.append(file.fileExtension.hasPrefix(options.searchExtension.drop(while: { $0 == "." })))
        }
        if !options.searchOwner.isEmpty {
            results.append(file.owner.localizedCaseInsensitiveContains(options.searchOwner))
        }
        if let minSize = Double(options.searchSizeStart) {
            let minMultiplier = options.selectedUnitMin.getUnitMultiplier()
            results.append(minSize * minMultiplier <= Double(file.size))
        }
        if let maxSize = Double(options.searchSizeEnd) {
            let maxMultiplier = options.selectedUnitMax.getUnitMultiplier()
            results.append(Double(file.size) <= maxSize * maxMultiplier)
        }
        if options.checkCreationDate, let creationDateRange = options.creationDateRange {
            results.append(creationDateRange.contains(file.creationDate))
        }
        if options.checkModificationDate, let modDateRange = options.modDateRange {
            results.append(modDateRange.contains(file.modificationDate))
        }
        
        return results.allSatisfy {$0}
    }
    
    var body: some View {
        if (fileListVM.directory != nil) {
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
                            Text("C: \(formatDate(date: file.creationDate))")
                            Text("M: \(formatDate(date: file.modificationDate))")
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
}

struct FileListView_Previews: PreviewProvider {
    static var previews: some View {
        FileListView()
            .environmentObject(FileListViewModel.example)
    }
}
