//
//  CheckFileOptions.swift
//  Meta Search
//
//  Created by Timo Wesselmann on 18.02.23.
//

import Foundation

struct CheckFileOptions {
    var searchName: String?
    var searchExtension: String?
    var searchOwner: String?
    var searchSizeStart: String?
    var searchSizeEnd: String?
    var selectedUnitMin: SizeUnits?
    var selectedUnitMax: SizeUnits?
    var creationDateStart: Date?
    var creationDateEnd: Date?
    var modificationDateStart: Date?
    var modificationDateEnd: Date?
}
