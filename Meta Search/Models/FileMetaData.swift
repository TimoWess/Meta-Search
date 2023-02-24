//
//  FileMetaData.swift
//  Meta Search
//
//  Created by Timo Wesselmann on 11.02.23.
//

import Foundation

struct FileMetaData: Identifiable {
    let id: URL
    let name: String
    let creationDate: Date
    let modificationDate: Date
    let owner: String
    let url: URL
    let size: Int
    let fileExtension: String
    
    init(file: URL) {
        let attr = try! FileManager.default.attributesOfItem(atPath: file.path)
        self.name = file.lastPathComponent
        self.creationDate = attr[.creationDate] as! Date
        self.modificationDate = attr[.modificationDate] as! Date
        self.owner = attr[.ownerAccountName] as! String
        self.url = file
        self.size = attr[.size] as! Int
        self.id = self.url
        self.fileExtension = self.url.pathExtension
    }
}
