//
//  SizeUnits.swift
//  Meta Search
//
//  Created by Timo Wesselmann on 18.02.23.
//

import Foundation

enum SizeUnits: String, CaseIterable, Identifiable {
    case b, kb, mb, gb, tb
    
    var id: Self { self }
    
    func getUnitMultiplier() -> Double {
        switch self {
        case .b:
            return 0
        case .kb:
            return 1000
        case .mb:
            return 1000000
        case .gb:
            return 1000000000
        case .tb:
            return 1000000000000
        }
    }

    static func getUnitString(index: Int) -> String {
        switch index {
        case 0:
            return "B"
        case 1:
            return "KB"
        case 2:
            return "MB"
        case 3:
            return "GB"
        default:
            return "TB"
        }
    }
    
    static func getBiggestUnitRepresentation(size: Int) -> String {
        var iterations = 0
        var temp = Double(size)
        while temp / 1000 > 1 {
            iterations += 1
            temp /= 1000
            if iterations > 3 { break }
        }
        return String(format: "%.2f \(getUnitString(index: iterations))", temp)
    }

}
