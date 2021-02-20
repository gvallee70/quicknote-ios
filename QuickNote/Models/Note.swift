//
//  Note.swift
//  QuickNote
//
//  Created by Théo Brouillé on 06/01/2021.
//

import Foundation

struct Note: Decodable {
    let id: Int
    let user: String
    var title: String
    var content: String
    //var category: Category
    
    enum Category: Decodable {
      case all
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
    case "All": self = .all
    case "Work": self = .work
    case "Personal": self = .personal
    case "Other": self = .other
    default: return nil
    }
  }

  var rawValue: RawValue {
    switch self {
    case .all: return "All"
    case .work: return "Work"
    case .personal: return "Personal"
    case .other: return "Other"
    }
  }
}

