//
//  ViewController.swift
//  PixelGrid
//
//  Created by Ole Begemann on 23/09/14.
//  Copyright (c) 2014 Ole Begemann. All rights reserved.
//

import UIKit
import AssetsLibrary
import Swift

class ViewController: UIViewController, PixelGridViewDelegate {

    @IBOutlet weak var pixelGridView: PixelGridView!
    @IBOutlet weak var scaleFactorLabel: UILabel!
    @IBOutlet weak var boundsLabel: UILabel!
    @IBOutlet weak var pixelRectLabel: UILabel!
    @IBOutlet weak var lineWidthLabel: UILabel!
    @IBOutlet weak var lineOffsetLabel: UILabel!
    @IBOutlet weak var lineOffsetSlider: UISlider!
    @IBOutlet weak var lineWidthSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pixelGridView.delegate = self
        resetLineWidth(self)
        resetLineOffset(self)
        updateUI()
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    @IBAction func selectRenderingMode(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: pixelGridView.renderingMode = .LogicalPixels
        case 1: pixelGridView.renderingMode = .NativePixels
        default: NSException(name: NSInternalInconsistencyException, reason: "Execution should never reach this point", userInfo: nil).raise()
        }
    }

    func updateUI() {
        scaleFactorLabel.text = "scaleFactor \(pixelGridView.renderScaleFactor)"
        boundsLabel.text = "bounds: \(pixelGridView.bounds)"
        pixelRectLabel.text = "pixelRect: \(pixelGridView.pixelRect)"
        lineWidthLabel.text = "lineWidth: \(pixelGridView.lineWidth)"
        lineOffsetLabel.text = "lineOffset: \(pixelGridView.lineOffset)"
    }

    func pixelGridViewDidRedraw(view: PixelGridView) {
        updateUI()
    }
    
    @IBAction func resetLineWidth(sender: AnyObject) {
        let lineWidth = 1.0 / pixelGridView.renderScaleFactor
        pixelGridView.lineWidth = lineWidth
        lineWidthSlider.value = Float(lineWidth)
    }
    
    @IBAction func lineWidthSliderChanged(sender: AnyObject) {
        pixelGridView.lineWidth = CGFloat(lineWidthSlider.value)
    }
    
    @IBAction func resetLineOffset(sender: AnyObject) {
        let lineOffset = 0.5
        pixelGridView.lineOffset = CGFloat(lineOffset)
        lineOffsetSlider.value = Float(lineOffset)
    }
    
    @IBAction func lineOffsetSliderChanged(sender: AnyObject) {
        pixelGridView.lineOffset = CGFloat(lineOffsetSlider.value)
    }

    @IBAction func renderToImage(sender: AnyObject) {
        let image = pixelGridView.renderToImage()
        
        let assetsLibrary = ALAssetsLibrary()
        assetsLibrary.writeImageDataToSavedPhotosAlbum(UIImagePNGRepresentation(image), metadata: nil) { (url, error) -> Void in
            if let error = error {
                println("Error saving image: \(error)")
            } else {
                println("Image URL: \(url)")
            }
        }
    }
}

