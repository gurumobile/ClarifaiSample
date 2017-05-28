//
//  ViewController.swift
//  ClarifaiSample
//
//  Created by Sambo on 5/28/17.
//  Copyright © 2017 Sambo. All rights reserved.
//

import UIKit
import Clarifai

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var SELECTED_IMAGEVIEW = UIImageView()
    
    var clientApp:ClarifaiApp?
    
    let CLARIFAIAPPID = ""
    let CLARIFAIAPPSECRET = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Clarifai Configure
        clientApp = ClarifaiApp(appID: CLARIFAIAPPID, appSecret: CLARIFAIAPPSECRET)
        
        onCamera()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func onCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: {
                print("Completion")
            })
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            SELECTED_IMAGEVIEW.contentMode = .scaleToFill
            SELECTED_IMAGEVIEW.image = pickedImage
        }
        
        picker.dismiss(animated: true) {
            self.onRecognizeImage(self.SELECTED_IMAGEVIEW.image!)
        }
    }

    func onRecognizeImage(_ image: UIImage) {
        if let app = clientApp {
            
            // Fetch Clarifai's general model.
            app.getModelByName("general-v1.3", completion: { (model, error) in
                
                // Create a Clarifai image from a uiimage.
                let caiImage = ClarifaiImage(image: image)!
                
                // Use Clarifai's general model to pedict tags for the given image.
                model?.predict(on: [caiImage], completion: { (outputs, error) in
                    print("%@", error ?? "no error")
                    guard
                        let caiOuputs = outputs
                        else {
                            print("Predict failed")
                            return
                    }
                    
                    if let caiOutput = caiOuputs.first {
                        // Loop through predicted concepts (tags), and display them on the screen.
                        let tags = NSMutableArray()
                        for concept in caiOutput.concepts {
                            tags.add(concept.conceptName)
                        }
                        
                        DispatchQueue.main.async {
                            // print(tags[0]) ~ n
                        }
                    }
                    
                    DispatchQueue.main.async {
                        // Next Action
                    }
                })
            })
        }
    }
}

