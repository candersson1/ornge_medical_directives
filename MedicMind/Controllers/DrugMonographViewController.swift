//
//  DrugMonographViewController.swift
//  MedicMind
//
//  Created by Charles Trickey on 2019-05-15.
//  Copyright © 2019 Charles Trickey. All rights reserved.
//

import Foundation
import UIKit

class PageTargetButton : UIButton
{
    var key: String = ""
}

class DrugMonographViewController : UIViewController
{
    var drugData : Drug?
    @IBOutlet weak var scrollView: UIScrollView!
    
    @objc func buttonAction(sender : PageTargetButton)
    {
        if(DataManager.instance.directiveByKey(key: sender.key) == nil)
        {
            print("Could not find directive with key")
            return
        }
        let navController = UIApplication.shared.windows[0].rootViewController as? UINavigationController
        let storyboard = navController?.storyboard
        
        let viewController = storyboard!.instantiateViewController(withIdentifier: "MedicalDirectiveViewController") as! MedicalDirectiveViewController
        
        viewController.currentDirective = DataManager.instance.directiveByKey(key: sender.key)
        navController!.pushViewController(viewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(drugData == nil)
        {
            return
        }
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Attaching the content's edges to the scroll view's edges
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            // Satisfying size constraints
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            ])
        
        //let titleLabel = headingLabelWithString(string: drugData!.name)
        //stackView.addArrangedSubview(titleLabel)
        
        var label = headingLabelWithString(string: "Other Names:")
        stackView.addArrangedSubview(label)
        
        label = bodyLabelWithString(string: drugData!.other_names)
        stackView.addArrangedSubview(label)
        
        label = headingLabelWithString(string: "Pharmacokinetics:")
        stackView.addArrangedSubview(label)
        
        let horizonalstackView = UIStackView()
        horizonalstackView.axis = .horizontal
        horizonalstackView.alignment = .fill
        horizonalstackView.distribution = .fill
        horizonalstackView.spacing = 0
        
        stackView.addArrangedSubview(horizonalstackView)
        horizonalstackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Attaching the content's edges to the scroll view's edges
            horizonalstackView.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            horizonalstackView.trailingAnchor.constraint(equalTo: label.trailingAnchor),
            horizonalstackView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            //horizonalstackView.bottomAnchor.constraint(equalTo: label.bottomAnchor),
            
            // Satisfying size constraints
            horizonalstackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
           // horizonalstackView.heightAnchor.constraint(equalTo: 50)
            ])
        
        label = OutlinedLabel()
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        label.text = " Onset:\n " + drugData!.onset
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        horizonalstackView.addArrangedSubview(label)
        
        label = OutlinedLabel()
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        label.text = " Peak:\n " + drugData!.peak
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        horizonalstackView.addArrangedSubview(label)
        
        label = OutlinedLabel()
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        label.text = " Half Life:\n " + drugData!.half_life
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        horizonalstackView.addArrangedSubview(label)
        
        label = OutlinedLabel()
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        label.text = " Duration:\n " + drugData!.duration
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        horizonalstackView.addArrangedSubview(label)
        
        label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        label.text = "Indications:"
        label.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(label)

        var str = bulletedStringFromStringArray(strArray: drugData!.indications)
        label = bodyLabelWithString(string: str, indent: 8)
        stackView.addArrangedSubview(label)
        
        label = headingLabelWithString(string: "Contraindications:")
        stackView.addArrangedSubview(label)
       
        str = bulletedStringFromStringArray(strArray: drugData!.contraindications)
        label = bodyLabelWithString(string: str, indent: 8)
        stackView.addArrangedSubview(label)
        
        label = headingLabelWithString(string: "Dosing:")
        stackView.addArrangedSubview(label)
        
        var hStackView = horizontalStackViewWithConstraints(parentView: stackView, belowView: label)
        hStackView.distribution = .fillProportionally
        label = headingLabelWithString(string: " Adult: ", outlined: true)
        
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        hStackView.addArrangedSubview(label)
        label = bodyLabelWithString(string: drugData!.adult_dose, outlined: true)
        hStackView.addArrangedSubview(label)
        
        var secondHStackView = horizontalStackViewWithConstraints(parentView: stackView, belowView: hStackView, constant: 0)
        secondHStackView.distribution = .fillProportionally
        label = headingLabelWithString(string: " Pediatric: ", outlined: true)
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        secondHStackView.addArrangedSubview(label)
        
        label = bodyLabelWithString(string: drugData!.pediatric_dose, outlined: true)
        secondHStackView.addArrangedSubview(label)
        
        hStackView = horizontalStackViewWithConstraints(parentView: stackView, belowView: secondHStackView, constant: 0)
        hStackView.distribution = .fillProportionally
        label = headingLabelWithString(string: " Neonatal: ", outlined: true)
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true

        hStackView.addArrangedSubview(label)
        label = bodyLabelWithString(string: drugData!.neonatal_dose, outlined: true)
        hStackView.addArrangedSubview(label)
        
        secondHStackView = horizontalStackViewWithConstraints(parentView: stackView, belowView: hStackView, constant: 0)
        secondHStackView.distribution = .fillProportionally
        label = headingLabelWithString(string: " Special Considerations: ", outlined: true)
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true

        secondHStackView.addArrangedSubview(label)
        label = bodyLabelWithString(string: drugData!.special_con, outlined: true)
        secondHStackView.addArrangedSubview(label)
        
        label = headingLabelWithString(string: "Ornge Medical Directives:")
        stackView.addArrangedSubview(label)
        
        var previousView : UIView = label
        for str in drugData!.medical_directives
        {
            hStackView = horizontalStackViewWithConstraints(parentView: stackView, belowView: previousView)
            hStackView.distribution = .fillProportionally
            stackView.addArrangedSubview(hStackView)
            
            let directive = DataManager.instance.directiveByKey(key: str)
            
            if(directive == nil)
            {
                label = bodyLabelWithString(string: str)
                hStackView.addArrangedSubview(label)
            }
            else
            {
                label = bodyLabelWithString(string: directive!.title)
                hStackView.addArrangedSubview(label)
                let button = PageTargetButton(type: .detailDisclosure)
                button.key = str
                button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                hStackView.addArrangedSubview(button)
            }
            previousView = hStackView
        }
        
        label = headingLabelWithString(string: "Reconstitution and Administration:")
        stackView.addArrangedSubview(label)
        
        str = bulletedStringFromStringArray(strArray: drugData!.reconst)
        label = bodyLabelWithString(string: str, indent: 8)
        stackView.addArrangedSubview(label)
        
        label = headingLabelWithString(string: "Compatibility")
        stackView.addArrangedSubview(label)
        
        label = bodyLabelWithString(string: drugData!.compatibility)
        stackView.addArrangedSubview(label)
        
        label = headingLabelWithString(string: "Stability and Storage")
        stackView.addArrangedSubview(label)
        
        label = bodyLabelWithString(string: drugData!.stability)
        stackView.addArrangedSubview(label)
        
        label = headingLabelWithString(string: "Freezing")
        stackView.addArrangedSubview(label)
        
        label = bodyLabelWithString(string: drugData!.freezing)
        stackView.addArrangedSubview(label)
        
        label = headingLabelWithString(string: "Patient Safety:")
        stackView.addArrangedSubview(label)
        
        label = bodyLabelWithString(string: drugData!.patient_safety)
        stackView.addArrangedSubview(label)
        
        label = headingLabelWithString(string: "Patient Monitoring:")
        stackView.addArrangedSubview(label)
        
        str = bulletedStringFromStringArray(strArray: drugData!.patient_monitoring)
        label = bodyLabelWithString(string: str, indent: 8)
        stackView.addArrangedSubview(label)
        
        label = headingLabelWithString(string: "Complications and Adverse Effects:")
        stackView.addArrangedSubview(label)
        
        str = bulletedStringFromStringArray(strArray: drugData!.adverse)
        label = bodyLabelWithString(string: str, indent: 8)
        stackView.addArrangedSubview(label)
        
        label = headingLabelWithString(string: "Precautions:")
        stackView.addArrangedSubview(label)
        
        str = bulletedStringFromStringArray(strArray: drugData!.precautions)
        label = bodyLabelWithString(string: str)
        stackView.addArrangedSubview(label)
        
        label = headingLabelWithString(string: "Pregnancy and Lactation:")
        stackView.addArrangedSubview(label)
        
        hStackView = horizontalStackViewWithConstraints(parentView: stackView, belowView: label)
        hStackView.distribution = .fillProportionally
        label = headingLabelWithString(string: "Pregnancy: ", outlined: true)
        
        label.widthAnchor.constraint(equalToConstant: 120).isActive = true
        hStackView.addArrangedSubview(label)
        label = bodyLabelWithString(string: drugData!.pregnancy, outlined: true)
        hStackView.addArrangedSubview(label)
        
        secondHStackView = horizontalStackViewWithConstraints(parentView: stackView, belowView: hStackView, constant: 0)
        secondHStackView.distribution = .fillProportionally
        label = headingLabelWithString(string: "Lactation: ", outlined: true)
        label.widthAnchor.constraint(equalToConstant: 120).isActive = true
        secondHStackView.addArrangedSubview(label)
        label = bodyLabelWithString(string: drugData!.lactation, outlined: true)
        secondHStackView.addArrangedSubview(label)
        
        label = headingLabelWithString(string: "Pharmacologic Mechanism:")
        stackView.addArrangedSubview(label)
        
        label = bodyLabelWithString(string: drugData!.moa)
        stackView.addArrangedSubview(label)
    }
    
    func bulletedStringFromStringArray(strArray : [String]) -> String
    {
        var str  = ""
        for string in strArray
        {
            str = str + "• " + string + "\n"
        }
        return str
    }
    
    func headingLabelWithString(string : String, outlined : Bool = false) -> UILabel
    {
        var label = UILabel()
        if(outlined == true)
        {
            label = OutlinedLabel()
        }
        
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        label.text = string
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func bodyLabelWithString(string : String, indent : CGFloat = 0, outlined : Bool = false) -> UILabel
    {
        var label = UILabel()
        
        if(outlined == true)
        {
            label = OutlinedLabel()
        }
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.firstLineHeadIndent = 0
        paragraph.headIndent = indent
        
        label.attributedText = NSAttributedString(string: string, attributes: [NSAttributedString.Key.paragraphStyle: paragraph])
        return label
    }
    
    func horizontalStackViewWithConstraints(parentView : UIStackView, belowView : UIView, constant : CGFloat = 10) -> UIStackView
    {
        let horizonalstackView = UIStackView()
        horizonalstackView.axis = .horizontal
        horizonalstackView.alignment = .fill
        horizonalstackView.distribution = .fill
        horizonalstackView.spacing = 0
        parentView.addArrangedSubview(horizonalstackView)
        horizonalstackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Attaching the content's edges to the scroll view's edges
            horizonalstackView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            horizonalstackView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            horizonalstackView.topAnchor.constraint(equalTo: belowView.bottomAnchor, constant: constant),
            //horizonalstackView.bottomAnchor.constraint(equalTo: label.bottomAnchor),
            
            // Satisfying size constraints
            horizonalstackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            // horizonalstackView.heightAnchor.constraint(equalTo: 50)
            ])
        
        return horizonalstackView
    }
}

class OutlinedLabel : UILabel
{
    var leftInset : CGFloat = 10
    var rightInset : CGFloat = 10
    var topInset : CGFloat = 4
    var bottomInset : CGFloat = 4
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        let color:UIColor = UIColor.black
        
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        let drect = CGRect(x: 0, y: 0, width: rect.maxX, height: rect.maxY)
        let bpath:UIBezierPath = UIBezierPath(rect: drect)
        
        color.set()
        bpath.stroke()
        //super.draw(insetRect)
        super.drawText(in: drect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}
