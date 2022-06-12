//
//  ViewController.swift
//  Voice Recognition Canvas App
//
//  Created by Anupreet Paulkar


import UIKit
import PencilKit
import PhotosUI
import InstantSearchVoiceOverlay

// A view controller acts as an intermediary between the views it manages and the data of your app.
class ViewController: UIViewController, VoiceOverlayDelegate, UITextViewDelegate {
    
    let placeHolder = "Text here"
    
    @IBOutlet var textView: UITextView!
    
    let voiceOverlay = VoiceOverlayController()
    @IBOutlet var voiceButton: UIButton!
 // (remember)
    let toolPicker = PKToolPicker.init()
    @IBOutlet weak var canvasView: PKCanvasView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        voiceButton.backgroundColor = .systemCyan
//        voiceButton.setTitleColor(.white, for: .normal)
        
    // self.textView.delegate = self
        
        textView.delegate = self
        textView.text = placeHolder
        textView.textColor = .lightGray
        
    }

//    // Hide keyboard when user touches outside keyboar
//    override func touchesBegan(_ touches: Set<UITouch>, with event : UIEvent?) {
//    self.view.endEditing(true)
//    }
//    // Presses return key
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//    textField.resignFirstResponder()
//    return (true)
//    }
    
    // ----------------->>>>>>>> FOR UI TOUCH STATUS
    
    override func touchesBegan(_ touches : Set<UITouch> , with event : UIEvent?) {
    super.touchesBegan(touches , with: event)
        let touch = touches.first!
        let location = touch.location(in: view)
    print("touches began \(location)" )
    }
    
    override func touchesMoved(_ touches : Set<UITouch> , with event: UIEvent?) {
    super.touchesMoved (touches , with: event )
    print ( "touches moved" )
    }
    
    override func touchesEnded(_ touches : Set<UITouch> , with event : UIEvent?) {
    super.touchesEnded(touches , with: event)
    print ( "touches ended" )
    }
    
    override func touchesCancelled(_ touches : Set<UITouch> , with event: UIEvent?) {
    super.touchesCancelled (touches , with: event )
    print ("touches cancelled")
    }
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray
        {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""
        {
            textView.text = placeHolder
            textView.textColor = .lightGray
        }
    }
    
    @IBAction func didTapButton() {
        voiceOverlay.delegate = self
        voiceOverlay.settings.autoStart = false
        voiceOverlay.settings.autoStop = true
        voiceOverlay.settings.autoStopTimeout = 3

        voiceOverlay.start(on: self, textHandler: {
            text, final, _ in
            if final  {
                print("Final text: \(text)")
            } else {
               // print("In progress: \(text)")
            }
        }, errorHandler: {
            error in
        })
    }
    
    func recording(text: String?, final: Bool?, error: Error?) {
        
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
        
        UIGraphicsBeginImageContextWithOptions(canvasView.bounds.size, false, UIScreen.main.scale)
        
        canvasView.drawHierarchy(in: canvasView.bounds, afterScreenUpdates: true)
        
        let imageSave = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if imageSave != nil{
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: imageSave!)
            }, completionHandler: {success, error in
                
            })
        }
    }
     
}
