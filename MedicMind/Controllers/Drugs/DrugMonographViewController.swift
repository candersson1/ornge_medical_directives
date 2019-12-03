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
    let stackView = UIStackView()
    @IBOutlet weak var scrollView: UIScrollView!
    
    @objc func buttonAction(sender : PageTargetButton)
    {
        if(DataManager.instance.pageByKey(key: sender.key) == nil)
        {
            print("Could not find directive with key")
            return
        }
        let navController = UIApplication.shared.windows[0].rootViewController as? UINavigationController
        let storyboard = navController?.storyboard
        
        let viewController = storyboard!.instantiateViewController(withIdentifier: "MedicalDirectiveViewController") as! MedicalDirectiveViewController
        
        viewController.currentDirective = DataManager.instance.pageByKey(key: sender.key) as? MedicalDirective
        navController!.pushViewController(viewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(drugData == nil)
        {
            return
        }
        
        //let font = UIFont(name: DataManager.instance.fontName, size: CGFloat(DataManager.instance.fontSize))
        //let boldfont = UIFont(name: DataManager.instance.boldFontName, size: CGFloat(DataManager.instance.fontSize))
        
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
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: DataManager.instance.boldFontName, size: CGFloat(20.0))
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textAlignment = .center
        titleLabel.text = drugData?.name
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        //titleLabel.textColor = accentColor
        stackView.addArrangedSubview(titleLabel)
        
        //let titleLabel = headingLabelWithString(string: drugData!.name)
        //stackView.addArrangedSubview(titleLabel)
        
        if(drugData!.drug_tables.count > 0)
        {
            for drugTable in drugData!.drug_tables
            {
                let mixingTable = MixingCalculatorView()
                mixingTable.parentView = scrollView
                mixingTable.setTapGestureRecognizer()
                
                mixingTable.min = drugTable.minDose
                mixingTable.max = drugTable.maxDose
                mixingTable.concentration = drugTable.concentration
                mixingTable.inc = drugTable.doseIncrement
                mixingTable.doseTimeUnit = drugTable.unit_time
                mixingTable.weightBased = drugTable.weight_based
                if(drugTable.weight_based == true)
                {
                    mixingTable.unitsLabel.text = drugTable.unit_weight + "/kg/" + drugTable.unit_time
                } else {
                    mixingTable.unitsLabel.text = drugTable.unit_weight + "/" + drugTable.unit_time
                    mixingTable.weightTextField.isEnabled = false
                    mixingTable.weightTextField.text = "n/a"
                }
                mixingTable.drugNameLabel.text = "Drug: " + drugTable.name
                mixingTable.drugDiluentLabel.text = "Diluent: \(drugTable.diluent_label)"
                mixingTable.drugAmountLabel.text = "Drug Amount: \(drugTable.amount_label)"
                mixingTable.drugConcentrationLabel.text = "Concentration:\n" + drugTable.concentration_label
                mixingTable.drugDosingLabel.text = drugTable.dosing_label
                stackView.addArrangedSubview(mixingTable)
                mixingTable.updateDoseFields()
            }
        }
        
        
        let horizonalstackView = UIStackView()
        horizonalstackView.axis = .horizontal
        horizonalstackView.alignment = .fill
        horizonalstackView.distribution = .fill
        horizonalstackView.spacing = 0
        
        stackView.addArrangedSubview(horizonalstackView)
        horizonalstackView.translatesAutoresizingMaskIntoConstraints = false
        
       /* NSLayoutConstraint.activate([
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
        label.font = font
        label.text = " Onset:\n " + drugData!.onset
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        horizonalstackView.addArrangedSubview(label)
        
        label = OutlinedLabel()
        label.font = font
        label.text = " Peak:\n " + drugData!.peak
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        horizonalstackView.addArrangedSubview(label)
        
        label = OutlinedLabel()
        label.font = font
        label.text = " Half Life:\n " + drugData!.half_life
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        horizonalstackView.addArrangedSubview(label)
        
        label = OutlinedLabel()
        label.font = font
        label.text = " Duration:\n " + drugData!.duration
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        horizonalstackView.addArrangedSubview(label)
        */
        //for i in 0 ..< drugData!.content.content.size
        
        var label = UILabel()
        
        //MARK: DoseRoute
        if(drugData!.content.count > 0)
        {
            var stackCollection : [UIStackView] = []
        
            for i in 0 ..< drugData!.content[0].count
            {
                let doseHStack = UIStackView()
                doseHStack.axis = .horizontal
                doseHStack.alignment = .fill
                doseHStack.distribution = .fillEqually
                doseHStack.spacing = 0
                doseHStack.translatesAutoresizingMaskIntoConstraints = false
                
                if( i % 2 == 1)
                {
                    doseHStack.addBackground(color: UIColor.tertiarySystemBackground)
                }
                //treatmentStack.addArrangedSubview(doseHStack)
                stackCollection.append(doseHStack)
            }
        }
            
            /*for i in 0 ..< drugData!.content.count
            {
                let doseArray = doseRoute[i]
                var labelArray : [UILabel] = []
                
                if( doseArray[0] != "nil" )
                {
                    for j in 0 ..< doseArray.count
                    {
                        if( j >= stackCollection.count )
                        {
                            print("Missmatch between doseArray and stackCollection, ensure that all dose_route arrays have equal number of values")
                            break
                        }
                        if(doseArray[j] != "nil")
                        {
                        let labelView = UIView()
                        labelView.layer.borderWidth = 0.5
                        labelView.layer.borderColor = UIColor.systemGray3.cgColor
                        
                        let doseLabel = UILabel()
                        doseLabel.font = font
                        doseLabel.lineBreakMode = .byWordWrapping
                        doseLabel.numberOfLines = 0
                        doseLabel.attributedText = doseArray[j].set(style: styleGroup)
                        doseLabel.translatesAutoresizingMaskIntoConstraints = false
                        
                        labelArray.append(doseLabel)
                        labelView.addSubview(doseLabel)
                        
                        NSLayoutConstraint.activate([
                            doseLabel.leadingAnchor.constraint(equalTo: labelView.leadingAnchor, constant: 5),
                            doseLabel.trailingAnchor.constraint(equalTo: labelView.trailingAnchor, constant: -5),
                            doseLabel.topAnchor.constraint(equalTo: labelView.topAnchor, constant: 5),
                            doseLabel.bottomAnchor.constraint(equalTo: labelView.bottomAnchor, constant: -5)
                        ])
                        
                        stackCollection[j].addArrangedSubview(labelView)
                        }
                    }
                }
            }
        }*/
        
        /*for content in drugData!.content
        {
            label = headingLabelWithString(string: content[0])
            stackView.addArrangedSubview(label)

            for i in 1 ..< content.count {
                label = bodyLabelWithString(string: "• " + content[i], indent: 16)
                stackView.addArrangedSubview(label)
            }
            
        }*/
        
        if( drugData!.medical_directives.count > 0)
        {
            var hStackView = UIStackView()
            hStackView.axis = .horizontal
            label = headingLabelWithString(string: "Ornge Medical Directives:")
            stackView.addArrangedSubview(label)
            
            var previousView : UIView = label
            for str in drugData!.medical_directives
            {
                hStackView = horizontalStackViewWithConstraints(parentView: stackView, belowView: previousView)
                hStackView.distribution = .fillProportionally
                stackView.addArrangedSubview(hStackView)
                
                let directive = DataManager.instance.pageByKey(key: str)

                if(directive != nil)
                {
                    let button = PageTargetButton(type: .custom)
                    button.key = str
                    button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                    button.contentHorizontalAlignment = .left
                    
                    let attributeString = ("• " + directive!.title).htmlAttributed(family: DataManager.instance.fontName, size: CGFloat(DataManager.instance.fontSize-3))
                    let mutableBodyString = NSMutableAttributedString()
                    mutableBodyString.append(attributeString!)
                    let style = NSMutableParagraphStyle()
                    style.headIndent = 30.0
                    style.firstLineHeadIndent = 16.0
                    mutableBodyString.addAttributes([NSAttributedString.Key.paragraphStyle : style], range: NSMakeRange(0, mutableBodyString.length))
                    mutableBodyString.addAttribute(NSAttributedString.Key.foregroundColor , value: UIColor.link, range: NSMakeRange(0, mutableBodyString.length))
                    
                    button.setAttributedTitle(mutableBodyString, for: .normal)
                    button.setTitleColor(UIColor.link, for: .normal)
                    button.titleLabel?.numberOfLines = 0
                    button.titleLabel?.lineBreakMode = .byWordWrapping
                    
                    hStackView.addArrangedSubview(button)
                    
                    NSLayoutConstraint.activate([
                     button.widthAnchor.constraint(equalTo: scrollView.widthAnchor)])
                }
                previousView = hStackView
            }
        }
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
        
        label.font = UIFont(name: DataManager.instance.boldFontName, size: CGFloat(DataManager.instance.fontSize))
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
        label.font = UIFont(name: DataManager.instance.fontName, size: CGFloat(DataManager.instance.fontSize))
        
        label.textColor = UIColor.label
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.firstLineHeadIndent = indent
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
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
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
