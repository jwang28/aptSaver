//
//  ScanFileViewController.swift
//  APT Saver
//
//  Created by Jennifer Wang on 5/12/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit
import TesseractOCR
class ScanFileViewController: UIViewController, G8TesseractDelegate {

    @IBOutlet weak var textView: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        if let tesseract = G8Tesseract(language: "eng") {
            tesseract.delegate = self
            tesseract.image = UIImage(named: "test18") ?? UIImage(named: "testImage.png")!
            tesseract.recognize()
            textView.text = tesseract.recognizedText



        }

        // Do any additional setup after loading the view.
    }
    func progressImageRecognition(for tesseract: G8Tesseract) {
        print("Recognition Progress \(tesseract.progress) %")
    }


}
