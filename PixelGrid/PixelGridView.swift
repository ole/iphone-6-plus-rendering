//
//  PixelGridView.swift
//  PixelGrid
//
//  Created by Ole Begemann on 23/09/14.
//  Copyright (c) 2014 Ole Begemann. All rights reserved.
//

import UIKit

enum RenderingMode {
    case LogicalPixels
    case NativePixels
}

@IBDesignable
class PixelGridView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .Redraw
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentMode = .Redraw
    }
    
    let lineColor = UIColor.blackColor()
    var renderingMode: RenderingMode = RenderingMode.LogicalPixels {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        
        let scaleFactor = renderScaleFactor
        let upscaleTransform = CGAffineTransformMakeScale(scaleFactor, scaleFactor)
        let downscaleTransform = CGAffineTransformInvert(upscaleTransform)
        let pixelRect = CGRectApplyAffineTransform(self.bounds, upscaleTransform)

        let path = UIBezierPath()
        
        for x in stride(from: CGRectGetMinX(pixelRect), through: CGRectGetMaxX(pixelRect), by: 2) {
            let lineCenterX = x + 0.5
            let startPoint = CGPoint(x: lineCenterX, y: CGRectGetMinY(pixelRect))
            let endPoint = CGPoint(x: lineCenterX, y: CGRectGetMaxY(pixelRect))
            path.moveToPoint(startPoint)
            path.addLineToPoint(endPoint)
        }
        
        for y in stride(from: CGRectGetMinY(pixelRect), through: CGRectGetMaxY(pixelRect), by: 2) {
            let lineCenterY = y + 0.5
            let startPoint = CGPoint(x: CGRectGetMinX(pixelRect), y: lineCenterY)
            let endPoint = CGPoint(x: CGRectGetMaxX(pixelRect), y: lineCenterY)
            path.moveToPoint(startPoint)
            path.addLineToPoint(endPoint)
        }
        
        lineColor.setStroke()

        let lineWidth = 1.0 / scaleFactor
        path.lineWidth = lineWidth
        path.applyTransform(downscaleTransform)
        path.stroke()

        println("bounds: \(bounds)")
        println("pixelRect: \(pixelRect)")
        println("lineWidth: \(lineWidth)")
    }

    var renderScaleFactor: CGFloat {
        if renderingMode == .NativePixels {
            return window?.screen.nativeScale ?? contentScaleFactor
        } else {
            return contentScaleFactor
            }
    }
    
}
