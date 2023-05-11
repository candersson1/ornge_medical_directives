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
    
    @objc func directiveButtonAction(sender : PageTargetButton)
    {
        if(DataManager.instance.documentByKey(key: sender.key) == nil)
        {
            print("Could not find directive with key")
            return
        }
        let navController = UIApplication.shared.windows[0].rootViewController as? UINavigationController
        let storyboard = navController?.storyboard
        
        if let directive = DataManager.instance.documentByKey(key: sender.key) as? MedicalDirective {
            let viewController = storyboard!.instantiateViewController(withIdentifier: "MedicalDirectiveTabViewController") as! MedicalDirectiveTabViewController
            viewController.directive = directive
            viewController.loadSubviews()
            navController!.pushViewController(viewController, animated: true)
        } else {
            let viewController = storyboard!.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            viewController.target = sender.key
            
            navController!.pushViewController(viewController, animated: true)
        }
    }
    
    static func loadViewControllerWithKey(key : String)
    {
        let navController = UIApplication.shared.windows[0].rootViewController as? UINavigationController
        let storyboard = navController?.storyboard

        let drugData = DataManager.instance.drugByKey(key: key)
        if(drugData == nil)
        {
            return
        }
        let viewController = storyboard!.instantiateViewController(withIdentifier: "DrugTabViewController") as! DrugTabViewController
        viewController.drugData = drugData
        viewController.loadSubviews()
        navController!.pushViewController(viewController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(drugData == nil) {
            return
        }
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0
        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Attaching the content's edges to the scroll view's edges
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            // Satisfying size constraints
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
                
        let horizonalstackView = UIStackView()
        horizonalstackView.axis = .horizontal
        horizonalstackView.alignment = .fill
        horizonalstackView.distribution = .fill
        horizonalstackView.spacing = 0
        
        stackView.addArrangedSubview(horizonalstackView)
        horizonalstackView.translatesAutoresizingMaskIntoConstraints = false
        
        let font = UIFont.systemFont(ofSize: CGFloat(DataManager.instance.fontSize))

        //MARK: DoseRoute
        if(drugData!.content.count > 0)
        {
            var stackCollection : [UIStackView] = []
        
            for i in 0 ..< drugData!.content.count
            {
                let contentVStack = UIStackView()
                contentVStack.axis = .vertical
                contentVStack.alignment = .fill
                contentVStack.distribution = .fill
                contentVStack.spacing = 0
                contentVStack.translatesAutoresizingMaskIntoConstraints = false
                
                let contentArray = drugData!.content[i]
                
                var startingIndex = 0
                if(contentArray[0].count == 1)
                {
                    let labelView = UIView()
                    labelView.layer.borderWidth = 0.5
                    if #available(iOS 13.0, *) {
                        labelView.layer.borderColor = UIColor.label.cgColor
                    } else {
                        labelView.layer.borderColor = UIColor.black.cgColor
                    }
                    
                    let titleLabel = UILabel()
                    titleLabel.font = font
                    titleLabel.lineBreakMode = .byWordWrapping
                    titleLabel.numberOfLines = 0
                    if(contentArray[0][0] == "#medical_directives") {
                        titleLabel.attributedText = "Ornge Medical Directives".set(style: boldStyle)
                    } else {
                        titleLabel.attributedText = contentArray[0][0].set(style: styleGroup)
                    }
                    titleLabel.translatesAutoresizingMaskIntoConstraints = false
                    labelView.addSubview(titleLabel)
                    stackView.addArrangedSubview(labelView)
                    
                    NSLayoutConstraint.activate([
                        titleLabel.leadingAnchor.constraint(equalTo: labelView.leadingAnchor, constant: 5),
                        titleLabel.trailingAnchor.constraint(equalTo: labelView.trailingAnchor, constant: -5),
                        titleLabel.topAnchor.constraint(equalTo: labelView.topAnchor, constant: 5),
                        titleLabel.bottomAnchor.constraint(equalTo: labelView.bottomAnchor, constant: -5),
                    ])
                    startingIndex = 1
                }
                
                stackView.addArrangedSubview(contentVStack)
                stackCollection.append(contentVStack)
                var viewArray : [[UIView]] = []
                
                for y in startingIndex ..< contentArray.count {
                    let contentHStack = UIStackView()
                    contentHStack.axis = .horizontal
                    contentHStack.alignment = .fill
                    if(contentArray[y].count > 2) {
                        contentHStack.distribution = .fillEqually
                    } else {
                        contentHStack.distribution = .fill
                    }
                    contentHStack.spacing = 0
                    contentHStack.translatesAutoresizingMaskIntoConstraints = false
                    
                    if( y % 2 == 1 ) {
                        contentHStack.addBackground(color: UIColor(named: "Tertiary_background")!)
                    }
                    contentVStack.addArrangedSubview(contentHStack)
                    viewArray.append([])
                    
                    for x in 0 ..< contentArray[y].count {
                        if(contentArray[y][x] != "nil")
                        {
                            let labelView = UIView()
                            labelView.layer.borderWidth = 0.5
                            if #available(iOS 13.0, *) {
                                labelView.layer.borderColor = UIColor.label.cgColor
                            } else {
                                labelView.layer.borderColor = UIColor.black.cgColor
                            }
                            
                            if(contentArray[0][0] == "#medical_directives")
                            {
                                let directive = DataManager.instance.documentByKey(key: contentArray[y][x])
                                contentHStack.distribution = .fillEqually
                                if(directive != nil)
                                {
                                    let button = PageTargetButton(type: .custom)
                                    button.translatesAutoresizingMaskIntoConstraints = false
                                    button.key = contentArray[y][x]
                                    button.addTarget(self, action: #selector(directiveButtonAction), for: .touchUpInside)
                                    button.contentHorizontalAlignment = .left
                                    
                                    let label = UILabel()
                                    
                                    let attributeString = (" \(directive!.title)").set(style: linkStyle)
                                    label.attributedText = attributeString
                                    label.numberOfLines = 0
                                    label.lineBreakMode = .byWordWrapping
                                    label.translatesAutoresizingMaskIntoConstraints = false
                                    
                                    labelView.addSubview(button)
                                    labelView.addSubview(label)
                                    contentHStack.addArrangedSubview(labelView)

                                     NSLayoutConstraint.activate([
                                         button.leadingAnchor.constraint(equalTo: labelView.leadingAnchor, constant: 5),
                                         button.trailingAnchor.constraint(equalTo: labelView.trailingAnchor, constant: -5),
                                         button.topAnchor.constraint(equalTo: labelView.topAnchor, constant: 5),
                                         button.bottomAnchor.constraint(equalTo: labelView.bottomAnchor, constant: -5),
                                         
                                     ])
                                    NSLayoutConstraint.activate([
                                        label.leadingAnchor.constraint(equalTo: labelView.leadingAnchor, constant: 5),
                                        label.trailingAnchor.constraint(equalTo: labelView.trailingAnchor, constant: -5),
                                        label.topAnchor.constraint(equalTo: labelView.topAnchor, constant: 5),
                                        label.bottomAnchor.constraint(equalTo: labelView.bottomAnchor, constant: -5),
                                        
                                    ])
                                } else {
                                    let attributeString = ("n/a").set(style: normalStyle)
                                    let label = UILabel()
                                    label.attributedText = attributeString
                                    label.numberOfLines = 0
                                    label.lineBreakMode = .byWordWrapping
                                    label.translatesAutoresizingMaskIntoConstraints = false
                                    
                                    labelView.addSubview(label)
                                    NSLayoutConstraint.activate([
                                        label.leadingAnchor.constraint(equalTo: labelView.leadingAnchor, constant: 5),
                                        label.trailingAnchor.constraint(equalTo: labelView.trailingAnchor, constant: -5),
                                        label.topAnchor.constraint(equalTo: labelView.topAnchor, constant: 5),
                                        label.bottomAnchor.constraint(equalTo: labelView.bottomAnchor, constant: -5),
                                    ])
                                    contentHStack.addArrangedSubview(labelView)
                                }
                                
                            } else {
                                let contentLabel = UILabel()
                                contentLabel.font = font
                                contentLabel.lineBreakMode = .byWordWrapping
                                if( x == 0 && contentArray[y].count > 1) {
                                    contentLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
                                }
                                
                                contentLabel.numberOfLines = 0
                                contentLabel.attributedText = contentArray[y][x].set(style: styleGroup)
                                contentLabel.translatesAutoresizingMaskIntoConstraints = false
                                
                                if(contentArray[y][x] == "pcp" || contentArray[y][x] == "≥pcp") {
                                    labelView.backgroundColor = pcpColor
                                    contentLabel.textColor = .black
                                }
                                else if(contentArray[y][x] == "ACP(f)" || contentArray[y][x] == "≥ACP(f)") {
                                    labelView.backgroundColor = acpColor
                                    contentLabel.textColor = .black
                                }
                                else if(contentArray[y][x] == "CCP" || contentArray[y][x] == "CCP(f)" || contentArray[y][x] == "≥CCP(f)" || contentArray[y][x] == "CCP\nPCCP/PCCN*" || contentArray[y][x] == "CCP\nPCCP/PCCN") {
                                    labelView.backgroundColor = ccpColor
                                    contentLabel.textColor = .black
                                }
                                else if(contentArray[y][x] == "PCCP(f)") {
                                    labelView.backgroundColor = pccpColor
                                    contentLabel.textColor = .black
                                }
                                                            
                                labelView.addSubview(contentLabel)
                                contentHStack.addArrangedSubview(labelView)

                                NSLayoutConstraint.activate([
                                    contentLabel.leadingAnchor.constraint(equalTo: labelView.leadingAnchor, constant: 5),
                                    contentLabel.trailingAnchor.constraint(equalTo: labelView.trailingAnchor, constant: -5),
                                    contentLabel.topAnchor.constraint(equalTo: labelView.topAnchor, constant: 5),
                                    contentLabel.bottomAnchor.constraint(equalTo: labelView.bottomAnchor, constant: -5),
                                    //labelView.widthAnchor.constraint(greaterThanOrEqualToConstant: 70)
                                ])
                                if(viewArray.count > 1) {
                                    NSLayoutConstraint.activate([
                                        labelView.leadingAnchor.constraint(equalTo: viewArray[viewArray.count-2][x].leadingAnchor),
                                        labelView.trailingAnchor.constraint(equalTo: viewArray[viewArray.count-2][x].trailingAnchor)
                                    ])
                                }
                                viewArray[viewArray.count-1].append(labelView)
                            }
                        }
                    }
                }
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
        
        label.font = .boldSystemFont(ofSize: CGFloat(DataManager.instance.fontSize))
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
        label.font = .systemFont(ofSize: CGFloat(DataManager.instance.fontSize))
        
        if #available(iOS 13.0, *) {
            label.textColor = UIColor.label
        } else {
            label.textColor = UIColor.black
        }
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

extension DrugMonographViewController : UIScrollViewDelegate
{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return stackView
    }
}
