//
//  Document.swift
//  Ornge
//
//  Created by Charles Trickey on 2020-03-14.
//  Copyright © 2020 Charles Trickey. All rights reserved.
//

import Foundation
import UIKit


class Document : Page {
    var text : String
    let sections : [Section]
    let content : [[[String]]]
    
    private enum CodingKeys: String, CodingKey {
        case text
        case content
        case sections
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try container.decodeIfPresent(String.self, forKey: .text) ?? ""
        self.content = try container.decodeIfPresent([[[String]]].self, forKey: .content) ?? [[[]]]
        self.sections = try container.decodeIfPresent([Section].self, forKey: .sections) ?? []
        try super.init(from: decoder)
    }
}

class Section : Decodable {
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
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.header = try container.decodeIfPresent([String].self, forKey: .header) ?? []
        self.cells = try container.decodeIfPresent([[String]].self, forKey: .cells) ?? [[]]
        self.width = try container.decodeIfPresent(Float.self, forKey: .width) ?? 0
        self.horizontalInset = try container.decodeIfPresent(Float.self, forKey: .horizontalInset) ?? 20
        self.verticalSpacing = try container.decodeIfPresent(Float.self, forKey: .verticalSpacing) ?? 20
        
    }
}
