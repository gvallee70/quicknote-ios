//
//  Client.swift
//  QuickNote
//
//  Created by Théo Brouillé on 02/02/2021.
//

import Foundation
import Alamofire

class QuickNoteClient {
    static let url = "http://localhost:8080"
    
    // GET /users/:user/notes
    static func getNotes(forUser userID: String, completion: @escaping (Bool, [Note]?) -> Void) {
        AF.request(url + "/users/\(userID)/notes").responseJSON { (response) in
            switch response.result {
            case .success:
                if let jsonData = response.data {
                    let jsonDecoder = JSONDecoder()
                    let notes = try! jsonDecoder.decode([Note].self, from: jsonData)
                    
                    completion(true, notes)
                } else {
                    completion(false, nil)
                }
            case .failure:
                completion(false, nil)
            }
        }
    }
    
    // POST /users/:user/notes
    static func createNote(forUser user: String, withTitle title: String, andContent content: String, completion: @escaping (Bool, Note?) -> Void) {
        let parameters: [String: [String: String]] = ["note": ["title": title, "content": content]]
        
        AF.request(url + "/users/\(user)/notes",
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default).responseJSON { (response) in
            switch response.result {
            case .success:
                if let jsonData = response.data {
                    let jsonDecoder = JSONDecoder()
                    let note = try! jsonDecoder.decode(Note.self, from: jsonData)
                    
                    completion(true, note)
                } else {
                    completion(false, nil)
                }
            case .failure:
                completion(false, nil)
            }
        }
    }
    
    // PUT /users/:user/notes/:id
    static func editNote(forUser user: String, withID id: Int, title: String, andContent content: String, completion: @escaping (Bool) -> Void) {
        let parameters: [String: [String: String]] = ["note": ["title": title, "content": content]]
        
        AF.request(url + "/users/\(user)/notes/\(id)",
                   method: .put,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default).responseJSON { (response) in
            switch response.result {
            case .success:
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
    
    // DELETE /users/:user/notes/:id
    static func deleteNote(forUser user: String, withID id: Int, completion: @escaping (Bool) -> Void) {
        AF.request(url + "/users/\(user)/notes/\(id)",
                   method: .delete).responseJSON { (response) in
            switch response.result {
            case .success:
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
}
 
