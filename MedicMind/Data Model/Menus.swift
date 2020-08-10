//
//  Menus.swift
//  MedicMind
//
//  Created by Charles Trickey on 2019-06-17.
//  Copyright © 2019 Charles Trickey. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Menu : Page {
    var items: [Page]
    
    private enum MenuCodingKeys: CodingKey {
        case items
    }
    
    enum PagesKey: CodingKey {
        case items
    }
    
    enum PageTypeKey: CodingKey {
        case type
    }
    
    enum PageTypes: String, Decodable {
        case menu = "menu"
        case directive = "directive"
        case tool = "tool"
        case document = "document"
        case webview = "webview"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PagesKey.self)
        var pagesArrayForType = try container.nestedUnkeyedContainer(forKey: PagesKey.items)
        var pages = [Page]()
        
        var pagesArray = pagesArrayForType
        while(!pagesArrayForType.isAtEnd) {
            let page = try pagesArrayForType.nestedContainer(keyedBy: PageTypeKey.self)
            let type = try page.decode(PageTypes.self, forKey: PageTypeKey.type)
            switch type {
            case .menu:
                pages.append(try pagesArray.decode(Menu.self))
            case .directive:
                pages.append(try pagesArray.decode(Page.self))
            case .tool:
                pages.append(try pagesArray.decode(Page.self))
            case .document:
                pages.append(try pagesArray.decode(Document.self))
            case .webview:
                pages.append(try pagesArray.decode(Document.self))
            }
        }
        self.items = pages
        try super.init(from: decoder)
    }
}
