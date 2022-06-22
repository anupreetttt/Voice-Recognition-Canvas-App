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
class ViewController: UIViewController, VoiceOverlayDelegate, UITextViewDelegate, UIGestureRecognizerDelegate {
    
    let placeHolder = "Text here"
    
    @IBOutlet var textView: UITextView!
    
    let voiceOverlay = VoiceOverlayController()
    @IBOutlet var voiceButton: UIButton!
 // (remember)
    let toolPicker = PKToolPicker.init() // initializing PKToolPicker
    @IBOutlet weak var canvasView: PKCanvasView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        voiceButton.backgroundColor = .systemCyan
//        voiceButton.setTitleColor(.white, for: .normal)
        

    // self.textView.delegate = self
        
        textView.delegate = self // to the object itself
        textView.text = placeHolder
        textView.textColor = .lightGray
        
//        let date = NSDate()
//        let formatDate = DateFormatter()
//        formatDate.dateFormat = "MM-dd-yyyy"
//        let dateString = formatDate.string(from: date as Date)
//        print(dateString)
//
//        let stringDate = "06/12/2022"
//        formatDate.dateFormat = "MM/dd/yyyy"
//        formatDate.timeZone = NSTimeZone(abbreviation: "GMT +0:00") as TimeZone?
//        let dateFromString = formatDate.date(from: stringDate)
//        print (dateFromString!)
//
//        // Gets the current date and time :
//        let currentDateTime = Date ()
//        // Initializes the date formatter and set the style :
//        let formatter = DateFormatter ()
//        formatter.timeStyle = .medium
//        formatter.dateStyle = .long
//        // Gets the date and time String from the date object :
//        let dateTimeString = formatter.string ( from : currentDateTime )
//        // Displays it on the label :
//        print(dateTimeString)
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
    
    //-------->>> For touch input
//    @objc func touchedScreen(touch: UITapGestureRecognizer) {
//        let touchPoint = touch.location(in: self.view)
//        print(touchPoint)
//    }

    func showMoreActions(touch: UITapGestureRecognizer) {

        let touchPoint = touch.location(in: self.view)
        let DynamicView = UIView(frame: CGRect(x: touchPoint.x, y: touchPoint.y, width: 100, height: 100))
        DynamicView.backgroundColor=UIColor.green
          DynamicView.layer.cornerRadius = 25
          DynamicView.layer.borderWidth = 2
          self.view.addSubview(DynamicView)
        print(touchPoint)
  }
    
    // ----------------->>>>>>>> FOR UI TOUCH STATUS
    
    override func touchesBegan(_ touches : Set<UITouch> , with event : UIEvent?) {
    super.touchesBegan(touches , with: event)
        let touch = touches.first!
        let location = touch.location(in: view) //Returns the current location of the receiver in the coordinate system.
    print("touches began \(location)")
    }
    
    override func touchesMoved(_ touches : Set<UITouch> , with event: UIEvent?) {
    super.touchesMoved (touches , with: event )
        let touch = touches.first!
        let location = touch.location(in: view)
    print ("touches moved \(location)")
    }
    
    override func touchesEnded(_ touches : Set<UITouch> , with event : UIEvent?) {
    super.touchesEnded(touches , with: event)
        let touch = touches.first!
        let location = touch.location(in: view)
    print ("touches ended \(location)")
    }
    
    override func touchesCancelled(_ touches : Set<UITouch> , with event: UIEvent?) {
    super.touchesCancelled (touches , with: event )
    print ("touches cancelled")
    }
    
    //For the textView change color
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
            toolPicker.setVisible(true, forFirstResponder: canvasView) // Sets the visibility for the tool picker
            canvasView.becomeFirstResponder() //Asks UIKit to make this object the first responder in its window.
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
        let date = NSDate()
        let formatDate = DateFormatter()
        formatDate.dateFormat = "MM-dd-yyyy"
        let dateString = formatDate.string(from: date as Date)
        print(dateString)
        
        let stringDate = "07/12/2022"
        formatDate.dateFormat = "MM/dd/yyyy"
        formatDate.timeZone = NSTimeZone(abbreviation: "GMT +0:00") as TimeZone?
        let dateFromString = formatDate.date(from: stringDate)
        print (dateFromString!)
        
        // Gets the current date and time :
        let currentDateTime = Date()
        // Initializes the date formatter and set the style :
        let formatter = DateFormatter()
        formatter.timeStyle = .long
        formatter.dateStyle = .long
        // Gets the date and time String from the date object :
        let dateTimeString = formatter.string(from:currentDateTime)
        // Displays it on the label :
        print(dateTimeString)
        
        let tap = UITapGestureRecognizer(target: self, action: Selector(("showMoreActions:")))
            tap.numberOfTapsRequired = 1
            view.addGestureRecognizer(tap)
        
    // ------>>>> Timestamp in miliseconds
        let time = UInt64(Date().timeIntervalSince1970 * 1000) //The interval between the date object and 00:00:00 UTC on 1 January 1970.
        let myTimeString = String(time)

        print("Timestamp in milisecond: \(time)")
        
        //For timestamp with 10 Digit milliseconds since 1970
        let timeStamp = Date().timeIntervalSince1970
        print(timeStamp)
        
        // ------------>>>> For creating CSV file
        let fileName = "testing.csv" // CSV filename
        
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        let documentURL = URL(fileURLWithPath: documentDirectoryPath).appendingPathComponent(fileName)
        
        let output = OutputStream.toMemory() // stream data into memory
        let csvWriter = CHCSVWriter(outputStream: output,
                                    encoding: String.Encoding.utf8.rawValue, delimiter: unichar(",".utf8.first!))
        
        csvWriter?.writeField("Timestamp")
        csvWriter?.writeField("Timestamp in miliseconds")

           csvWriter?.finishLine()

           var arrOfTimestamp = [[String]]()
   //        var arrOfTimeInMiliSec = [[Int]]()
           
           arrOfTimestamp.append([dateTimeString])
           arrOfTimestamp.append([myTimeString])

   //        arrOfTimeInMiliSec.append([time])
           for(elements) in arrOfTimestamp.enumerated() {
               csvWriter?.writeField(elements.element[0])
           }

           csvWriter?.closeStream()

           let buffer = (output.property(forKey: .dataWrittenToMemoryStreamKey) as? Data)!

           do{
               try buffer.write(to: documentURL)
           }
           catch {

           }
    }
}


