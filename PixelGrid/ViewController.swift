//
//  ViewController.swift
//  PixelGrid
//
//  Created by Ole Begemann on 23/09/14.
//  Copyright (c) 2014 Ole Begemann. All rights reserved.
//

import UIKit

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

    func updateUI() {
        self.scaleFactorLabel.text = "scaleFactor \(pixelGridView.renderScaleFactor)"
        self.boundsLabel.text = "bounds: \(pixelGridView.bounds)"
        self.pixelRectLabel.text = "pixelRect: \(pixelGridView.pixelRect)"
        self.lineWidthLabel.text = "lineWidth: \(pixelGridView.lineWidth)"
    }

    func pixelGridViewDidRedraw(view: PixelGridView) {
        updateUI()
    }
}

