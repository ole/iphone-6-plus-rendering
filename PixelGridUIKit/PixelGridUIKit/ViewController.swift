//
//  ViewController.swift
//  PixelGridUIKit
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pixelGridView.delegate = self
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

    @IBAction func selectGridVariant(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: pixelGridView.gridVariant = .VariableSpacing
        case 1: pixelGridView.gridVariant = .TightSpacing
        default: NSException(name: NSInternalInconsistencyException, reason: "Execution should never reach this point", userInfo: nil).raise()
        }
    }
    
    func updateUI() {
        scaleFactorLabel.text = "scaleFactor \(pixelGridView.renderScaleFactor)"
        boundsLabel.text = "bounds: \(pixelGridView.bounds)"
        pixelRectLabel.text = "pixelRect: \(pixelGridView.pixelRect)"
        lineWidthLabel.text = "lineWidth: \(pixelGridView.lineWidth)"
    }

    func pixelGridViewDidRedraw(view: PixelGridView) {
        updateUI()
    }

    @IBAction func renderToImage(sender: AnyObject) {
        let image = pixelGridView.renderToImage()
        
        let assetsLibrary = ALAssetsLibrary()
        assetsLibrary.writeImageDataToSavedPhotosAlbum(UIImagePNGRepresentation(image), metadata: nil) { (url, error) -> Void in
            if let error = error {
                let alert = UIAlertController(title: "Save Error", message: error.localizedDescription, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Close", style: .Default, handler: { (action) -> Void in self.dismissViewControllerAnimated(true, completion: nil) }))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
}

