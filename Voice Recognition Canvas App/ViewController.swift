//
//  ViewController.swift
//  Voice Recognition Canvas App
//
//  Created by Anupreet Paulkar on 6/6/22.
//

import UIKit
import PencilKit

// A view controller acts as an intermediary between the views it manages and the data of your app.
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
            toolPicker.addObserver(canvasView)
            toolPicker.setVisible(true, forFirstResponder: canvasView)
            canvasView.becomeFirstResponder()

    }
    
    @IBAction func clearCanvas(_ sender: UIBarButtonItem) {
        canvasView.drawing = PKDrawing()
    }
    @IBAction func saveToPhotos(_ sender: UIBarButtonItem) {
        let imgVC = self.storyboard?.instantiateViewController(withIdentifier: "ImgViewController") as? ImgViewController
        let image = UIGraphicsImageRenderer(bounds: canvasView.bounds).image { _ in
            view.drawHierarchy(in: canvasView.bounds, afterScreenUpdates: true)
        }
        imgVC?.image = image
        self.navigationController?.pushViewController(imgVC!, animated: true)
    }
}

