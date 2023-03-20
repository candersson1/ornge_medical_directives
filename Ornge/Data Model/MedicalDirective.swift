//
//  MedicalDirective.swift
//  MedicMind
//
//  Created by Charles Trickey on 2019-06-10.
//  Copyright © 2019 Charles Trickey. All rights reserved.
//

import Foundation


enum LevelOfCare : Int
{
    case PCP = 0
    case ACPL = 1
    case ACP = 2
    case CCP = 3
    case PCCP = 4
    case All = 5
    
    static func getTypeFromString(string : String) -> LevelOfCare
    {
        switch string
        {
        case "pcp":
            return .PCP
        case "acpl":
            return .ACPL
        case "acp":
            return .ACP
        case "ccp":
            return .CCP
        case "pccp":
            return .PCCP
        default:
            return .All
        }
    }
}

struct TreatmentCard : Codable
{
    var section = ""
    var title = ""
    var dose_route : [[String]] = []
    var notes = ""
    var drugKey = ""
    var treatmentKey = ""
    var calculator : [DrugTable]
    var loc = [["", ""]]

    private enum CodingKeys: String, CodingKey {
        case section
        case title
        case dose_route
        case notes
        case drugKey
        case treatmentKey
        case calculator
        case loc
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.section = try container.decodeIfPresent(String.self, forKey: .section) ?? ""
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        self.dose_route = try container.decodeIfPresent([[String]].self, forKey: .dose_route) ?? []
        self.notes = try container.decodeIfPresent(String.self, forKey: .notes) ?? ""
        self.drugKey = try container.decodeIfPresent(String.self, forKey: .drugKey) ?? ""
        self.treatmentKey = try container.decodeIfPresent(String.self, forKey: .treatmentKey) ?? ""
        self.calculator = try container.decodeIfPresent([DrugTable].self, forKey: .calculator) ?? []
        self.loc = try container.decodeIfPresent([[String]].self, forKey: .loc) ?? [["nil","nil"]]

    }
}


class MedicalDirective : Document {
    var sectionLabel : String = ""
    var indications: String = ""
    var contraindications: String = ""
    var drugCards: Array<TreatmentCard> = []
    var clinical : String = ""
    var treatment: String = ""
    var flowchartkeys : [[String]] = []
    
    private enum CodingKeys: String, CodingKey {
        case key
        case section_label
        case indications
        case contraindications
        case drug_cards
        case clinical
        case treatment
        case flowchartkeys
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sectionLabel = try container.decodeIfPresent(String.self, forKey: .section_label) ?? ""
        self.indications = try container.decodeIfPresent(String.self, forKey: .indications) ?? ""
        self.treatment = try container.decodeIfPresent(String.self, forKey: .treatment) ?? ""
        self.contraindications = try container.decodeIfPresent(String.self, forKey: .contraindications) ?? ""
        self.drugCards = try container.decodeIfPresent([TreatmentCard].self, forKey: .drug_cards) ?? []
        self.clinical = try container.decodeIfPresent(String.self, forKey: .clinical) ?? ""
        self.treatment = try container.decodeIfPresent(String.self, forKey: .treatment) ?? ""
        self.flowchartkeys = try container.decodeIfPresent([[String]].self, forKey: .flowchartkeys) ?? []
        try super.init(from: decoder)
    }
}

struct TreatmentData : Codable {
    var key = ""
    var dose_route : [[String]] = []
    var loc = [["", ""]]

    private enum CodingKeys: String, CodingKey {
        case key
        case dose_route
        case loc
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.key = try container.decode(String.self, forKey: .key)
        self.dose_route = try container.decodeIfPresent([[String]].self, forKey: .dose_route) ?? []
        self.loc = try container.decodeIfPresent([[String]].self, forKey: .loc) ?? [["pcp","none"]]
    }
}


