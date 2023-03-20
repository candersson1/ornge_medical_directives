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

class MenuItem : Codable {
    let title : String
    
    private enum MenuItemKeys: String, CodingKey {
        case title
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MenuItemKeys.self)
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
    }
}

//Root class from which all the menus and menu items are parsed. There should only be one menus object
class Menus : Codable {
    let menus: [MenuItem]
    
    enum MenusKey: CodingKey {
        case menus
    }
    
    enum MenuItemTypeKey: CodingKey {
        case type
    }
    
    enum MenuItemTypes: String, Decodable {
        case menu = "menu"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MenusKey.self)
        var pagesArrayForType = try container.nestedUnkeyedContainer(forKey: MenusKey.menus)
        var pages = [MenuItem]()
        
        var pagesArray = pagesArrayForType
        while(!pagesArrayForType.isAtEnd) {
            let page = try pagesArrayForType.nestedContainer(keyedBy: MenuItemTypeKey.self)
            let type = try page.decode(MenuItemTypes.self, forKey: MenuItemTypeKey.type)
            switch type {
            case .menu:
                pages.append(try pagesArray.decode(Menu.self))
            }
        }
        self.menus = pages
    }
}

class MenuDocumentLink : MenuItem {
    let key : String
    
    private enum MenuDocumentLinkKeys: String, CodingKey {
        case key
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MenuDocumentLinkKeys.self)
        self.key = try container.decodeIfPresent(String.self, forKey: .key) ?? ""
        try super.init(from: decoder)
    }
}

class Menu : MenuItem {
    var items: [MenuItem]
    
    private enum MenuCodingKeys: CodingKey {
        case items
    }
    
    enum MenuItemsKey: CodingKey {
        case items
    }
    
    enum MenuItemTypeKey: CodingKey {
        case type
    }
    
    enum MenuItemTypes: String, Decodable {
        case menu = "menu"
        case menu_document_link = "menu_document_link"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MenuItemsKey.self)
        var pagesArrayForType = try container.nestedUnkeyedContainer(forKey: MenuItemsKey.items)
        var pages = [MenuItem]()
        
        var pagesArray = pagesArrayForType
        while(!pagesArrayForType.isAtEnd) {
            let page = try pagesArrayForType.nestedContainer(keyedBy: MenuItemTypeKey.self)
            let type = try page.decode(MenuItemTypes.self, forKey: MenuItemTypeKey.type)
            switch type {
            case .menu:
                pages.append(try pagesArray.decode(Menu.self))
            case .menu_document_link:
                pages.append(try pagesArray.decode(MenuDocumentLink.self))
            }
        }
        self.items = pages
        try super.init(from: decoder)
    }
}
