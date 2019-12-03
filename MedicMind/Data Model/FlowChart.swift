//
//  MedicalDirective.swift
//  MedicMind
//
//  Created by Charles Trickey on 2019-06-10.
//  Copyright © 2019 Charles Trickey. All rights reserved.
//

import Foundation
import UIKit

struct FlowCharts : Codable {
    let flowcharts: [FlowChart]
    
    enum FlowChartsKey: CodingKey {
        case flowcharts
    }
    
    enum FlowChartsTypeKey: CodingKey {
        case flowcharts
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: FlowChartsKey.self)
        var pagesArrayForType = try container.nestedUnkeyedContainer(forKey: FlowChartsKey.flowcharts)
        var flowcharts = [FlowChart]()
        
        var pagesArray = pagesArrayForType
        while(!pagesArrayForType.isAtEnd) {
            let _ = try pagesArrayForType.nestedContainer(keyedBy: FlowChartsTypeKey.self)
            flowcharts.append(try pagesArray.decode(FlowChart.self))
        }
        self.flowcharts = flowcharts
    }
}

class FlowChart : Codable {
    var title : String = ""
    var key : String = ""
    var elements : [Element] = []
    var x_space : Float = 25
    var y_space : Float = 25
    
    private enum CodingKeys: String, CodingKey {
        case title
        case key
        case elements
        case x_space
        case y_space
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.key = try container.decode(String.self, forKey: .key)
        self.elements = try container.decode([Element].self, forKey: .elements)
        self.x_space = try container.decodeIfPresent(Float.self, forKey: .x_space) ?? 25
        self.y_space = try container.decodeIfPresent(Float.self, forKey: .y_space) ?? 25
    }
}


class Element : Codable {
    
    enum ElementType : Int
    {
        case square = 0
        case diamond = 1
        case circle = 2
        case exit = 3
        
        static func getTypeFromString(string : String) -> ElementType
        {
            switch string
            {
            case "square":
                return .square
            case "diamond":
                return .diamond
            case "circle":
                return .circle
            case "exit":
                return .exit
            default:
                return .square
            }
        }
    }
    
    static let textCellBuffer : CGFloat = 5

    var x : Int = 0
    var y : Int = 0
    var text : String = ""
    var type : String = ""
    var connections : [Connection] = []
    var contentSize = CGSize()
    var grid : Grid? //target grid for calculating offsets and content sizes
    
    private enum CodingKeys: CodingKey {
        case x
        case y
        case text
        case connections
        case type
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.x = try container.decode(Int.self, forKey: .x)
        self.y = try container.decode(Int.self, forKey: .y)
        self.text = try container.decode(String.self, forKey: .text)
        self.connections = try container.decodeIfPresent([Connection].self, forKey: .connections) ?? []
        self.type = try container.decodeIfPresent(String.self, forKey: .type) ?? "square"
    }
    
    init() {
        
    }
    
    var top : CGPoint {
        get {
            let rect = grid?.getAdjustedRectForElementByIndex(xIndex: x, yIndex: y) ?? CGRect.zero
            return CGPoint(x: rect.origin.x + contentSize.width/2,
                           y: rect.origin.y)
        }
    }
    var bottom : CGPoint  {
        get {
            let rect = grid?.getAdjustedRectForElementByIndex(xIndex: x, yIndex: y) ?? CGRect.zero
            return CGPoint(x: rect.origin.x + contentSize.width/2,
                           y: rect.origin.y + contentSize.height)
        }
    }
    var left : CGPoint {
        get {
            let rect = grid?.getAdjustedRectForElementByIndex(xIndex: x, yIndex: y) ?? CGRect.zero
            return CGPoint(x: rect.origin.x,
                           y: rect.origin.y + contentSize.height/2)
        }
    }
    var right : CGPoint {
        get {
            let rect = grid?.getAdjustedRectForElementByIndex(xIndex: x, yIndex: y) ?? CGRect.zero
            return CGPoint(x: rect.origin.x + contentSize.width,
                           y: rect.origin.y + contentSize.height/2)
        }
    }
}

class Connection : Codable {
    
    var x : Int = 0
    var y : Int = 0
    var text : String = ""
    var entry : String = "top"
    var exit : String = "bottom"
    
    private enum CodingKeys: CodingKey {
        case x
        case y
        case text
        case entry
        case exit
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.x = try container.decode(Int.self, forKey: .x)
        self.y = try container.decode(Int.self, forKey: .y)
        self.text = try container.decodeIfPresent(String.self, forKey: .text) ?? ""
        self.entry = try container.decodeIfPresent(String.self, forKey: .entry) ?? "top"
        self.exit = try container.decodeIfPresent(String.self, forKey: .exit) ?? "bottom"
    }
}
