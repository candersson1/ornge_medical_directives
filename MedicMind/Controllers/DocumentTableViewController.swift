//
//  DocumentTableViewController.swift
//  Ornge
//
//  Created by Charles Trickey on 2020-03-14.
//  Copyright © 2020 Charles Trickey. All rights reserved.
//

import UIKit

protocol TetheredScrollViewDelegate
{
    func syncToScrollView(scrollView : UIScrollView)
}

enum CellType {
    case None
    case AttributedString
    case Checkbox
}

class CellContent {
    var contentWidth : CGFloat?
    var contentHeight : CGFloat?
    
    var type : CellType { return .None }
    
    init(_ string : String) {}
    
    func getHeightOfContent(for width : CGFloat) -> CGFloat? {return nil}
}

class CellContentAttributedString : CellContent {
    
    var attributedString : NSAttributedString?
    var textAlignment : NSTextAlignment?
    
    override var type : CellType { return .AttributedString }
    
    override init(_ string : String) {
        super.init(string)
        self.attributedString = string.set(style: styleGroup)
        self.textAlignment = getAlignmentFromTaggedString(string)
        if let constrainedWidth = getFloatFromTaggedString(string, tag: "<width=") {
            contentWidth = constrainedWidth
        }
    }
    
    func getFloatFromTaggedString(_ inputString : String, tag : String) -> CGFloat? {
        var tempString = inputString
        if let tagStartIndex = tempString.index(of: tag) {
            tempString.removeSubrange(tempString.startIndex ..< tagStartIndex)
            tempString = tempString.removing(prefix: tag)
            if let tagEndIndex = tempString.firstIndex(of: ">") {
                let subString = tempString.prefix(upTo: tagEndIndex)
                if let value = Float(subString) {
                    return CGFloat(value)
                }
            }
        }
        return nil
    }
    
    override func getHeightOfContent(for width : CGFloat) -> CGFloat? {
        return attributedString?.height(withConstrainedWidth: width)
    }
    
    func getAlignmentFromTaggedString(_ inputString : String) -> NSTextAlignment? {
        if inputString.contains("<left>") {
            return .left
        } else if inputString.contains("<center>") {
            return .center
        } else if inputString.contains("<right>") {
            return .right
        } else if inputString.contains("<justified>") {
            return .justified
        }
        return nil
    }
}

class CellContentCheckbox : CellContent, CheckBoxButtonDelegate {
    
    override var type : CellType { return .Checkbox }

    var checkBoxStatus : Int = 0
    
    override init(_ string : String) {
        super.init(string)
        contentHeight = 30
        contentWidth = 30
    }
    
    override func getHeightOfContent(for width : CGFloat) -> CGFloat?
    {
        return 30
    }
    
    func checkBoxChanged(checkBoxButton: CheckBoxButton) {
        checkBoxStatus = checkBoxButton.selectionIndex
    }
}

let cellContentInsetTop : CGFloat = 5
let cellContentInsetLeft : CGFloat = 8
let cellContentInsetRight : CGFloat = 8
let cellContentInsetBottom : CGFloat = 5

struct CellSize {
    var portraitSize : CGSize
    var landscapeSize : CGSize
}

class SectionInfo {
    let defaultWidth : CGFloat = 100
    let defaultHeight : CGFloat = 60
    
    let sectionHorizontalInset : CGFloat = 20
    let sectionSpacing : CGFloat = 20
    
    var cellsInfo : NSMutableArray = []
    var _sectionCellInfo : NSMutableArray = []
    var sectionCellInfo : NSMutableArray? {
        get {
            if _sectionCellInfo.count > 0 {
                if let sectionCellData = _sectionCellInfo[0] as? NSMutableArray {
                    return sectionCellData
                }
            }
            return nil
        }
    }
    
    var cellSizeMatrixPortrait : [[CGSize]] = []
    var cellSizeMatrixLandscape : [[CGSize]] = []
    
    var cellSizeMatrix : [[CGSize]] {
        get {
            if(UIDevice.current.orientation == .portrait) {
                return cellSizeMatrixPortrait
            } else {
                return cellSizeMatrixLandscape
            }
        }
    }
    
    var headerSizeMatrixPortrait : [CGSize] = []
    var headerSizeMatrixLandscape : [CGSize] = []
    
    var headerSizeMatrix : [CGSize] {
        get {
            if(UIDevice.current.orientation == .portrait) {
                return headerSizeMatrixPortrait
            } else {
                return headerSizeMatrixLandscape
            }
        }
    }
    
    var minimumSectionWidth : CGFloat?
    
    var portraitSectionWidth : CGFloat = 0
    var landscapeSectionWidth : CGFloat = 0
    
    var sectionWidth : CGFloat {
        get {
            if(UIDevice.current.orientation == .portrait) {
                return portraitSectionWidth
            } else {
                return landscapeSectionWidth
            }
        }
    }
        
    var headerCell : DocumentTableCell?
    var sectionCell : DocumentTableCell?
    
    init(_ strings : [[String]], sectionWidth : CGFloat = 0) {
        var tempStrings = strings
        if(sectionWidth != 0) {
            self.minimumSectionWidth = sectionWidth
        }
        //check if there is a section tag
        if(tempStrings[0][0].hasPrefix("<section>")) {
            //check to see if we have a <section_width> tag and input our minimum section width
            if let sectionWidth = getFloatFromTaggedString(tempStrings[0][0], tag: "<section_width=") {
                self.minimumSectionWidth = sectionWidth
            }
            
            let subArray = NSMutableArray()
            for j in 0 ..< tempStrings[0].count {
                subArray.add(CellInfo(tempStrings[0][j]))
            }
            _sectionCellInfo.add(subArray)
            tempStrings.remove(at: 0) //remove the section header info
            
        }
        
        //setup section widths for both screen orientations
        guard let root = UIApplication.shared.windows[0].rootViewController else {
            return
        }

        var screenWidth : CGFloat
        var screenHeight : CGFloat
        
        if(UIDevice.current.orientation == .portrait) {
            screenWidth = root.view.bounds.width - 20
            screenHeight = root.view.bounds.height - 120
        } else {
            screenWidth = root.view.bounds.height - 20
            screenHeight = root.view.bounds.width - 120
        }
        
        portraitSectionWidth = screenWidth
        landscapeSectionWidth = screenHeight
        
        if(minimumSectionWidth ?? 0 > screenWidth) {
            portraitSectionWidth = minimumSectionWidth!
        }
        
        if(minimumSectionWidth ?? 0 > screenHeight) {
            landscapeSectionWidth = minimumSectionWidth!
        }
        
        for i in 0 ..< tempStrings.count {
            let subArray = NSMutableArray()
            for j in 0 ..< tempStrings[i].count {
                subArray.add(CellInfo(tempStrings[i][j]))
            }
            cellsInfo.add(subArray)
        }
        
        if _sectionCellInfo.count > 0 {
            if let sectionCellData = _sectionCellInfo[0] as? NSMutableArray {
                headerSizeMatrixPortrait = prepareSizeMatrixForRow(for: sectionCellData)
                headerSizeMatrixLandscape = prepareSizeMatrixForRow(for: sectionCellData, isLandscape: true)
            }
        }
        for row in cellsInfo {
            if let cellRow = row as? NSMutableArray {
                cellSizeMatrixPortrait.append(prepareSizeMatrixForRow(for: cellRow))
                cellSizeMatrixLandscape.append(prepareSizeMatrixForRow(for: cellRow, isLandscape: true))
            }
        }
    }
    
    func getFloatFromTaggedString(_ inputString : String, tag : String) -> CGFloat? {
        var tempString = inputString
        if let tagStartIndex = tempString.index(of: tag) {
            tempString.removeSubrange(tempString.startIndex ..< tagStartIndex)
            tempString = tempString.removing(prefix: tag)
            if let tagEndIndex = tempString.firstIndex(of: ">") {
                let subString = tempString.prefix(upTo: tagEndIndex)
                if let value = Float(subString) {
                    return CGFloat(value)
                }
            }
        }
        return nil
    }
    
    func prepareSizeMatrixForRow(for cells : NSMutableArray, isLandscape : Bool = false) -> [CGSize] {
        var cellSizeArray : [CGSize] = []
        
        var totalStaticCellWidth : CGFloat = 0
        var dynamicCells : Int = 0
        
        //find all the cells that have a set width
        //if there is no set width, then add the index so that we can reference it later
        for cell in 0 ..< cells.count {
            if let cellInfo = cells[cell] as? CellInfo {
                if(cellInfo.cellWidth == nil) {
                    if(sectionCellInfo != nil) {
                        if let sectionCell = sectionCellInfo![cell] as? CellInfo {
                            if sectionCell.cellWidth != nil {
                                totalStaticCellWidth += sectionCell.cellWidth!
                                cellInfo.data?.contentWidth = sectionCell.contentWidth!
                            } else {
                                dynamicCells += 1
                            }
                        } else {
                            dynamicCells += 1
                        }
                    } else {
                        dynamicCells += 1
                    }
                } else {
                    totalStaticCellWidth += cellInfo.cellWidth!
                }
            }
        }
        
        //set the section width based on orientation
        var dynamicCellWidth : CGFloat
        if(isLandscape) {
            dynamicCellWidth = (landscapeSectionWidth - totalStaticCellWidth) / CGFloat(dynamicCells)
        } else {
            dynamicCellWidth = (portraitSectionWidth - totalStaticCellWidth) / CGFloat(dynamicCells)
        }
        
        for cell in 0 ..< cells.count {
            if let cellInfo = cells[cell] as? CellInfo {
                if(cellInfo.cellWidth == nil) {
                    let height = cellInfo.data!.getHeightOfContent(for: dynamicCellWidth - (cellContentInsetLeft + cellContentInsetRight))
                    cellSizeArray.append(CGSize(width: dynamicCellWidth, height: height! + (cellContentInsetTop + cellContentInsetBottom)))
                } else {
                    let height = cellInfo.data!.getHeightOfContent(for: cellInfo.cellWidth! - (cellContentInsetLeft + cellContentInsetRight))
                    cellSizeArray.append(CGSize(width: cellInfo.cellWidth!, height: height! + (cellContentInsetTop + cellContentInsetBottom)))
                }
            }
        }
        
        return cellSizeArray
    }
    
    func heightForRow(index : Int) -> CGFloat {
       
        var rowContentHeight : CGFloat = 0
        if cellSizeMatrix.count > index {
            if cellSizeMatrix[index].count > 0  {
                for j in 0 ..< cellSizeMatrix[index].count {
                    if cellSizeMatrix[index][j].height > rowContentHeight {
                        rowContentHeight = cellSizeMatrix[index][j].height
                    }
                }
            }
        }
        return rowContentHeight
    }
    
    func heightForSectionHeader() -> CGFloat {
        if(sectionCellInfo == nil) {
            return 0
        }
        var rowContentHeight : CGFloat = 0
        
        for j in 0 ..< headerSizeMatrix.count {
            if headerSizeMatrix[j].height > rowContentHeight {
                rowContentHeight = headerSizeMatrix[j].height
            }
        }
        
        return rowContentHeight
    }
    
    func heightForSection() -> CGFloat {
        var height : CGFloat = 0
        for i in 0 ..< cellsInfo.count {
            height += heightForRow(index: i)
        }
        return height + sectionSpacing
    }
    
    func sectionHeaderCell(at index : Int) -> CellInfo? {
        if(sectionCellInfo != nil) {
            if let sectionCell = sectionCellInfo![index] as? CellInfo {
                return sectionCell
            }
        }
        return nil
    }
}


let defaultCellHeight : CGFloat = 30.0
let defaultCellWidth : CGFloat = 100.0
//MARK: CellInfo: This handles exclusively deciding what kind of content to initialize
class CellInfo {
    enum SizeType {
        case Static
        case Dynamic
        case StaticFromHeader
    }
    var sizeType : SizeType = .Static
    var data : CellContent?
    var cellHeight : CGFloat? {
        get {
            if(data != nil) {
                if(data!.contentHeight != nil) {
                    return cellContentInsetTop + cellContentInsetBottom + data!.contentHeight!
                }
            }
            return nil
        }
    }
    var cellWidth : CGFloat? {
        get {
            if(data != nil) {
                if(data!.contentWidth != nil) {
                    return cellContentInsetLeft + cellContentInsetRight + data!.contentWidth!
                }
            }
            return nil
        }
    }
    
    var contentHeight : CGFloat? {
        get {
            if(data != nil) {
                if(data!.contentHeight != nil) {
                    return data!.contentHeight!
                }
            }
            return nil
        }
    }
    var contentWidth : CGFloat? {
        get {
            if(data != nil) {
                if(data!.contentWidth != nil) {
                    return data!.contentWidth!
                }
            }
            return nil
        }
    }
    
    convenience init(_ string : String) {
        self.init()
        initializeFromString(string)
    }
    
    init() { }
    
    func initializeFromString(_ string : String) {
        //MARK: Specific to string cell
        if(string.hasPrefix("<checkbox>")) {
            data = CellContentCheckbox(string)
        } else {
            data = CellContentAttributedString(string)
        }
        
        if(string.contains("<width=")) {
            sizeType = .Static
        }
    }
}

class DocumentTableCell : UITableViewCell {
    @IBOutlet weak var collectionView: IndexedCollectionView!
}

class CollectionCellPaddedLabel : UICollectionViewCell {
    @IBOutlet weak var textView: UITextView!
}

class CollectionCellCheckboxButton : UICollectionViewCell {
    @IBOutlet weak var button: CheckBoxButton!
}

class IndexedCollectionView : UICollectionView {
    var width : CGFloat = 0
    override func layoutSubviews() {
        super.layoutSubviews()
        if (self.width != self.frame.size.width) {
            self.width = self.frame.size.width
            self.collectionViewLayout.invalidateLayout()
        }
    }
    var cells : NSMutableArray!
    var sectionInfo : SectionInfo!
    var isSectionHeader : Bool = false
}

class DocumentTableViewController: UITableViewController {

    @IBOutlet weak var headerLabel: UILabel!
    var document : dep_Document?
    var tableCellData : [SectionInfo] = []
    
    @objc func displayPopover(_ sender : UIView) {
        let navController = UIApplication.shared.windows[0].rootViewController as? UINavigationController
        let storyboard = navController?.storyboard
        
        let viewController = storyboard!.instantiateViewController(withIdentifier: "PopoverViewController") as! PopoverViewController
        viewController.modalPresentationStyle = .popover
        viewController.modalTransitionStyle = .coverVertical
        viewController.preferredContentSize = CGSize(width: 300, height: 200)
        let popover: UIPopoverPresentationController = viewController.popoverPresentationController!
        popover.sourceView = sender
        present(viewController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if(document != nil) {
            headerLabel.text = document!.title
            for i in 0 ..< document!.content.count { //sections
                tableCellData.append(SectionInfo(document!.content[i]))
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableCellData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableCellData[section].heightForSectionHeader()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(tableCellData[section]._sectionCellInfo.count > 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "documentCell") as! DocumentTableCell
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            cell.collectionView.sectionInfo = tableCellData[section]
            cell.collectionView.cells = tableCellData[section]._sectionCellInfo
            cell.collectionView.isSectionHeader = true
            tableCellData[section].headerCell = cell
            if let layout = cell.collectionView?.collectionViewLayout as? DocumentTableLayout {
                layout.invalidateLayout()
            }
            cell.collectionView.reloadData()
            cell.collectionView.layoutSubviews()

            return cell
        }
        return UIView(frame: CGRect.zero)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "documentCell", for: indexPath) as! DocumentTableCell
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        cell.collectionView.sectionInfo = tableCellData[indexPath.section]
        cell.collectionView.cells = tableCellData[indexPath.section].cellsInfo
        
        tableCellData[indexPath.section].sectionCell = cell
        if let layout = cell.collectionView?.collectionViewLayout as? DocumentTableLayout {
            layout.invalidateLayout()
        }
        cell.collectionView.reloadData()
        cell.collectionView.layoutSubviews()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionInfo = tableCellData[indexPath.section]
        return sectionInfo.heightForSection()
    }
}
//MARK: Collection View Data Source and Delegate
extension DocumentTableViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let indexedCollectionView = (collectionView as! IndexedCollectionView)
        return indexedCollectionView.cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let indexedCollectionView = (collectionView as! IndexedCollectionView)
        if let cellSection = indexedCollectionView.cells[section] as? NSMutableArray {
            return cellSection.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let indexedCollectionView = (collectionView as! IndexedCollectionView)
        if let sectionRow = indexedCollectionView.cells[indexPath.section] as? NSMutableArray {
            if let cellInfo = sectionRow[indexPath.item] as? CellInfo {
                switch cellInfo.data?.type {
                case .AttributedString:
                    let cellStringInfo = cellInfo.data as! CellContentAttributedString
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "padded_label", for: indexPath) as! CollectionCellPaddedLabel
                    cell.textView.attributedText = (cellInfo.data as! CellContentAttributedString).attributedString
                    
                    if(indexedCollectionView.sectionInfo.sectionCellInfo != nil)
                    {
                        if(indexedCollectionView.sectionInfo.sectionCellInfo!.count > indexPath.row) {
                            if let sectionInfoForCell = indexedCollectionView.sectionInfo.sectionCellInfo![indexPath.item] as? CellInfo {
                                if let cellInfoData = sectionInfoForCell.data as? CellContentAttributedString {
                                    if(cellInfoData.textAlignment != nil) {
                                        cell.textView.textAlignment = cellInfoData.textAlignment!
                                    }
                                }
                            }
                        }
                    }
                    if cellStringInfo.textAlignment != nil {
                        cell.textView.textAlignment = cellStringInfo.textAlignment!
                    }
                    cell.textView.textContainerInset = UIEdgeInsets(top: cellContentInsetTop, left: cellContentInsetLeft, bottom: 0, right: 0)
                    cell.textView.delegate = self
                    cell.backgroundColor = UIColor(named: "Tertiary_background")
                    cell.layer.borderColor = UIColor.systemGray5.cgColor
                    cell.layer.borderWidth = 0.5
                    return cell
                case .Checkbox:
                    let cellButtonInfo = cellInfo.data as! CellContentCheckbox
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "checkbox", for: indexPath) as! CollectionCellCheckboxButton
                    cell.button.selectionIndex = cellButtonInfo.checkBoxStatus
                    cell.button.delegate = cellButtonInfo
                    cell.layer.borderColor = UIColor.systemGray5.cgColor
                    cell.backgroundColor = UIColor(named: "Tertiary_background")
                    cell.layer.borderWidth = 0.5
                    return cell
                default:
                    return UICollectionViewCell()
                }
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.zero
    }
        
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let collectionView = scrollView as? IndexedCollectionView {
            if (collectionView == collectionView.sectionInfo.headerCell?.collectionView) {
                if let sectionCell = collectionView.sectionInfo.headerCell {
                    if let headerCell = collectionView.sectionInfo.sectionCell {
                        syncScrollView(sectionCell.collectionView, toScrollView : headerCell.collectionView)
                    }
                }
            }
            else if (collectionView == collectionView.sectionInfo.sectionCell?.collectionView) {
                if let sectionCell = collectionView.sectionInfo.sectionCell {
                    if let headerCell = collectionView.sectionInfo.headerCell {
                        syncScrollView(headerCell.collectionView, toScrollView : sectionCell.collectionView)
                    }
                }
            }
        }
    }
    func syncScrollView(_ scrollViewToScroll: UIScrollView, toScrollView scrolledView: UIScrollView) {
        var scrollBounds = scrollViewToScroll.bounds
        scrollBounds.origin.x = scrolledView.contentOffset.x
        scrollViewToScroll.bounds = scrollBounds
    }
}

//MARK: UITextViewDelegate
extension DocumentTableViewController : UITextViewDelegate
{
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {

        print("tapped a link")
        var targetString = URL.absoluteString
        if(targetString.hasPrefix("drugKey=")) {
            targetString = String(targetString.dropFirst(8))
            DrugMonographViewController.loadViewControllerWithKey(key: targetString)
        }
        return false
    }
    
}
