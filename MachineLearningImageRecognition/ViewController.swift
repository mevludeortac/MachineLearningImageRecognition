//
//  ViewController.swift
//  MachineLearningImageRecognition
//
//  Created by MEWO on 23.11.2021.
//

import UIKit
import CoreML
import Vision
//image recognitionlarda kullanılan kütüphanelerden biri: vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var resultLbl: UILabel!
    
    //fonksiyon içinde kullanabilmemiz için class içinde tanımlamamız gerek
    var chosenImage = CIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func changeClicked(_ sender: Any) {
        
        //choose to photo from photo library
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    //kullanıcının fotoğrafı seçtikten sonraki işlemleri yazdığımız fonksiyon
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
        //ciImage kullanmamız gerekiyor o yüzden image'ımızı ciImage olarak cast ediyoruz
        if let ciImage = CIImage(image: imageView.image!){
            //
            chosenImage = ciImage
        }
        
        recognizeImage(image: chosenImage)
    }
    
    func recognizeImage(image: CIImage){
        
    }
    
}

