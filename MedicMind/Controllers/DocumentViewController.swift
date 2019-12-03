//
//  DocumentViewController.swift
//  Ornge
//
//  Created by Charles Trickey on 2019-10-26.
//  Copyright © 2019 Charles Trickey. All rights reserved.
//

import UIKit

class DocumentViewController: UIViewController {

    var document : Document?
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.systemBackground

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
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: DataManager.instance.boldFontName, size: CGFloat(20.0))
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textAlignment = .center
        titleLabel.text = document?.title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        //titleLabel.textColor = UIColor.label
        stackView.addArrangedSubview(titleLabel)
        
        
        let attributeString = document!.text.htmlAttributed(family: DataManager.instance.fontName, size: CGFloat(DataManager.instance.fontSize-3))
        
        let mutableBodyString = NSMutableAttributedString()
        mutableBodyString.append(attributeString!)
        let style = NSMutableParagraphStyle()
        style.paragraphSpacing = 15
        mutableBodyString.addAttributes([NSAttributedString.Key.paragraphStyle : style], range: NSMakeRange(0, mutableBodyString.length))
        
        /*let imageAttachement = NSTextAttachment()
        imageAttachement.image = UIImage(named: "Universal Airway 1.jpg")
        let image1String = NSAttributedString(attachment: imageAttachement)
        mutableBodyString.append(image1String)*/
        
        let textLabel = UILabel()
        textLabel.attributedText = attributeString
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textColor = UIColor.label

        stackView.addArrangedSubview(textLabel)
    }
}
