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
        case content = "content"
        case medicalDirective = "medical_directive"
        case drug_monograph = "drug_monograph"
        case page_target = "page_target"
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
            case .content:
                pages.append(try pagesArray.decode(Content.self))
            case .medicalDirective:
                pages.append(try pagesArray.decode(MedicalDirective.self))
            case .drug_monograph:
                pages.append(try pagesArray.decode(PageLinkTarget.self))
            case .page_target:
                pages.append(try pagesArray.decode(PageLinkTarget.self))

            }
        }
        self.items = pages
        try super.init(from: decoder)
    }
}

class Content : Page {
    var bodyText: String = ""
    
    private enum CodingKeys: String, CodingKey {
        case bodyText
    }
}

struct DrugCard : Codable
{
    var levelOfCare = "pcp"
    var patchPointType = "none"
    var title = ""
    var doseInformation = ""
    var notes = ""
    var targetDrug = ""
    
    private enum CodingKeys: String, CodingKey {
        case levelOfCare
        case patchPointType
        case title
        case doseInformation
        case notes
        case targetDrug
    }
}

struct MedicalDirectives : Codable {
    let directives: [MedicalDirective]
    
    enum DirectivesKey: CodingKey {
        case directives
    }
    
    enum DirectivesTypeKey: CodingKey {
        case directives
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DirectivesKey.self)
        var pagesArrayForType = try container.nestedUnkeyedContainer(forKey: DirectivesKey.directives)
        var directive = [MedicalDirective]()
        
        var pagesArray = pagesArrayForType
        while(!pagesArrayForType.isAtEnd) {
            let _ = try pagesArrayForType.nestedContainer(keyedBy: DirectivesTypeKey.self)
            //switch type {
            // case .drugs:
            directive.append(try pagesArray.decode(MedicalDirective.self))
            //}
        }
        self.directives = directive
    }
}

class MedicalDirective : Page {
    var key : String = ""
    var indications: String = ""
    var contraindications: String = ""
    var drugCards: Array<DrugCard> = []
    var clinical : String = ""
    var treatment: String = ""
    
    private enum CodingKeys: String, CodingKey {
        case key
        case indications
        case contraindications
        case drug_cards
        case clinical
        case treatment
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.key = try container.decode(String.self, forKey: .key)
        self.indications = try container.decode(String.self, forKey: .indications)
        self.contraindications = try container.decode(String.self, forKey: .contraindications)
        self.drugCards = try container.decode([DrugCard].self, forKey: .drug_cards)
        self.clinical = try container.decode(String.self, forKey: .clinical)
        self.treatment = try container.decode(String.self, forKey: .treatment)
        try super.init(from: decoder)
    }
}


class PageLinkTarget : Page {
    var target : String = ""
    var target_type : TargetType = .none
    
    private enum CodingKeys: String, CodingKey {
        case target
        case target_type
    }
    
    enum TargetType
    {
        case none
        case directive
        case drug_monograph
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.target = try container.decode(String.self, forKey: .target)
        
        let str = try container.decode(String.self, forKey: .target_type)
        if(str == "directive")
        {
            target_type = .directive
        } else if str == "drug_monograph"
        {
            target_type = .drug_monograph
        } else
        {
            target_type = .none
        }
        try super.init(from: decoder)
    }
}

class Page : Codable {
    var title: String
    var type: String
    var color: String
    
    private enum CodingKeys: String, CodingKey {
        case title
        case type
        case color
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.type = try container.decode(String.self, forKey: .type)
        self.color = try container.decode(String.self, forKey: .color)
    }
 
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(type, forKey: .type)
        try container.encode(color, forKey: .color)
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
        case content = "content"
        case medicalDirective = "medical_directive"
        case drug_monograph = "drug_monograph"
        case page_target = "page_target"
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
            case .content:
                pages.append(try pagesArray.decode(Content.self))
            case .medicalDirective:
                pages.append(try pagesArray.decode(MedicalDirective.self))
            case .drug_monograph:
                pages.append(try pagesArray.decode(PageLinkTarget.self))
            case .page_target:
                pages.append(try pagesArray.decode(PageLinkTarget.self))
            }
        }
        self.pages = pages
    }
}

struct Drug : Codable {
    let name : String
    let key : String
    let other_names : String
    let classification : String
    let onset : String
    let peak : String
    let half_life : String
    let duration : String
    let indications : [String]
    let contraindications : [String]
    let medical_directives : [String]
    let adult_dose : String
    let pediatric_dose : String
    let neonatal_dose : String
    let special_con : String
    let reconst : [String]
    let compatibility : String
    let stability : String
    let freezing : String
    let patient_safety : String
    let patient_monitoring : [String]
    let adverse : [String]
    let precautions : [String]
    let interactions : String
    let pregnancy : String
    let lactation : String
    let moa : String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case key = "key"
        case other_names = "other_names"
        case classification = "class"
        case onset = "onset"
        case peak = "peak"
        case half_life = "half_life"
        case duration = "duration"
        case indications = "indications"
        case contraindications = "contraindications"
        case medical_directives = "medical_directives"
        case adult_dose = "adult_dose"
        case pediatric_dose = "pediatric_dose"
        case neonatal_dose = "neonatal_dose"
        case special_con = "special_con"
        case reconst = "reconst"
        case compatibility = "compatibility"
        case stability = "stability"
        case freezing = "freezing"
        case patient_safety = "patient_safety"
        case patient_monitoring = "patient_monitoring"
        case adverse = "adverse"
        case precautions = "precautions"
        case interactions = "interactions"
        case pregnancy = "pregnancy"
        case lactation = "lactation"
        case moa = "moa"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.key = try container.decode(String.self, forKey: .key)
        self.other_names = try container.decode(String.self, forKey: .other_names)
        self.classification = try container.decode(String.self, forKey: .classification)
        self.onset = try container.decode(String.self, forKey: .onset)
        self.peak = try container.decode(String.self, forKey: .peak)
        self.half_life = try container.decode(String.self, forKey: .half_life)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.indications = try container.decode([String].self, forKey: .indications)
        self.contraindications = try container.decode([String].self, forKey: .contraindications)
        self.medical_directives = try container.decode([String].self, forKey: .medical_directives)
        self.adult_dose = try container.decode(String.self, forKey: .adult_dose)
        self.pediatric_dose = try container.decode(String.self, forKey: .pediatric_dose)
        self.neonatal_dose = try container.decode(String.self, forKey: .neonatal_dose)
        self.special_con = try container.decode(String.self, forKey: .special_con)
        self.reconst = try container.decode([String].self, forKey: .reconst)
        self.compatibility = try container.decode(String.self, forKey: .compatibility)
        self.stability = try container.decode(String.self, forKey: .stability)
        self.freezing = try container.decode(String.self, forKey: .freezing)
        self.patient_safety = try container.decode(String.self, forKey: .patient_safety)
        self.patient_monitoring = try container.decode([String].self, forKey: .patient_monitoring)
        self.adverse = try container.decode([String].self, forKey: .adverse)
        self.precautions = try container.decode([String].self, forKey: .precautions)
        self.interactions = try container.decode(String.self, forKey: .interactions)
        self.pregnancy = try container.decode(String.self, forKey: .pregnancy)
        self.lactation = try container.decode(String.self, forKey: .lactation)
        self.moa = try container.decode(String.self, forKey: .moa)
    }    
}

struct Drugs : Codable {
    let drugs: [Drug]
    
    enum DrugsKey: CodingKey {
        case drugs
    }
    
    enum DrugTypeKey: CodingKey {
        case drugs
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DrugsKey.self)
        var pagesArrayForType = try container.nestedUnkeyedContainer(forKey: DrugsKey.drugs)
        var drugs = [Drug]()
        
        var pagesArray = pagesArrayForType
        while(!pagesArrayForType.isAtEnd) {
            let _ = try pagesArrayForType.nestedContainer(keyedBy: DrugTypeKey.self)
            //switch type {
           // case .drugs:
                drugs.append(try pagesArray.decode(Drug.self))
            //}
        }
        self.drugs = drugs
    }
}

class DataManager
{
    static let instance = DataManager()
    var menuData : [Page] = []
    var drugData : [Drug] = []
    var directivesData : [MedicalDirective] = []
    var currentPage : Page?
    var loaded = false
    
    private init()
    {
       
    }
    
    func load()
    {
        guard let menus = DataManager.instance.loadMenuJson(filename: "MenuData") ?? nil else { print("could not load MenuData.json"); return }
        guard let drugs = DataManager.instance.loadDrugLibraryJson(filename: "DrugLibrary") ?? nil
            else { print("could not load DrugLibrary.json"); return}
        guard let directives = DataManager.instance.loadMedicalDirectiveLibraryJson(filename: "MedicalDirectives") ?? nil else {print("could not load MedicalDirectives.json"); return}
        menuData = menus
        drugData = drugs
        directivesData = directives
        currentPage = menuData[0] as! Menu
        loaded = true
    }
    
    func saveData()
    {
       
    }
    
    func loadMenuJson(filename fileName: String) ->[Page]?
    {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json")
        {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                do
                {
                    let jsonData = try decoder.decode(Pages.self, from: data)
                    for result in jsonData.pages
                    {
                        if result is Content {
                            print((result as! Content).bodyText)
                        }
                        else if result is Menu {
                            print((result as! Menu).items)
                        }
                        return jsonData.pages
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
    
    func loadMedicalDirectiveLibraryJson(filename fileName: String) ->[MedicalDirective]?
    {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json")
        {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                do
                {
                    let jsonData = try decoder.decode(MedicalDirectives.self, from: data)
                    for _ in jsonData.directives
                    {
                        return jsonData.directives
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
    
    func drugByKey(key: String) -> Drug?
    {
        for drug in drugData
        {
            if(drug.key == key)
            {
                return drug
            }
        }
        
        print("No drug found with key")
        return nil
    }
    
    func directiveByKey(key: String) -> MedicalDirective?
    {
        for directive in directivesData
        {
            if(directive.key == key)
            {
                return directive
            }
        }
        print("No medical directive found with key")
        return nil
    }
}
