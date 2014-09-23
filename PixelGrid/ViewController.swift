//
//  ViewController.swift
//  PixelGrid
//
//  Created by Ole Begemann on 23/09/14.
//  Copyright (c) 2014 Ole Begemann. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var pixelGridView: PixelGridView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func selectRenderingMode(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: pixelGridView.renderingMode = .LogicalPixels
        case 1: pixelGridView.renderingMode = .NativePixels
        default: NSException(name: NSInternalInconsistencyException, reason: "Execution should never reach this point", userInfo: nil).raise()
        }
    }

}

