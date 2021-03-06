//
//  Note.swift
//  QuickNote
//
//  Created by Théo Brouillé on 06/01/2021.
//

import Foundation
import UIKit

struct Note: Decodable {
    let id: Int
    let user: String
    var title: String
    var content: String
    var category: Category
    
    enum Category: Decodable {
        case none
        case work
        case personal
        case other
    }
}

extension Note.Category: CaseIterable { }

extension Note.Category: RawRepresentable {
    typealias RawValue = String
    
    init?(rawValue: RawValue) {
        switch rawValue {
        case "": self = .none
        case LABEL_WORK: self = .work
        case LABEL_PERSONAL: self = .personal
        case LABEL_OTHER: self = .other
        default: return nil
        }
    }
    
    var rawValue: RawValue {
        switch self {
        case .none: return ""
        case .work: return LABEL_WORK
        case .personal: return LABEL_PERSONAL
        case .other: return LABEL_OTHER
        }
    }
    
    var color: UIColor {
        switch self {
        case .none: return .red
        case .work: return .systemTeal
        case .personal: return .systemGreen
        case .other: return .systemYellow
        }
    }
    
}
