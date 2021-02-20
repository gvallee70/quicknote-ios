//
//  APIManager.swift
//  QuickNote
//
//  Created by Théo Brouillé on 07/02/2021.
//

import Foundation
import Alamofire

struct PreNote {
    let title: String
    let content: String
}

enum APIManager: URLRequestConvertible {
    static let endpoint = URL(string: "http://localhost:8080")!
    
    var path: String {
        switch self {
        case .getAllNotes(let user):
            return "/users/\(user)/notes"
        case .createNote(let user, _, _):
            return "/users/\(user)/notes"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAllNotes(_):
            return .get
        case .createNote(_, _, _):
            return .post
        }
    }
    
    var encoding: URLEncoding {
        switch self {
        default:
            return .default
        }
    }
    
    case getAllNotes(user: String)
    case createNote(user: String, title: String, content: String)
    
    // GET all notes
    static func getAllNotes(for user: String, completion: @escaping ([Note]) -> Void) {
        AF.request(APIManager.getAllNotes(user: user)).responseJSON { (json) in
            if let jsonData = json.data {
                let jsonDecoder = JSONDecoder()
                let notes = try! jsonDecoder.decode([Note].self, from: jsonData)
                
                completion(notes)
            }
        }
    }
    
    // POST new note
    static func postNote(for user: String, withTitle title: String, andContent content: String, completion: @escaping (Bool, Note?) -> Void) {
        AF.request(APIManager.createNote(user: user, title: title, content: content)).responseJSON { (json) in
            switch json.result {
            case .success:
                if let jsonData = json.data {
                    let jsonDecoder = JSONDecoder()
                    let note = try! jsonDecoder.decode(Note.self, from: jsonData)
                    
                    completion(true, note)
                }
                
                completion(false, nil)
            case .failure(let error):
                print(error)
                completion(false, nil)
            }
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: APIManager.endpoint.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        
        var parameters: [String: Any] = [:]
//        var parameters: Parameters
        
        switch self {
        case .createNote(_, let title, let content):
//            let preNote = PreNote(title: title, content: content)
//            parameters["note"] = preNote
            parameters = ["note": ["title": title, "content": content]]
            
            request.addValue("Content-Type", forHTTPHeaderField: "application/json; charset=UTF-8")
        default:
            break
        }
        
        request = try encoding.encode(request, with: parameters)
        
        return request
    }
}
