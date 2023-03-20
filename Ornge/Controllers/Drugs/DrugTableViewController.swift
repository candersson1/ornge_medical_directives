//
//  DrugTableViewController.swift
//  Ornge
//
//  Created by Charles Trickey on 2019-12-03.
//  Copyright © 2019 Charles Trickey. All rights reserved.
//

import Foundation
import UIKit

class DrugTableViewController : UIViewController
{
    var drugData : Drug?
    let stackView = UIStackView()
 
    @IBOutlet weak var scrollView: UIScrollView!
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: ( keyboardViewEndFrame.height + 20 ) - view.safeAreaInsets.bottom, right: 0)
        }
        
        scrollView.scrollIndicatorInsets = scrollView.contentInset
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
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10
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
        
        let titleFont = UIFont.systemFont(ofSize: CGFloat(DataManager.instance.fontSize + 3))
        let font = UIFont.systemFont(ofSize: CGFloat(DataManager.instance.fontSize))
        
        let titleLabel = UILabel()
        titleLabel.font = titleFont
        titleLabel.text = "Infusion Tables"
        stackView.addArrangedSubview(titleLabel)
        
        if(drugData!.drug_tables.count > 0)
        {
            for drugTable in drugData!.drug_tables
            {
                
                if(drugTable.name != "")
                {
                    let mixingTable = MixingCalculatorView(data: drugTable)
                    mixingTable.parentView = scrollView
                    mixingTable.setTapGestureRecognizer()
                    mixingTable.layer.borderWidth = 0.5
                    
                    
                    stackView.addArrangedSubview(mixingTable)
                    
                    NSLayoutConstraint.activate([
                        mixingTable.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 5),
                        mixingTable.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -5),
                    ])
                    
                }
                
                var viewArray : [[UIView]] = []
                let contentVStack = UIStackView()
                contentVStack.axis = .vertical
                contentVStack.alignment = .fill
                contentVStack.distribution = .fill
                contentVStack.spacing = 0
                contentVStack.translatesAutoresizingMaskIntoConstraints = false
                stackView.addArrangedSubview(contentVStack)
                
                NSLayoutConstraint.activate([
                    contentVStack.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 5),
                    contentVStack.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -5),
                ])
                
                var startingIndex = 0
                if(drugTable.static_tables[0].count == 1)
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
                    titleLabel.attributedText = drugTable.static_tables[0][0].set(style: styleGroup)
                    
                    titleLabel.translatesAutoresizingMaskIntoConstraints = false
                    labelView.addSubview(titleLabel)
                    contentVStack.addArrangedSubview(labelView)
                    
                    NSLayoutConstraint.activate([
                        titleLabel.leadingAnchor.constraint(equalTo: labelView.leadingAnchor, constant: 5),
                        titleLabel.trailingAnchor.constraint(equalTo: labelView.trailingAnchor, constant: -5),
                        titleLabel.topAnchor.constraint(equalTo: labelView.topAnchor, constant: 5),
                        titleLabel.bottomAnchor.constraint(equalTo: labelView.bottomAnchor, constant: -5),
                    ])
                    startingIndex = 1
                }
                
                for y in startingIndex ..< drugTable.static_tables.count {
                    let contentHStack = UIStackView()
                    contentHStack.axis = .horizontal
                    contentHStack.alignment = .fill
                    contentHStack.distribution = .fillEqually
                    contentHStack.spacing = 0
                    contentHStack.translatesAutoresizingMaskIntoConstraints = false
                    
                    if( y == 1)
                    {
                        contentHStack.addBackground(color: UIColor(named: "Label")!)
                    }
                    else if( y % 2 == 1 ) {
                        contentHStack.addBackground(color: UIColor(named: "Secondary_background")!)
                    }
                    contentVStack.addArrangedSubview(contentHStack)
                    viewArray.append([])
                    
                    for x in 0 ..< drugTable.static_tables[y].count {
                        if(drugTable.static_tables[y][x] != "nil")
                        {
                            let labelView = UIView()
                            labelView.layer.borderWidth = 0.5
                            labelView.layer.borderColor = UIColor(named: "Label")!.cgColor
                            
                            let contentLabel = UILabel()
                            contentLabel.font = font
                            contentLabel.lineBreakMode = .byWordWrapping
                            contentLabel.numberOfLines = 0
                            contentLabel.attributedText = drugTable.static_tables[y][x].set(style: styleGroup)
                            contentLabel.translatesAutoresizingMaskIntoConstraints = false
                            
                            if( y == 1)
                            {
                                contentLabel.textColor = UIColor(named: "Primary_background")
                            }
                            labelView.addSubview(contentLabel)
                            contentHStack.addArrangedSubview(labelView)

                            NSLayoutConstraint.activate([
                                contentLabel.leadingAnchor.constraint(equalTo: labelView.leadingAnchor, constant: 5),
                                contentLabel.trailingAnchor.constraint(equalTo: labelView.trailingAnchor, constant: -5),
                                contentLabel.topAnchor.constraint(equalTo: labelView.topAnchor, constant: 5),
                                contentLabel.bottomAnchor.constraint(equalTo: labelView.bottomAnchor, constant: -5),
                                labelView.widthAnchor.constraint(greaterThanOrEqualToConstant: 70)
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

extension DrugTableViewController : UIScrollViewDelegate
{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return stackView
    }
}
 
