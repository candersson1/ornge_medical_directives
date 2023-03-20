//
//  Content.swift
//  Ornge
//
//  Created by Charles Trickey on 2020-08-15.
//  Copyright © 2020 Charles Trickey. All rights reserved.
//
import Foundation

/*class Documents : Codable {
    let documents : [Document]
    
    enum DocumentsKey: String, CodingKey {
        case documents
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DocumentsKey.self)
        self.documents = try container.decode([Document].self, forKey: .documents)
    }
}

class Document : Codable {
    let title : String
    
    enum DocumentKeys: String, CodingKey {
        case title
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DocumentKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
    }
}

enum ContentType : String, Decodable{
    case Text = "text"
    case Table = "table"
    case Image = "image"
    case Medical_Directive = "medical_directive"
    case undefined = "nil"
}


class ContentItem : Decodable {
    var type : ContentType = .undefined
    
    private enum CodingKeys: String, CodingKey {
        case type
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decodeIfPresent(ContentType.self, forKey: .type) ?? ContentType.undefined
    }
}



class DocumentContentText : ContentItem {
    var text : String
    
    private enum CodingKeys: String, CodingKey {
        case text
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try container.decodeIfPresent(String.self, forKey: .text) ?? ""
        try super.init(from: decoder)
    }
}
*/
