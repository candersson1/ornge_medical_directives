//
//  Document.swift
//  Ornge
//
//  Created by Charles Trickey on 2020-03-14.
//  Copyright © 2020 Charles Trickey. All rights reserved.
//

import Foundation
import UIKit

//Root JSON object that will hold all the documents data
struct Documents : Codable {
    let documents: [Document]
    
    enum DocumentsKey: CodingKey {
        case documents
    }
    
    enum DocumentTypeKey: CodingKey {
        case type
    }
    
    enum DocumentTypes: String, Decodable {
        case dep_document = "dep_document"
        case document = "document"
        case directive = "directive"
        case tool = "tool"
        case drug_monograph = "drug_monograph"
        case webview = "webview"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DocumentsKey.self)
        var documentsArrayForType = try container.nestedUnkeyedContainer(forKey: DocumentsKey.documents)
        var documents = [Document]()
        
        var documentsArray = documentsArrayForType
        while(!documentsArrayForType.isAtEnd) {
            let document = try documentsArrayForType.nestedContainer(keyedBy: DocumentTypeKey.self)
            let type = try document.decode(DocumentTypes.self, forKey: DocumentTypeKey.type)
            switch type {
            case .document:
                documents.append(try documentsArray.decode(Document.self))
            case .directive:
                documents.append(try documentsArray.decode(MedicalDirective.self))
            case .tool:
                documents.append(try documentsArray.decode(Document.self)) //no additional info is held in JSON
                break
            case .drug_monograph:
                break
            case .webview:
                documents.append(try documentsArray.decode(Document.self)) //no additional info is held in JSON
                break
            case .dep_document:
                documents.append(try documentsArray.decode(dep_Document.self))
                break
            }
        }
        self.documents = documents
    }
}

class Document : Codable {
    var title: String
    var key: String
    var type: DocumentType
    
    private enum CodingKeys: String, CodingKey {
        case title
        case key
        case type
    }
    
    enum DocumentType: String
    {
        case directive = "directive"
        case drug_monograph = "drug_monograph"
        case document = "document"
        case tool = "tool"
        case webview = "webview"
        case dep_document = "dep_document"
        case unknown
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.key = try container.decodeIfPresent(String.self, forKey: .key) ?? ""
        self.type = DocumentType(rawValue: try container.decode(String.self, forKey: .type)) ?? .unknown
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(key, forKey: .key)
    }
}

class dep_Document : Document {
    var text : String
    let sections : [dep_Section]
    let content : [[[String]]]
    
    private enum CodingKeys: String, CodingKey {
        case text
        case content
        case sections
    }
    
    required init(from decoder: Decoder) throws {
        print("Using deprecated class dep_Document, this will be removed in the future, discontinue use" )
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try container.decodeIfPresent(String.self, forKey: .text) ?? ""
        self.content = try container.decodeIfPresent([[[String]]].self, forKey: .content) ?? [[[]]]
        self.sections = try container.decodeIfPresent([dep_Section].self, forKey: .sections) ?? []
        try super.init(from: decoder)
    }
}


class dep_Section : Decodable {
    var header : [String]
    var cells : [[String]]
    var width : Float
    let horizontalInset : Float
    let verticalSpacing : Float
    
    private enum CodingKeys: String, CodingKey {
        case header
        case cells
        case width
        case horizontalInset
        case verticalSpacing
    }
    
    required init(from decoder: Decoder) throws {
        print("Using deprecated class dep_Section, this will be removed in the future, discontinue use" )
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.header = try container.decodeIfPresent([String].self, forKey: .header) ?? []
        self.cells = try container.decodeIfPresent([[String]].self, forKey: .cells) ?? [[]]
        self.width = try container.decodeIfPresent(Float.self, forKey: .width) ?? 0
        self.horizontalInset = try container.decodeIfPresent(Float.self, forKey: .horizontalInset) ?? 20
        self.verticalSpacing = try container.decodeIfPresent(Float.self, forKey: .verticalSpacing) ?? 20
        
    }
}
