import Foundation
import UIKit

class Page : Codable {
    var title: String
    var key: String
    var type: PageType
    
    private enum CodingKeys: String, CodingKey {
        case title
        case key
        case type
    }
    
    enum PageType
    {
        case none
        case directive
        case drug_monograph
        case document
        case tool
        case webview
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.key = try container.decodeIfPresent(String.self, forKey: .key) ?? ""
        
        let str = try container.decode(String.self, forKey: .type)
        if(str == "directive")
        {
            type = .directive
        }
        else if str == "drug_monograph"
        {
            type = .drug_monograph
        }
        else if str == "document"
        {
            type = .document
        }
        else if str == "tool"
        {
            type = .tool
        }
        else if str == "webview" {
            type = .webview
        }
        else
        {
            type = .none
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(key, forKey: .key)
    }
}

extension String : CodingKey
{
    public init?(intValue: Int) {
        return nil
    }
    public init?(stringValue: String) {
        self.init(stringValue)
    }
    public var stringValue: String {
        return self
    }
    
    public var intValue: Int? {
        return nil
    }
    
    
}

struct Pages : Codable {
    let pages: [Page]
    
    enum PagesKey: CodingKey {
        case pages
    }
    
    enum PageTypeKey: CodingKey {
        case type
    }
    
    enum PageTypes: String, Decodable {
        case menu = "menu"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PagesKey.self)
        var pagesArrayForType = try container.nestedUnkeyedContainer(forKey: PagesKey.pages)
        var pages = [Page]()
        
        var pagesArray = pagesArrayForType
        while(!pagesArrayForType.isAtEnd) {
            let page = try pagesArrayForType.nestedContainer(keyedBy: PageTypeKey.self)
            let type = try page.decode(PageTypes.self, forKey: PageTypeKey.type)
            switch type {
            case .menu:
                pages.append(try pagesArray.decode(Menu.self))
            }
        }
        self.pages = pages
    }
}

