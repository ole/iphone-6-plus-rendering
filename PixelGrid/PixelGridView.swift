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
        
        for i in stride(from: CGRectGetMinX(pixelRect), through: CGRectGetMaxX(pixelRect), by: 2) {
            path.moveToPoint(CGPoint(x: i + 0.5, y: CGRectGetMinY(pixelRect)))
            path.addLineToPoint(CGPoint(x: i + 0.5, y: CGRectGetMaxY(pixelRect)))
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
