//
//  ViewController.swift
//  Voice Recognition Canvas App
//
//  Created by Anupreet Paulkar on 6/6/22.
//

import UIKit
import PencilKit

class ViewController: UIViewController {

 // (remember)
    let toolPicker = PKToolPicker.init()
    @IBOutlet weak var canvasView: PKCanvasView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // Notifies the view controller that its view is about to be added to a view hierarchy.

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setCanvasView()
    }
    
    private func setCanvasView(){
// (deprecated in xcode 12)       if let window = view.window, let toolPicker = PKToolPicker.shared(for: window) {
//            toolPicker.addObserver(canvasView)
//            toolPicker.setVisible(true, forFirstResponder: canvasView)
//            canvasView.becomeFirstResponder()
            toolPicker.setVisible(true, forFirstResponder: canvasView)
            toolPicker.addObserver(canvasView)
            canvasView.becomeFirstResponder()
//        }
    }
    
    @IBAction func clearCanvas(_ sender: UIBarButtonItem) {
    }
    @IBAction func saveToPhotos(_ sender: UIBarButtonItem) {
    }
}

