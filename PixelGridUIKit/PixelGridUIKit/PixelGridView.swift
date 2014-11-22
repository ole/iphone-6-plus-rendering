//
//  PixelGridView.swift
//  PixelGridUIKit
//
//  Created by Ole Begemann on 23/09/14.
//  Copyright (c) 2014 Ole Begemann. All rights reserved.
//

import UIKit

enum RenderingMode {
    case LogicalPixels // Render to the "logical" pixel resolution (i.e. 3x on the iPhone 6 Plus)
    case NativePixels  // Try to render to "hardware" pixel resolution (i.e. with screen.nativeScale on the iPhone 6 Plus)
}

@objc protocol PixelGridViewDelegate: NSObjectProtocol {
    func pixelGridViewDidRedraw(view: PixelGridView)
}

@IBDesignable
class PixelGridView: UIView {

    @IBOutlet weak var delegate: PixelGridViewDelegate? = nil

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .Redraw
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    let lineColor = UIColor.greenColor()
    
    var renderingMode: RenderingMode = RenderingMode.LogicalPixels {
        didSet {
            setNeedsDisplay()
        }
    }

    var renderScaleFactor: CGFloat {
        if renderingMode == .NativePixels {
            return window?.screen.nativeScale ?? contentScaleFactor
        } else {
            return contentScaleFactor
        }
    }

    // For 1-pixel lines, line width should be 1.0/scaleFactor points
    var lineWidth: CGFloat {
        return 1.0/renderScaleFactor
    }

    // The bounds rect in (logical or hardware) pixels, depending on the rendering mode
    var pixelRect: CGRect {
        let pixelRect = CGRectApplyAffineTransform(self.bounds, upscaleTransform)
        return pixelRect
    }

    // Scales from points to pixels
    var upscaleTransform: CGAffineTransform {
        let scaleFactor = renderScaleFactor
        return CGAffineTransformMakeScale(scaleFactor, scaleFactor)
    }
    
    // Scales from pixels to points
    var downscaleTransform: CGAffineTransform {
        return CGAffineTransformInvert(upscaleTransform)
    }
    
    // Renders the view contents into an image of size pixelRect pixels with lineWidth = 1 px
    func renderToImage() -> UIImage {
        let path = pixelGridPath()
        path.lineWidth = 1.0

        UIGraphicsBeginImageContextWithOptions(pixelRect.size, true, 1.0)
        lineColor.setStroke()
        path.stroke()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
    
    // Constructs the pixel grid that the view should draw.
    // For convenience, the path returned by this method uses the pixelRect as its coordinate system
    // (i.e. 1242x2208 (logical pixels) or 1080x1920 (native pixels) on the iPhone 6 Plus).
    // This means we can construct the path by iterating over whole pixels and use a line offset of 0.5
    // to align lines on whole pixels.
    // Before drawing, the path returned by this method gets scaled down to the view's coordinate system
    // with downscaleTransform.
    func pixelGridPath() -> UIBezierPath {
        let path = UIBezierPath()
        
        let lineOffset: CGFloat = 0.5
        
        var step: CGFloat = 2.0
        var i = 0

        // Comment out one of these options for the actual drawing:
        
        // Option 1: draw a grid of vertical lines with varying spacing
        var x = CGRectGetMinX(pixelRect)
        while x <= CGRectGetMaxX(pixelRect) {
            let lineCenterX = x + lineOffset
            let startPoint = CGPoint(x: lineCenterX, y: CGRectGetMinY(pixelRect))
            let endPoint = CGPoint(x: lineCenterX, y: CGRectGetMaxY(pixelRect))
            path.moveToPoint(startPoint)
            path.addLineToPoint(endPoint)
            
            ++i
            if (i % 30 == 0) {
                step *= 2
            }
            x += step
        }
        // End option 1
        
        // Option 2: draw a grid of vertical lines with 1-pixel spacing in between
//        for x in stride(from: CGRectGetMinX(pixelRect), through: CGRectGetMaxX(pixelRect), by: 2) {
//            let lineCenterX = x + lineOffset
//            let startPoint = CGPoint(x: lineCenterX, y: CGRectGetMinY(pixelRect))
//            let endPoint = CGPoint(x: lineCenterX, y: CGRectGetMaxY(pixelRect))
//            path.moveToPoint(startPoint)
//            path.addLineToPoint(endPoint)
//        }
//
//        for y in stride(from: CGRectGetMinY(pixelRect), through: CGRectGetMaxY(pixelRect), by: 2) {
//            let lineCenterY = y + lineOffset
//            let startPoint = CGPoint(x: CGRectGetMinX(pixelRect), y: lineCenterY)
//            let endPoint = CGPoint(x: CGRectGetMaxX(pixelRect), y: lineCenterY)
//            path.moveToPoint(startPoint)
//            path.addLineToPoint(endPoint)
//        }
        // End option 2
        
        return path
    }
    
    override func drawRect(rect: CGRect) {
        let path = pixelGridPath()
        
        path.lineWidth = lineWidth
        path.applyTransform(downscaleTransform)

        lineColor.setStroke()
        path.stroke()

        delegate?.pixelGridViewDidRedraw(self)
    }
}
