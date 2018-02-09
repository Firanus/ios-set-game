//
//  SetCardView.swift
//  Set
//
//  Created by Ivan Tchernev on 30/01/2018.
//  Copyright © 2018 AND Digital. All rights reserved.
//

import UIKit

@IBDesignable
class SetCardView: UIView
{
    private enum CardOrientation {
        case vertical
        case horizontal
    }
    
    enum CardShading {
        case outline
        case striped
        case solid
    }
    
    enum CardShape {
        case diamond
        case squiggle
        case oval
    }
    
    var color: UIColor = UIColor.red  { didSet { setNeedsDisplay() } }
    var shading: CardShading = .striped  { didSet { setNeedsDisplay() } }
    var shape: CardShape = .oval  { didSet { setNeedsDisplay() } }
    var number: Int = 3 { didSet { setNeedsDisplay() } }
    
    var selectedColor: UIColor? = nil { didSet { setNeedsDisplay() } }
    
    private var orientation: CardOrientation {
        if bounds.height > bounds.width {
            return .vertical
        } else {
            return .horizontal
        }
    }
    
    override func draw(_ rect: CGRect) {
        createCardBack()
        createShapes()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setNeedsDisplay()
    }
    
    private func createCardBack() {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        
        if let outlineColor = selectedColor {
            roundedRect.lineWidth = 5.0
            outlineColor.setStroke()
            roundedRect.stroke()
        }
    }
    private func createShapes() {
        
        let maxDrawableArea = CGRect(x: bounds.minX + borderWidth, y: bounds.minY + borderHeight, width: bounds.width - (2 * borderWidth), height: bounds.height - (2 * borderHeight))
        
        let drawingAreas = createDrawingAreas(number: number, inDrawableZone: maxDrawableArea)
        for area in drawingAreas {
            var path: UIBezierPath
            
            switch shape {
            case .diamond:
                path = makeDiamond(inDrawingArea: area)
            case .oval:
                path = makeOval(inDrawingArea: area)
            case .squiggle:
                path = makeSquiggle(inDrawingArea: area)
            }
            
            switch shading {
            case .outline:
                outline(shape: path, withColor: color)
            case .solid:
                fill(shape: path, withColor: color)
            case .striped:
                stripe(shape: path, withColor: color)
            }
        }
    }
    
    private func createDrawingAreas(number: Int, inDrawableZone maxDrawableArea: CGRect) -> [CGRect] {
        let xDefaultCoordinate = maxDrawableArea.minX + internalBorderWidth
        let yDefaultCoordinate = maxDrawableArea.minY + internalBorderHeight
        
        var shapeHeight: CGFloat = 0
        var shapeWidth: CGFloat = 0
        var longestCardSide: CGFloat = 0
        switch orientation {
        case .vertical:
            longestCardSide = maxDrawableArea.height
            shapeHeight = (maxDrawableArea.height / 3) - (2 * internalBorderHeight)
            shapeWidth = maxDrawableArea.width - (2 * internalBorderWidth)
        case.horizontal:
            longestCardSide = maxDrawableArea.width
            shapeHeight = maxDrawableArea.height - (2 * internalBorderHeight)
            shapeWidth = (maxDrawableArea.width / 3) - (2 * internalBorderWidth)
        }
        
        var startingPointProportions = [CGFloat]()
        switch number {
        case 1:
            startingPointProportions = [CGFloat(1.0/3)]
        case 2:
            startingPointProportions = [CGFloat(1.0/6), CGFloat(1.0/2)]
        case 3:
            startingPointProportions = [CGFloat(0), CGFloat(1.0/3), CGFloat(2.0/3)]
        default:
            break
        }
        var drawingAreas = [CGRect]()
        for startingPoint in startingPointProportions {
            var shapeArea = CGRect.zero
            switch orientation {
            case .vertical:
                shapeArea = CGRect(x: xDefaultCoordinate, y: yDefaultCoordinate + (startingPoint * longestCardSide), width: shapeWidth, height: shapeHeight)
            case .horizontal:
                shapeArea = CGRect(x: xDefaultCoordinate + (startingPoint * longestCardSide), y: yDefaultCoordinate, width: shapeWidth, height: shapeHeight)
                
            }
            drawingAreas.append(shapeArea)
        }
        return drawingAreas
    }
 
    private func makeOval(inDrawingArea drawingRect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 10, y: 10))
        path.addLine(to: CGPoint(x: 30, y: 10))
        path.addArc(withCenter: CGPoint(x: 30, y: 20), radius: 10, startAngle: -CGFloat.pi / 2, endAngle: CGFloat.pi / 2, clockwise: true)
        path.addLine(to: CGPoint(x: 10, y: 30))
        path.addArc(withCenter: CGPoint(x: 10, y: 20), radius: 10, startAngle: CGFloat.pi / 2, endAngle: -CGFloat.pi / 2, clockwise: true)
        
        scaleAndTranslateShape(drawingRect, path)
        return path
    }
    
    private func makeSquiggle(inDrawingArea drawingRect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()

        path.move(to: CGPoint(x: 104, y: 15));
        path.addCurve(to: CGPoint(x: 63, y: 54), controlPoint1: CGPoint(x: 112.4, y: 36.9), controlPoint2: CGPoint(x: 89.7, y: 60.8))
        path.addCurve(to: CGPoint(x: 27, y: 53), controlPoint1: CGPoint(x: 52.3, y: 51.3), controlPoint2: CGPoint(x: 42.2, y: 42))
        path.addCurve(to: CGPoint(x: 5, y: 40), controlPoint1: CGPoint(x: 9.6, y: 65.6), controlPoint2: CGPoint(x: 5.4, y: 58.3))
        path.addCurve(to: CGPoint(x: 36, y: 12), controlPoint1: CGPoint(x: 4.6, y: 22), controlPoint2: CGPoint(x: 19.1, y: 9.7))
        path.addCurve(to: CGPoint(x: 89, y: 14), controlPoint1: CGPoint(x: 59.2, y: 15.2), controlPoint2: CGPoint(x: 61.9, y: 31.5))
        path.addCurve(to: CGPoint(x: 104, y: 15), controlPoint1: CGPoint(x: 95.3, y: 10), controlPoint2: CGPoint(x: 100.9, y: 6.9))

        scaleAndTranslateShape(drawingRect, path)
        return path
    }
    
    private func makeDiamond(inDrawingArea drawingRect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: drawingRect.minX, y: drawingRect.midY))
        path.addLine(to: CGPoint(x: drawingRect.midX, y: drawingRect.minY))
        path.addLine(to: CGPoint(x: drawingRect.maxX, y: drawingRect.midY))
        path.addLine(to: CGPoint(x: drawingRect.midX, y: drawingRect.maxY))
        path.addLine(to: CGPoint(x: drawingRect.minX, y: drawingRect.midY))
        return path
    }
    
    private func scaleAndTranslateShape(_ drawingRect: CGRect, _ path: UIBezierPath) {
        var scaleFactor: CGFloat = 0.0
        switch orientation {
        case .vertical:
            scaleFactor = drawingRect.height / path.bounds.height
            path.apply(CGAffineTransform(scaleX: scaleFactor, y: scaleFactor))
            if path.bounds.width > drawingRect.width {
                scaleFactor = drawingRect.width / path.bounds.width
                path.apply(CGAffineTransform(scaleX: scaleFactor, y: scaleFactor))
            }
        case .horizontal:
            path.apply(CGAffineTransform(rotationAngle: CGFloat.pi / 2))
            scaleFactor = drawingRect.width / path.bounds.width
            path.apply(CGAffineTransform(scaleX: scaleFactor, y: scaleFactor))
            if path.bounds.height > drawingRect.height {
                scaleFactor = drawingRect.height / path.bounds.height
                path.apply(CGAffineTransform(scaleX: scaleFactor, y: scaleFactor))
            }
        }
        
        path.apply(CGAffineTransform(translationX: drawingRect.midX - path.bounds.width / 2 - path.bounds.minX, y: drawingRect.midY - path.bounds.height / 2 - path.bounds.minY))
    }
    
    private func outline(shape path: UIBezierPath, withColor color: UIColor){
        path.lineWidth = 2.0
        color.setStroke()
        path.stroke()
    }
    
    private func fill(shape path: UIBezierPath, withColor color: UIColor) {
        color.setFill()
        path.fill()
    }
    
    private func stripe(shape path: UIBezierPath, withColor color: UIColor) {
        outline(shape: path, withColor: color)
        
        //This is necessary to have multiple striped shapes.
        let context = UIGraphicsGetCurrentContext()!
        context.saveGState()
        
        path.addClip()
        for x in stride(from: path.bounds.minX, to: path.bounds.maxX, by: 3) {
            path.move(to: CGPoint(x: x, y: path.bounds.minY))
            path.addLine(to: CGPoint(x: x, y: path.bounds.maxY))
        }
        path.lineWidth = 1.0
        color.setStroke()
        path.stroke()
        
        context.restoreGState()
    }
}

extension SetCardView {
    private struct SizeRatio {
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cardBorderToBoundsRatio: CGFloat = 0.1
        static let internalBorderToBoundsRatio: CGFloat = 0.025
    }
    
    private var cornerRadius: CGFloat {
        return SizeRatio.cornerRadiusToBoundsHeight * bounds.height
    }
    
    private var borderHeight: CGFloat {
        return SizeRatio.cardBorderToBoundsRatio * bounds.height
    }
    
    private var borderWidth: CGFloat {
        return SizeRatio.cardBorderToBoundsRatio * bounds.width
    }
    
    private var internalBorderHeight: CGFloat {
        return SizeRatio.internalBorderToBoundsRatio * bounds.height
    }
    
    private var internalBorderWidth: CGFloat {
        return SizeRatio.internalBorderToBoundsRatio * bounds.width
    }
}
