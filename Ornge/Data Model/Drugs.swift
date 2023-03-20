//
//  Drugs.swift
//  MedicMind
//
//  Created by Charles Trickey on 2019-06-09.
//  Copyright © 2019 Charles Trickey. All rights reserved.
//

import Foundation
import CoreData
import UIKit

struct Drug : Codable {
    let name : String
    let key : String
    let treatment_data : [TreatmentData]
    let medical_directives : [String]
    let content : [[[String]]]
    let y_site : [String:Bool]
    let drug_tables : [DrugTable]
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case key = "key"
        case treatment_data
        case medical_directives
        case y_site
        case content
        case drug_tables
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.key = try container.decode(String.self, forKey: .key)
        self.treatment_data = try container.decodeIfPresent([TreatmentData].self, forKey: .treatment_data) ?? []
        self.medical_directives = try container.decodeIfPresent([String].self, forKey: .medical_directives) ?? []
        self.y_site = try container.decodeIfPresent([String:Bool].self, forKey: .y_site) ?? [:]
        self.content = try container.decodeIfPresent([[[String]]].self, forKey: .content) ?? [[[]]]
        self.drug_tables = try container.decodeIfPresent([DrugTable].self, forKey: .drug_tables) ?? []
    }
}

struct DrugTable : Codable
{
    var name = ""
    var static_tables : [[String]]
    var diluent_label = ""
    var amount_label = ""
    var concentration_label = ""
    var concentration = 1.0
    var dosing_label = ""
    var unit_weight = ""
    var unit_time = ""
    var dose_titles : [String] = []
    var dose_array : [Double] = []
    var weight_based = false
    
    private enum CodingKeys: CodingKey {
        case name
        case static_tables
        case diluent_label
        case amount_label
        case concentration
        case concentration_label
        case dosing_label
        case dose_titles
        case unit_weight
        case unit_time
        case dose_array
        case weight_based
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.static_tables = try container.decodeIfPresent([[String]].self, forKey: .static_tables) ?? [[]]
        self.diluent_label = try container.decodeIfPresent(String.self, forKey: .diluent_label) ?? ""
        self.amount_label = try container.decodeIfPresent(String.self, forKey: .amount_label) ?? ""
        self.concentration = try container.decodeIfPresent(Double.self, forKey: .concentration) ?? 1.0
        self.concentration_label = try container.decodeIfPresent(String.self, forKey: .concentration_label) ?? ""
        self.dosing_label = try container.decodeIfPresent(String.self, forKey: .dosing_label) ?? ""
        self.unit_weight = try container.decodeIfPresent(String.self, forKey: .unit_weight) ?? "mg"
        self.unit_time = try container.decodeIfPresent(String.self, forKey: .unit_time) ?? "hr"
        self.dose_array = try container.decodeIfPresent([Double].self, forKey: .dose_array) ?? []
        self.dose_titles = try container.decodeIfPresent([String].self, forKey: .dose_titles) ?? []
        self.weight_based = try container.decodeIfPresent(Bool.self, forKey: .weight_based) ?? false
    }
}

class DrugCalculator : Codable {
    
    var drugName : String
    var titleText : String
    var dose : [DrugCalculatorDose]
    var doseUnit : String
    var diluentVolume : Double
    
    private enum CodingKeys: CodingKey {
        case drugName
        case dose
        case doseUnit
        case diluentVolume
        case titleText
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.drugName = try container.decode(String.self, forKey: .drugName)
        self.doseUnit = try container.decode(String.self, forKey: .doseUnit)
        self.diluentVolume = try container.decode(Double.self, forKey: .diluentVolume)
        self.dose = try container.decodeIfPresent([DrugCalculatorDose].self, forKey: .dose)!
        self.titleText = try container.decodeIfPresent(String.self, forKey: .titleText) ?? ""
    }
}

class DrugCalculatorDose : Codable {
    var title : String
    var concentration : Double
    var dosePerKg : Double
    var maxDose : Double
    var notes : String
    
    private enum CodingKeys: CodingKey {
        case title
        case concentration
        case dosePerKg
        case maxDose
        case notes
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.concentration = try container.decode(Double.self, forKey: .concentration)
        self.dosePerKg = try container.decode(Double.self, forKey: .dosePerKg)
        self.maxDose = try container.decodeIfPresent(Double.self, forKey: .maxDose) ?? -1.0
        self.notes = try container.decodeIfPresent(String.self, forKey: .notes) ?? ""
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
