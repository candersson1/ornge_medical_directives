//
//  MedicalDirectiveView.swift
//  Medic's Little Helper
//
//  Created by Charles Trickey on 2019-05-07.
//  Copyright © 2019 Charles Trickey. All rights reserved.
//

import Foundation
import UIKit

let directiveHeight = 242
let directiveWidth = 426

class MedicalDirectiveView : UIView
{
    @IBOutlet var contentView: MedicalDirectiveView!
    @IBOutlet weak var treatmentNameOutlet: UILabel!
    @IBOutlet weak var treatmentDoseOutlet: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var drugButton: UIButton!
    
    var drugKey : String = ""
    
    @IBAction func drugLinkButton(_ sender: Any) {
        print("Link to drug monograph for medication")
        let navController = UIApplication.shared.windows[0].rootViewController as? UINavigationController
        let storyboard = navController?.storyboard
        
        let viewController = storyboard!.instantiateViewController(withIdentifier: "DrugMonographViewController") as! DrugMonographViewController
        
        viewController.drugData = DataManager.instance.drugByKey(key: drugKey)
        navController!.pushViewController(viewController, animated: true)
        
    }
    
    @IBOutlet weak var levelOfCareButton: UIButton!
    @IBOutlet weak var patchButton: UIButton!
    var patchLabel : UILabel?
    var LOCLabel : UILabel?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        // standard initialization logic
        let nib = UINib(nibName: "MedicalDirectiveView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.translatesAutoresizingMaskIntoConstraints = true
        contentView.frame = bounds
        addSubview(contentView)
        

        var t = CGAffineTransform.identity
        t = t.rotated(by: -.pi / 2)
        t = t.translatedBy(x: -patchButton.frame.size.height*0.38, y: -patchButton.frame.size.width*1.62)
        patchLabel = UILabel(frame: CGRect(x: 0, y: 0, width: patchButton.frame.size.height, height: patchButton.frame.size.width))
        patchLabel!.transform = t
        patchLabel!.font = UIFont(name: "HelveticaNeue", size: 11)
        patchLabel!.text = "No patch required"
        patchLabel!.textAlignment = .center
        patchButton.addSubview(patchLabel!)
        
        t = CGAffineTransform.identity
        t = t.rotated(by: -.pi / 2)
        t = t.translatedBy(x: -patchButton.frame.size.height*0.38, y: -patchButton.frame.size.width*1.62)
        LOCLabel = UILabel(frame: CGRect(x: 0, y: 0, width: levelOfCareButton.frame.size.height, height: levelOfCareButton.frame.size.width))
        LOCLabel!.transform = t
        LOCLabel!.font = UIFont(name: "HelveticaNeue", size: 11)
        LOCLabel!.textAlignment = .center
        LOCLabel!.text = "PCP(f)"
        levelOfCareButton.addSubview(LOCLabel!)
    }
}
