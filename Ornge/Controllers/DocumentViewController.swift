//
//  DocumentViewController.swift
//  Ornge
//
//  Created by Charles Trickey on 2020-08-14.
//  Copyright © 2020 Charles Trickey. All rights reserved.
//

import Foundation
import UIKit


class DocumentViewController : UITableViewController
{
    var document : Document?
    
    static func loadViewControllerWithKey(key : String)
    {
        let navController = UIApplication.shared.windows[0].rootViewController as? UINavigationController
        let storyboard = navController?.storyboard

        let documentData = DataManager.instance.documentByKey(key: key)
        if(documentData == nil) {
            return
        }
        let viewController = storyboard!.instantiateViewController(withIdentifier: "DocumentViewController") as! DocumentViewController
        viewController.document = documentData
        navController!.pushViewController(viewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(document == nil) {
            return
        }
        
        //MARK: DoseRoute
        /*if(documentData!.content.count > 0)
        {
            var stackCollection : [UIStackView] = []
        
            for i in 0 ..< documentData!.content.count
            {
                let contentVStack = UIStackView()
                contentVStack.axis = .vertical
                contentVStack.alignment = .fill
                contentVStack.distribution = .fill
                contentVStack.spacing = 0
                contentVStack.translatesAutoresizingMaskIntoConstraints = false
                
                let contentArray = documentData!.content[i]
                
                var startingIndex = 0
                if(contentArray[0].count == 1)
                {
                    let labelView = UIView()
                    labelView.layer.borderWidth = 0.5
                    labelView.layer.borderColor = UIColor.label.cgColor
                    
                    let titleLabel = UILabel()
                    titleLabel.font = font
                    titleLabel.lineBreakMode = .byWordWrapping
                    titleLabel.numberOfLines = 0
                    
                    titleLabel.attributedText = contentArray[0][0].set(style: styleGroup)
                    
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
                            labelView.layer.borderColor = UIColor.label.cgColor
                            
                            
                            let contentLabel = UILabel()
                            contentLabel.font = .systemFont(ofSize: CGFloat(DataManager.instance.fontSize))
                            contentLabel.lineBreakMode = .byWordWrapping
                            if( x == 0 && contentArray[y].count > 1) {
                                contentLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
                            }
                            
                            contentLabel.numberOfLines = 0
                            contentLabel.attributedText = contentArray[y][x].set(style: styleGroup)
                            contentLabel.translatesAutoresizingMaskIntoConstraints = false
                            
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
        }*/
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
            // horizonalstackView.heightAnchor.constraint(equalTo: 50)
            ])
        
        return horizonalstackView
    }
}
