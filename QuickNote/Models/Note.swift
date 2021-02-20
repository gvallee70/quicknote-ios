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
}

//class Note {
//    private var title: String
//    private var content: String
//
//    init(title: String, content: String) {
//        self.title = title
//        self.content = content
//    }
//
//    func getTitle() -> String {
//        return self.title
//    }
//
//    func getContent() -> String {
//        return self.content
//    }
//}
