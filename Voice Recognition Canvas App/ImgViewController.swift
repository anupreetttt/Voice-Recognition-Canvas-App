//
//  ImgViewController.swift
//  Voice Recognition Canvas App
//
//  Created by Anupreet Paulkar on 6/7/22.
//

import UIKit

class ImgViewController: UIViewController {

    @IBOutlet weak var savePhoto: UIImageView!
    var image = UIImage()
    override func viewDidLoad() {
        super.viewDidLoad()
        savePhoto.image = image
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
