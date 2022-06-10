//
//  ViewController.swift
//  Voice Recognition Canvas App
//
//  Created by Anupreet Paulkar
import UIKit
import PencilKit
import PhotosUI
import InstantSearchVoiceOverlay
import Speech

// A view controller acts as an intermediary between the views it manages and the data of your app.
class ViewController: UIViewController, UITextViewDelegate, SFSpeechRecognizerDelegate {
    
    let placeHolder = "Text here"
    
    @IBOutlet var textView: UITextView!
    
    @IBOutlet weak var voiceButton: UIBarButtonItem!
    
    // local properties
    
       let audioEngine = AVAudioEngine()
       let speechReconizer : SFSpeechRecognizer? = SFSpeechRecognizer()
       let request = SFSpeechAudioBufferRecognitionRequest()
       var task : SFSpeechRecognitionTask!
       var isStart : Bool = false
    
 // (remember)
    let toolPicker = PKToolPicker.init()
    @IBOutlet weak var canvasView: PKCanvasView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        voiceButton.backgroundColor = .systemCyan
//        voiceButton.setTitleColor(.white, for: .normal)
        textView.delegate = self
        textView.text = placeHolder
        textView.textColor = .lightGray
        
        requestPersmission()
    }
    
    @IBAction func btn_startStop(_ sender: Any) {
        
        isStart = !isStart
        
        if isStart {
            startSpeechRecognization()
        } else {
            cancelSpeechRecognization()
        }
    }
    
    func requestPersmission() {
        self.voiceButton.isEnabled = false
        SFSpeechRecognizer.requestAuthorization {(authState) in
            OperationQueue.main.addOperation {
                if authState == .authorized {
                    print("Authorized")
                    self.voiceButton.isEnabled = true
                } else if authState == .denied {
                    self.alertView(message: "User access denied")
                } else if authState == .notDetermined {
                    self.alertView(message: "No svoice recognition available")
                } else if authState == .restricted {
                    self.alertView(message: "Access restricted")
                }
            }
        }
    }
    
    func startSpeechRecognization(){
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.request.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch let error {
            alertView(message: "Error comes here for starting the audio listner =\(error.localizedDescription)")
        }
        
        guard let myRecognization = SFSpeechRecognizer() else {
            self.alertView(message: "Recognization is not allow on your local")
            return
        }
        
        if !myRecognization.isAvailable {
            self.alertView(message: "Recognization is free right now, Please try again after some time.")
        }
        
        task = speechReconizer?.recognitionTask(with: request, resultHandler: { (response, error) in
            guard let response = response else {
                if error != nil {
                    self.alertView(message: error.debugDescription)
                }else {
                    self.alertView(message: "Problem in giving the response")
                }
                return
            }
            
            let message = response.bestTranscription.formattedString
            print("Message : \(message)")
            self.textView.text = message
            
            
//            var lastString: String = ""
//            for segment in response.bestTranscription.segments {
//                let indexTo = message.index(message.startIndex, offsetBy: segment.substringRange.location)
//                lastString = String(message[indexTo...])
//            }
                        
        })
    }
    
    
    func cancelSpeechRecognization() {
        task.finish()
        task.cancel()
        task = nil
        
        request.endAudio()
        audioEngine.stop()
        //audioEngine.inputNode.removeTap(onBus: 0)
        
        //MARK: UPDATED
        if audioEngine.inputNode.numberOfInputs > 0 {
            audioEngine.inputNode.removeTap(onBus: 0)
        }
    }
    
    
    
    func alertView(message:String){
        let controller = UIAlertController.init(title:"Error ocured ...!", message: message,
            preferredStyle:.alert)
        controller.addAction(UIAlertAction(title: "OK",style: .default, handler:{ (_)in
            controller.dismiss(animated:true,completion:nil)
        }))
        self.present(controller,animated:true,completion:nil)
    }
    
    
    
    // ---------->>>>
    
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
