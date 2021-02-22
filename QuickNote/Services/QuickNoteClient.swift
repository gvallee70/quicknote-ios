//
//  Client.swift
//  QuickNote
//
//  Created by Théo Brouillé on 02/02/2021.
//

import Foundation
import Alamofire

class QuickNoteClient {
    static let url = SettingsBundleHelper.shared.currentEnvironment.url
    
    // GET /users/:user/notes
    static func getNotes(forUser userID: String, completion: @escaping (Bool, [Note]?) -> Void) {
        AF.request(url + "/users/\(userID)/notes").responseJSON { (response) in
            switch response.result {
            case .success:
                if let jsonData = response.data {
                    let jsonDecoder = JSONDecoder()
                    let notes = try! jsonDecoder.decode([Note].self, from: jsonData)
                    
                    return completion(true, notes)
                } else {
                    return completion(false, nil)
                }
            case .failure:
                return completion(false, nil)
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
                    guard let note = try? jsonDecoder.decode(Note.self, from: jsonData) else {
                        return completion(false, nil)
                    }
                    
                    return completion(true, note)
                } else {
                    return completion(false, nil)
                }
            case .failure:
                return completion(false, nil)
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
                return completion(true)
            case .failure:
                return completion(false)
            }
        }
    }
    
    // DELETE /users/:user/notes/:id
    static func deleteNote(forUser user: String, withID id: Int, completion: @escaping (Bool) -> Void) {
        AF.request(url + "/users/\(user)/notes/\(id)",
                   method: .delete).responseJSON { (response) in
            switch response.result {
            case .success:
                return completion(true)
            case .failure:
                return completion(false)
            }
        }
    }
}
 
