//
//  FileListViewModel.swift
//  Meta Search
//
//  Created by Timo Wesselmann on 18.02.23.
//

import Foundation

class FileListViewModel: ObservableObject {
    @Published var directory: URL?              = nil
    @Published var allFiles: [FileMetaData]     = []
    @Published var searchName                   = ""
    @Published var searchExtension              = ""
    @Published var searchOwner                  = ""
    @Published var searchSizeStart              = ""
    @Published var searchSizeEnd                = ""
    @Published var creationDateStart            = Date()
    @Published var creationDateEnd              = Date()
    @Published var modificationDateStart        = Date()
    @Published var modificationDateEnd          = Date()
    @Published var isFuzzyName                  = true
    @Published var checkCreationDate            = false
    @Published var checkModificationDate        = false
    @Published var selectedUnitMin: SizeUnits   = .mb
    @Published var selectedUnitMax: SizeUnits   = .mb
    
    let fm = FileManager.default
    
    var checkOptions: CheckFileOptions {
        return CheckFileOptions(
            searchName: searchName,
            isFuzzyName: isFuzzyName,
            searchExtension: searchExtension,
            searchOwner: searchOwner,
            searchSizeStart: searchSizeStart,
            searchSizeEnd: searchSizeEnd,
            selectedUnitMin: selectedUnitMin,
            selectedUnitMax: selectedUnitMax,
            creationDateStart: creationDateStart,
            creationDateEnd: creationDateEnd,
            modDateStart: modificationDateStart,
            modDateEnd: modificationDateEnd,
            checkModificationDate: checkModificationDate,
            checkCreationDate: checkCreationDate
        )
    }
    
    func populateFileList() {
        guard let directory = directory else { print("No directory set!"); return }
        let fileEnumerator = fm.enumerator(at: directory, includingPropertiesForKeys: nil)
        while let file = fileEnumerator?.nextObject() as? URL  {
            if !file.isDirectory {
                let newFile = FileMetaData(file: file)
                self.allFiles.append(newFile)
            }
        }
    }
    
    func populateFileListAsync() async {
        guard let directory = directory else { return }
        let fileEnumerator = fm.enumerator(at: directory, includingPropertiesForKeys: nil)
        while let file = fileEnumerator?.nextObject() as? URL  {
            if !file.isDirectory {
                let newFile = FileMetaData(file: file)
                self.allFiles.append(newFile)
            }
        }
    }
    func reset() {
        self.allFiles.removeAll()
        self.directory = nil
    }
    
    #if DEBUG
    public static let example = {
        var temp = FileListViewModel()
        temp.allFiles = [FileMetaData(file: URL(string: "file:///Users/kerail/.zshrc")!)]
        return temp
    }()
    #endif
}
