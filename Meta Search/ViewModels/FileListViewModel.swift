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
    @Published var checkCreationDate            = false
    @Published var checkModificationDate        = false
    @Published var selectedUnitMin: SizeUnits   = .mb
    @Published var selectedUnitMax: SizeUnits   = .mb
    
    let fm = FileManager.default
    
    var checkOptions: CheckFileOptions {
        get {
            return CheckFileOptions(searchName: searchName, searchExtension: searchExtension, searchOwner: searchOwner, searchSizeStart: searchSizeStart, searchSizeEnd: searchSizeEnd, selectedUnitMin: selectedUnitMin, selectedUnitMax: selectedUnitMax)
        }
    }
    
    func populateFileList(fileEnumerator: FileManager.DirectoryEnumerator?) {
        while let file = fileEnumerator?.nextObject() as? URL  {
            if !file.isDirectory {
                let newFile = FileMetaData(file: file)
                self.allFiles.append(newFile)
            }
        }
        
    }
}
