//
//  DataManager.swift
//  MedicMind
//
//  Created by Charles Trickey on 2019-05-10.
//  Copyright © 2019 Charles Trickey. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import SwiftRichString


let normalStyle = Style {
    $0.font = UIFont.systemFont(ofSize: CGFloat(DataManager.instance.fontSize))
    $0.paragraphSpacingAfter = 15
    $0.alignment = .left
    $0.color = UIColor.label
}

let linkStyle = Style {
    $0.font = UIFont.boldSystemFont(ofSize: CGFloat(DataManager.instance.fontSize))
    $0.color = UIColor.link
}

let titleStyle = Style {
    $0.font = UIFont.boldSystemFont(ofSize: CGFloat(DataManager.instance.fontSize) + 3)
    $0.color = UIColor.label
}
let boldStyle = Style {
    $0.font = UIFont.boldSystemFont(ofSize: CGFloat(DataManager.instance.fontSize))
    $0.color = UIColor.label
}

let italicStyle = Style {
    $0.font = UIFont.italicSystemFont(ofSize: CGFloat(DataManager.instance.fontSize))
}

let boldItalicStyle = Style {
    $0.font = UIFont.boldSystemFont(ofSize: CGFloat(DataManager.instance.fontSize))
    $0.traitVariants = .italic
}

let underlineStyle = normalStyle.byAdding{
    $0.underline = (.single, UIColor.black)
}

let redStyle = Style {
    $0.color = UIColor.red
}

let orangeBackgroundStyle = Style {
    $0.backColor = "#ffc001"
}

let leftJustifiedStyle = Style {
    $0.alignment = .left
    $0.paragraphSpacingAfter = 15
}

let centerJustifiedStyle = Style {
    $0.alignment = .center
    $0.paragraphSpacingAfter = 15
}

let tab1 = Style {
    $0.alignment = .left
    $0.firstLineHeadIndent = 10
    $0.headIndent = 20
    $0.paragraphSpacingAfter = 5
}

let tab2 = Style {
    $0.alignment = .left
    $0.firstLineHeadIndent = 30
    $0.headIndent = 40
    $0.paragraphSpacingAfter = 5

}

let tab3 = Style {
    $0.alignment = .left
    $0.firstLineHeadIndent = 50
    $0.headIndent = 60
    $0.paragraphSpacingAfter = 5
}

let link = Style {
    $0.color = UIColor.systemBlue
    $0.linkURL = URLRepresentable.tagAttribute("href")
}

let styleGroup = StyleGroup(base: normalStyle, ["title" : titleStyle, "b" : boldStyle, "i" : italicStyle, "u" : underlineStyle, "red" : redStyle, "center" : centerJustifiedStyle, "left" : leftJustifiedStyle, "tab1" : tab1, "tab2" : tab2, "tab3" : tab3, "a" : link, "orange" : orangeBackgroundStyle, "bi" : boldItalicStyle])


class DataManager
{
    static let instance = DataManager()
    var menuData : [MenuItem] = []
    var pageData : [Document] = []
    var drugData : [Drug] = []
    var flowchartData : [FlowChart] = []
    var loaded = false
    
    var fontSize : Float
    
    
    var showLevelOfCare = LevelOfCare.All
    
    var waiverComplete = false
    
    var lastSetWeight : Double = 80.0
    
    private init()
    {
        let defaults = UserDefaults.standard
        fontSize = (defaults.float(forKey: "font_size") != 0) ? defaults.float(forKey: "font_size") : 13.0
    }
    
    func load()
    {
        guard let menus = DataManager.instance.loadMenuJson(filename: "MenuData") ?? nil else { print("loadMenuJson() failed for MenuData.json"); return }
        guard let drugs = DataManager.instance.loadDrugLibraryJson(filename: "DrugLibrary") ?? nil
            else { print("loadDrugLibraryJson() for DrugLibrary.json"); return}
        guard let flowcharts = DataManager.instance.loadFlowChartsLibraryJson(filename: "FlowChartLibrary") ?? nil else {print("loadFlowChartsLibraryJson() failed for FlowChartLibrary.json"); return}
        guard let pages = DataManager.instance.loadPagesLibraryJson(filename: "DocumentsData") ?? nil else {print("loadPagesLibraryJson() failed for DocumentsData.json"); return}
        menuData = menus
        drugData = drugs
        flowchartData = flowcharts
        pageData = pages
        loaded = true
    }
    
    func saveData()
    {
       
    }
    
    func loadMenuJson(filename fileName: String) ->[MenuItem]?
    {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json")
        {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                do
                {
                    let jsonData = try decoder.decode(Menus.self, from: data)
                    for result in jsonData.menus
                    {
                        if result is Menu {
                            print((result as! Menu).items)
                        }
                        return jsonData.menus
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
                
                return nil
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    
    func loadPagesLibraryJson(filename fileName: String) ->[Document]?
    {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json")
        {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                do
                {
                    let jsonData = try decoder.decode(Documents.self, from: data)
                    return jsonData.documents
                    
                }
                catch {
                    print(error.localizedDescription)
                }
                
                return nil
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    
    func loadDrugLibraryJson(filename fileName: String) ->[Drug]?
    {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json")
        {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                do
                {
                    let jsonData = try decoder.decode(Drugs.self, from: data)
                    for _ in jsonData.drugs
                    {
                        return jsonData.drugs
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
                
                return nil
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    
    func loadFlowChartsLibraryJson(filename fileName: String) ->[FlowChart]?
    {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json")
        {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                do
                {
                    let jsonData = try decoder.decode(FlowCharts.self, from: data)
                    for _ in jsonData.flowcharts
                    {
                        return jsonData.flowcharts
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
                
                return nil
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    
    func documentByKey(key : String) -> Document?
    {
        for document in pageData {
            if(document.key == key) {
                return document
            }
        }
        print("Could not find document for key")
        return nil
    }
    
    /// everything below here is deprecated and will be phased out
    
    func drugByKey(key: String) -> Drug?
    {
        for drug in drugData
        {
            if(drug.key == key)
            {
                return drug
            }
        }
        return nil
    }
    
    func treatmentDataByKey(in drug: Drug, key: String) -> TreatmentData?
    {
        for tx in drug.treatment_data
        {
            if(tx.key == key)
            {
                return tx
            }
        }
        return nil
    }

    /*func pageByKey(key: String) -> Page?
    {
        for page in pageData
        {
            if(page.key == key)
            {
                return nil
            }
        }
        return nil
    }*/
    
    
    
    func flowchartByKey(key: String) -> FlowChart?
    {
        for flowchart in flowchartData
        {
            if(flowchart.key == key)
            {
                return flowchart
            }
        }
        return nil
    }
}
