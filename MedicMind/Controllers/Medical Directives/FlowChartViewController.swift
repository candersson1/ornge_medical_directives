//
//  FlowChartViewController.swift
//  OntarioMedic
//
//  Created by Charles Trickey on 2019-09-05.
//  Copyright © 2019 Charles Trickey. All rights reserved.
//


import UIKit

let textSize : CGFloat = 8.0
class FlowChartViewController: UIViewController {
    
    var scrollView : FlowChartScrollView!
    var flowchartData : FlowChart?
    
    let textCellBuffer = Element.textCellBuffer

    let titleTextSize : CGFloat = 18.0
    
    let grid = Grid()
    
    var layerView = UIView()
    var shapeLayer = CALayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layerView.layer.addSublayer(shapeLayer)
        
        scrollView = FlowChartScrollView(frame: self.view.bounds)
        self.view.addSubview(scrollView)
        scrollView.addSubview(layerView)
        
        for element in flowchartData!.elements
        {
            var index = 0

            let contentSize = CGSize(width: 80, height: 80)//getElementContentRectByIndex(x: x, y: y)
            
            if( element.text.isEmpty ) {
                continue
            }
            
            //parse the first element of the type string to determine what will be created
            if( element.type == "diamond") {
                element.contentSize = contentSize
                grid.addElementToGrid(element)
             }
             else if( element.type == "square") {
                let attString = NSAttributedString(string: element.text)
                let boxSize = getTextBoxSizeByString(str: attString)
                element.contentSize = CGSize(width: boxSize.width + 10, height: boxSize.height + 10)
                grid.addElementToGrid(element)
            }
            else if( element.type == "exit") {
                let attString = NSAttributedString(string: element.text)
                let boxSize = getTextBoxSizeByString(str: attString)
                element.contentSize = CGSize(width: boxSize.width + 10, height: boxSize.height + 40)
                grid.addElementToGrid(element)
            }
            else if( element.type == "rounded") {
                let attString = NSAttributedString(string: element.text)
                let boxSize = getTextBoxSizeByString(str: attString)
                element.contentSize = CGSize(width: boxSize.width + 30, height: boxSize.height + 10)
                grid.addElementToGrid(element)
            }
            
            index = index + 1
        }
        
        for element in flowchartData!.elements
        {
            for connection in element.connections
            {
                let startElement = getElementByXYIndex(x: element.x, y: element.y)
                let endElement = getElementByXYIndex(x: connection.x, y: connection.y)
                grid.drawConnection(to: shapeLayer, first: startElement, second: endElement, connection: connection)
            }
        }

        let textBoxSize = getTextBoxSizeByString(str: flowchartData!.title, size: titleTextSize)
        
        let gridSize = grid.size
        let adjustedOrigin = CGPoint(x: gridSize.width/2 - textBoxSize.width/2, y: 20 - textBoxSize.height/2)
        let textframe = CGRect(origin: adjustedOrigin, size: textBoxSize)
        
        let textLayer = CATextLayer()
        textLayer.frame = textframe
        textLayer.string = flowchartData!.title
        textLayer.font = CTFontCreateWithName(DataManager.instance.fontName as CFString, CGFloat(8.0), nil)
        textLayer.fontSize = titleTextSize
        textLayer.foregroundColor = UIColor.black.cgColor
        textLayer.isWrapped = true
        textLayer.alignmentMode = CATextLayerAlignmentMode.center
        textLayer.contentsScale = UIScreen.main.scale
        
        shapeLayer.addSublayer(textLayer)
        //grid.drawGrid(to: shapeLayer)
        grid.drawElements(to: shapeLayer)

        shapeLayer.bounds = CGRect(x: -gridSize.width/2, y: -gridSize.height/2, width: gridSize.width, height: gridSize.height)
        
        layerView.frame = CGRect(x: -gridSize.width/2, y: 0, width: gridSize.width, height: gridSize.height)
        
        scrollView.zoomView = layerView
        scrollView.flowChartSize = gridSize
        scrollView.contentSize = gridSize
        
        layoutImageScrollView()

        scrollView.configure()
    }
    
    func layoutImageScrollView() {
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        let top = NSLayoutConstraint(item: self.scrollView as Any, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0.0)
        let left = NSLayoutConstraint(item: self.scrollView as Any, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0.0)
        let bottom = NSLayoutConstraint(item: self.scrollView as Any, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let right = NSLayoutConstraint(item: self.scrollView as Any, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0.0)
        self.view.addConstraints([top, left, bottom, right])
    }
    
    func getElementByXYIndex(x : Int, y : Int) -> Element
    {
        for element in flowchartData!.elements {
            if(element.x == x && element.y == y)
            {
                return element
            }
        }
        return Element()
    }
    
    
    func getTextBoxSizeByString(str : String, size : CGFloat) -> CGSize {
        let font = UIFont(name: DataManager.instance.fontName, size: size)
        let textBoxSize : CGSize = str.size(withAttributes: [.font: font!])
        return textBoxSize
    }
    
    func getTextBoxSizeByString(str : NSAttributedString) -> CGSize {
        let textBoxSize : CGSize = str.size()
        return textBoxSize
    }
}

class Grid
{
    var columns : [CGFloat] = []
    var rows : [CGFloat] = []
    var elements : [Element] = []
    
    let minCellSize = CGSize(width : 20, height : 20)
    let gridInset = CGSize(width : 5, height : 30)
    let cellBuffer = CGSize(width: 15, height : 15)
    
    let elementColor = UIColor(hex: "#edf3ffff")!
    let arrowColor = UIColor(hex: "#6e8fccff")!
    
    
    var size : CGSize {
        get {
            var sizeY = gridInset.height
            var sizeX = gridInset.width
            for y in 0..<rows.count {
                sizeY = sizeY + rows[y]
            }
            for x in 0..<columns.count {
                sizeX = sizeX + columns[x]
            }
            return CGSize(width: sizeX + gridInset.width, height: sizeY + gridInset.height)
        }
    }
    
    func addElementToGrid(_ element : Element) {
        //make sure that the grid is big enough to hold all the elements
        
        if(columns.count <= element.x) {
            for _ in columns.count ... element.x {
                columns.append(minCellSize.width)
            }
        }
        if(rows.count <= element.y) {
            for _ in rows.count ... element.y {
                rows.append(minCellSize.height)
            }
        }
        
        //set the width and height of the columns and rows
        if( columns[element.x] < (element.contentSize.width + (cellBuffer.width*2))) {
            columns[element.x] = (element.contentSize.width + (cellBuffer.width*2))
        }
        if( rows[element.y] < (element.contentSize.height + (cellBuffer.height*2))) {
            rows[element.y] = (element.contentSize.height + (cellBuffer.height*2))
        }
        element.grid = self
        elements.append(element)
    }
    
    func getGridOriginByIndex(xIndex : Int, yIndex : Int) -> CGPoint {
        var originY = gridInset.height
        var originX = gridInset.width
        for y in 0..<yIndex {
            originY = originY + rows[y]
        }
        for x in 0..<xIndex {
            originX = originX + columns[x]
        }
        return CGPoint(x: originX, y: originY)
    }
    
    func getAdjustedRectForElementByIndex(xIndex : Int, yIndex : Int) -> CGRect {
        let origin = getGridOriginByIndex(xIndex: xIndex, yIndex: yIndex)
        let element = getElementByXYIndex(x: xIndex, y: yIndex)
        let elementRect = CGRect(x: origin.x + cellBuffer.width, y: origin.y + cellBuffer.height, width: element.contentSize.width, height: element.contentSize.height)
        let cellSize = CGSize(width: columns[xIndex], height: rows[yIndex])
        let adjustedOrigin = CGPoint(x: origin.x + cellSize.width/2 - elementRect.size.width/2, y: origin.y + cellSize.height/2 - elementRect.size.height/2)
        return CGRect(x: adjustedOrigin.x, y: adjustedOrigin.y, width: elementRect.width, height: elementRect.height)
    }
    
    func drawGrid(to layer : CALayer)
    {
        var yTotal = gridInset.height
        for y in 0..<rows.count {
            var xTotal = gridInset.width
            for x in 0..<columns.count {
                drawDebugBox(to: layer, origin: CGPoint(x: xTotal, y: yTotal), size: CGSize(width: columns[x], height: rows[y]))
                xTotal = xTotal + columns[x]
            }
            yTotal = yTotal + rows[y]
        }
    }
    
    func drawElements(to layer : CALayer)
    {
        for element in elements {
            let origin = getGridOriginByIndex(xIndex: element.x, yIndex: element.y)
            let elementRect = CGRect(x: origin.x + cellBuffer.width, y: origin.y + cellBuffer.height, width: element.contentSize.width, height: element.contentSize.height)
            let cellSize = CGSize(width: columns[element.x], height: rows[element.y])
            let adjustedOrigin = CGPoint(x: origin.x + cellSize.width/2 - elementRect.size.width/2, y: origin.y + cellSize.height/2 - elementRect.size.height/2)
            
            if element.type == "diamond"
            {
                drawDiamondElement(to: layer, origin: adjustedOrigin, size: elementRect.size, text: element.text)
            }
            else if element.type == "square"
            {
                drawBoxElement(to: layer, origin: adjustedOrigin, size: elementRect.size, text: element.text)
            }
            else if element.type == "exit"
            {
                drawPointedBoxElement(to: layer, origin: adjustedOrigin, size: elementRect.size, text: element.text)
            }
            else if element.type == "rounded"
            {
                drawRoundedRectElement(to: layer, origin: adjustedOrigin, size: elementRect.size, text: element.text)
            }
        }
    }
    
    func drawDiamondElement(to layer : CALayer, origin : CGPoint, size : CGSize, text : String)
    {
        let shapeLayer = CAShapeLayer()
        let min = CGPoint(x: origin.x, y: origin.y)
        let max = CGPoint(x: origin.x + size.width, y: origin.y + size.height)
        let halfX = (max.x - min.x) / 2
        
        let start = CGPoint(x: min.x + halfX, y: min.y)
        let end = CGPoint(x: min.x + halfX, y: max.y)
        
        let diamond = UIBezierPath.diamond(from: start, to: end)
        shapeLayer.path = diamond.cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = elementColor.cgColor
        shapeLayer.lineWidth = 1.0
        
        let gridSize = self.size
        shapeLayer.contentsRect = CGRect(x: 0, y: 0, width: gridSize.width, height: gridSize.height)
        layer.addSublayer(shapeLayer)
        
        let center = CGPoint(x: origin.x + size.width/2, y: origin.y + size.height/2)
        
        drawTextElement(to: layer, at: center, str: text)
        
    }
    
    func drawBoxElement(to layer : CALayer, origin : CGPoint, size : CGSize, text : String)
    {
        let shapeLayer = CAShapeLayer()
        let min = CGPoint(x: origin.x, y: origin.y)
        let max = CGPoint(x: origin.x + size.width, y: origin.y + size.height)
        
        let rectangle = UIBezierPath.rect(from: min, to: max)
        shapeLayer.path = rectangle.cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = elementColor.cgColor
        shapeLayer.lineWidth = 1.0
        
        layer.addSublayer(shapeLayer)
        
        let center = CGPoint(x: origin.x + size.width/2, y: origin.y + size.height/2)
        
        drawTextElement(to: layer, at: center, str: text)
    }
    
    func drawPointedBoxElement(to layer : CALayer, origin : CGPoint, size : CGSize, text : String)
    {
        let shapeLayer = CAShapeLayer()
        let min = CGPoint(x: origin.x, y: origin.y)
        let max = CGPoint(x: origin.x + size.width, y: origin.y + size.height)
        
        let rectangle = UIBezierPath.pointed_box(from: min, to: max)
        shapeLayer.path = rectangle.cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = elementColor.cgColor
        shapeLayer.lineWidth = 1.0
        
        layer.addSublayer(shapeLayer)
        let center = CGPoint(x: origin.x + size.width/2, y: origin.y + size.height*0.35)
        
        drawTextElement(to: layer, at: center, str: text)
    }
    
    func drawRoundedRectElement(to layer : CALayer, origin : CGPoint, size : CGSize, text : String)
    {
        let shapeLayer = CAShapeLayer()
        let min = CGPoint(x: origin.x, y: origin.y)
        let rect = CGRect(origin: min, size: size )
        
        let rectangle = UIBezierPath(roundedRect: rect, cornerRadius: 14)
        shapeLayer.path = rectangle.cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = elementColor.cgColor
        shapeLayer.lineWidth = 1.0
        
        layer.addSublayer(shapeLayer)
        
        let center = CGPoint(x: origin.x + size.width/2, y: origin.y + size.height/2)
        
        drawTextElement(to: layer, at: center, str: text)
    }
    
    func drawArrowElement(to layer : CALayer, start : CGPoint, end : CGPoint, text : String)
    {
        let shapeLayer = CAShapeLayer()
        
        let arrow = UIBezierPath.arrow(from: start, to: end, tailWidth: 1, headWidth: 10, headLength: 10)
        
        shapeLayer.path = arrow.cgPath
        shapeLayer.strokeColor = arrowColor.cgColor
        shapeLayer.fillColor = arrowColor.cgColor
        shapeLayer.lineWidth = 1.0
        
        layer.addSublayer(shapeLayer)
        
        var textOffset : CGFloat = 7.5
        
        let centerX = start.x + (end.x - start.x)/2
        let centerY = start.y + (end.y - start.y)/2
        
        let arrowCenter = CGPoint(x : centerX, y : centerY)
        
        if( text != "") {
            let lineVector = CGPoint(x: end.x - start.x, y: end.y - start.y)
            var perpVector = getPerpendicularVector(vec: lineVector)
            if(perpVector.x != 0)
            {
                let textBoxSize = getTextBoxSizeByString(str: text, size: textSize)
                textOffset = textOffset + textBoxSize.width / 2
            } else if( perpVector.y > 0) {
                perpVector.y = -perpVector.y
            }
            let textCenter = CGPoint(x: arrowCenter.x + perpVector.x * textOffset, y: arrowCenter.y + perpVector.y * textOffset)
            drawTextElement(to: layer, at: textCenter, str: text)
        }
    }
    
    func drawLineElement(to layer: CALayer, start : CGPoint, end : CGPoint, text : String)
    {
        let shapeLayer = CAShapeLayer()
        
        let arrow = UIBezierPath.line(from: start, to: end, lineWidth: 1)
        
        shapeLayer.path = arrow.cgPath
        shapeLayer.strokeColor = arrowColor.cgColor
        shapeLayer.fillColor = arrowColor.cgColor
        shapeLayer.lineWidth = 1.0
        
        layer.addSublayer(shapeLayer)
        
        var textOffset : CGFloat = 7.5
        
        let centerX = start.x + (end.x - start.x)/2
        let centerY = start.y + (end.y - start.y)/2
        
        let arrowCenter = CGPoint(x : centerX, y : centerY)
        
        if( text != "") {
            let lineVector = CGPoint(x: end.x - start.x, y: end.y - start.y)
            var perpVector = getPerpendicularVector(vec: lineVector)
            if(perpVector.x != 0)
            {
                let textBoxSize = getTextBoxSizeByString(str: text, size: textSize)
                textOffset = textOffset + textBoxSize.width / 2
            } else if( perpVector.y > 0) {
                perpVector.y = -perpVector.y
            }
            let textCenter = CGPoint(x: arrowCenter.x + perpVector.x * textOffset, y: arrowCenter.y + perpVector.y * textOffset)
            drawTextElement(to: layer, at: textCenter, str: text)
        }
        
    }
    
    func drawConnection(to layer: CALayer, first : Element, second : Element, connection : Connection)
    {
        var origin = first.bottom //defaults
        var insertion = second.top
        
        let entryExitStringArray : [String] = [connection.exit, connection.entry]
        let elementArray : [Element] = [first, second]
        var pointsArray : [CGPoint] = [origin, insertion]
        
        for i in 0..<2 {
            if( entryExitStringArray[i] == "top" ) {
                pointsArray[i] = elementArray[i].top
            } else if( entryExitStringArray[i] == "bottom" ) {
                pointsArray[i] = elementArray[i].bottom
            } else if( entryExitStringArray[i] == "left") {
                pointsArray[i] = elementArray[i].left
            } else {
                pointsArray[i] = elementArray[i].right
            }
        }
        
        if(((first.x == second.x) ||  ( first.y == second.y )) && connection.exit != connection.entry){ //elements are inline with each other vertically or horizontally
            drawArrowElement(to: layer, start: pointsArray[0], end:  pointsArray[1], text: connection.text)
        } else { // elements at diagonals from each other
            if( (connection.exit == "left" && connection.entry == "right") ||
                (connection.exit == "right" && connection.entry == "left"))
            {
                origin = pointsArray[0]
                insertion = pointsArray[1]
                
                let halfXDist = (insertion.x - origin.x) / 2
                
                let p1 = CGPoint(x: origin.x + halfXDist, y: origin.y)
                let p2 = CGPoint(x: origin.x + halfXDist, y: insertion.y)
                
                drawLineElement(to: layer, start: origin, end: p1, text: "")
                drawLineElement(to: layer, start: p1, end: p2, text: connection.text)
                drawArrowElement(to: layer, start: p2, end: insertion, text: "")
            }
            else if((connection.exit == "left" || connection.exit == "right") &&
                    (connection.entry == "top" || connection.entry == "bottom"))
            {
                origin = pointsArray[0]
                insertion = pointsArray[1]
                
                
                let p1 = CGPoint(x: insertion.x, y: origin.y)
                
                drawLineElement(to: layer, start: origin, end: p1, text: connection.text)
                drawArrowElement(to: layer, start: p1, end: insertion, text: "")
            }
            else if((connection.exit == "top" || connection.exit == "bottom") &&
                (connection.entry == "left" || connection.entry == "right"))
            {
                origin = pointsArray[0]
                insertion = pointsArray[1]
                
                
                let p1 = CGPoint(x: origin.x, y: insertion.y)
                
                drawLineElement(to: layer, start: origin, end: p1, text: connection.text)
                drawArrowElement(to: layer, start: p1, end: insertion, text: "")
            }
            else if((connection.exit == connection.entry) &&
                (connection.entry == "left" || connection.entry == "right"))
            {
                var offsetX : CGFloat = 0.0
                if(connection.exit == "left") {
                    offsetX = -cellBuffer.width * 2.5
                } else {
                    offsetX = cellBuffer.width * 2.5
                }
                origin = pointsArray[0]
                insertion = pointsArray[1]
                
                let p1 = CGPoint(x: origin.x + offsetX, y: origin.y)
                let p2 = CGPoint(x: origin.x + offsetX, y: insertion.y)
                
                drawLineElement(to: layer, start: origin, end: p1, text: connection.text)
                drawLineElement(to: layer, start: p1, end: p2, text: "")
                drawArrowElement(to: layer, start: p2, end: insertion, text: "")
            }
            else if((connection.exit == connection.entry) &&
                (connection.entry == "top" || connection.entry == "bottom"))
            {
                var offsetY : CGFloat = 0.0
                if(connection.exit == "top") {
                    offsetY = cellBuffer.height * 2.5
                } else {
                    offsetY = -cellBuffer.height * 2.5
                }
                origin = pointsArray[0]
                insertion = pointsArray[1]
                
                let p1 = CGPoint(x: origin.x, y: origin.y + offsetY)
                let p2 = CGPoint(x: insertion.x, y: origin.y + offsetY)
                
                drawLineElement(to: layer, start: origin, end: p1, text: connection.text)
                drawLineElement(to: layer, start: p1, end: p2, text: "")
                drawArrowElement(to: layer, start: p2, end: insertion, text: "")
            }
            else if( (second.x - first.x).magnitude >= (second.y - first.y).magnitude )
            {
                origin = pointsArray[0]
                insertion = pointsArray[1]
                
                let halfYDist = (insertion.y - origin.y) / 2
                
                
                let p1 = CGPoint(x: origin.x, y: halfYDist + origin.y)
                let p2 = CGPoint(x: insertion.x, y: halfYDist + origin.y)
                
                drawLineElement(to: layer, start: origin, end: p1, text: "")
                drawLineElement(to: layer, start: p1, end: p2, text: connection.text)
                drawArrowElement(to: layer, start: p2, end: insertion, text: "")
            }
            else
            {
                origin = first.right
                insertion = second.left
                
                let halfXDist = (insertion.x - origin.x) / 2
                
                let p1 = CGPoint(x: origin.x + halfXDist, y: origin.y)
                let p2 = CGPoint(x: insertion.x + halfXDist, y: insertion.y)
                
                drawLineElement(to: layer, start: origin, end: p1, text: "")
                drawLineElement(to: layer, start: p1, end: p2, text: connection.text)
                drawArrowElement(to: layer, start: p2, end: insertion, text: "")
            }
        }
    }
    
    func drawTextElement(to layer : CALayer, at : CGPoint, str : String)
    {
        let attString = NSAttributedString(string: str)
        let textBoxSize = getTextBoxSizeByString(str: attString)
        
        let adjustedOrigin = CGPoint(x: at.x - textBoxSize.width/2, y: at.y - textBoxSize.height/2)
        let textframe = CGRect(origin: adjustedOrigin, size: textBoxSize)
        
        let textLayer = CATextLayer()
        textLayer.frame = textframe
        textLayer.string = attString
        textLayer.isWrapped = true
        textLayer.alignmentMode = CATextLayerAlignmentMode.center
        textLayer.contentsScale = UIScreen.main.scale
        
        layer.addSublayer(textLayer)
        
    }
    
    func drawDebugBox(to layer : CALayer, origin : CGPoint, size : CGSize)
    {
        let shapeLayer = CAShapeLayer()
        
        let min = CGPoint(x: origin.x, y: origin.y)
        let max = CGPoint(x: origin.x + size.width, y: origin.y + size.height)
        
        let rectangle = UIBezierPath.rect(from: min, to: max)
        shapeLayer.path = rectangle.cgPath
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 1.0
        
        layer.addSublayer(shapeLayer)
        
    }
    
    func getTextBoxSizeByString(str : String, size : CGFloat) -> CGSize {
        let font = UIFont(name: DataManager.instance.fontName, size: size)
        let textBoxSize : CGSize = str.size(withAttributes: [.font: font!])
        return textBoxSize
    }
    
    func getTextBoxSizeByString(str : NSAttributedString) -> CGSize {
        let textBoxSize : CGSize = str.size()
        return textBoxSize
    }
    
    func getPerpendicularVector(vec : CGPoint) -> CGPoint
    {
        let lineLength = sqrt((vec.x * vec.x) + (vec.y * vec.y))
        let unitVector = CGPoint(x: vec.x / lineLength, y: vec.y / lineLength)
        return CGPoint(x: -unitVector.y, y: unitVector.x)
    }
    
    func getElementByXYIndex(x : Int, y : Int) -> Element
    {
        for element in elements {
            if(element.x == x && element.y == y)
            {
                return element
            }
        }
        return Element()
    }
}


class FlowChartScrollView : UIScrollView, UIScrollViewDelegate {

    var flowChartSize = CGSize()
    var zoomView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.decelerationRate = UIScrollView.DecelerationRate.fast
        
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.centerImage()
    }
    
    func configure()
    {
        setMaxMinZoomScaleForCurrentBounds()
        self.zoomScale = self.minimumZoomScale
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return zoomView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.centerImage()
    }
    
    func setMaxMinZoomScaleForCurrentBounds() {
        let boundsSize = self.bounds.size
        let imageSize = zoomView.frame
        
        //1. calculate minimumZoomscale
        let xScale =  boundsSize.width  / imageSize.width    // the scale needed to perfectly fit the image width-wise
        let yScale = boundsSize.height / imageSize.height  // the scale needed to perfectly fit the image height-wise
        let minScale = min(xScale, yScale)                 // use minimum of these to allow the image to become fully visible
        
        //2. calculate maximumZoomscale
        var maxScale: CGFloat = 1.0
        if minScale < 0.1 {
            maxScale = 0.3
        }
        if minScale >= 0.1 && minScale < 0.5 {
            maxScale = 0.7
        }
        if minScale >= 0.5 {
            maxScale = max(1.0, minScale)
        }
        
        self.maximumZoomScale = maxScale * 2
        self.minimumZoomScale = minScale
    }
    
    func centerImage() {
        
        // center the zoom view as it becomes smaller than the size of the screen
        let boundsSize = self.bounds.size
        var frameToCenter = zoomView.frame
        
        // center horizontally
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width + frameToCenter.size.width)/2
        }
        else {
            frameToCenter.origin.x = 0
        }
        
        // center vertically
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = 0//frameToCenter.size.height/2
        }
        else {
            frameToCenter.origin.y = 0
        }
        
        zoomView.frame = frameToCenter
    }
}

