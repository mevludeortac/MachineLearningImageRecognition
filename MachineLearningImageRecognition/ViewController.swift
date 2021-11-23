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
        
        //proje içindeki MobileNetV2 modelini projeye dahil edip, bir değişkene atıyoruz
        if let model =  try? VNCoreMLModel(for: MobileNetV2().model){
            
            
            //REQUEST
            let request = VNCoreMLRequest(model: model) { (vnRequest, error) in
                //görsel analizinin isteğinin sonucunda üretilen sınıflandırma
                //en yüksek olasılıklı sonucu almak için ilk sonucu alacağız bunun için de VNClassificationObservation sınıfını kullanıyoruz
                //sınıflandırma görseli dizisini bizimle paylaşan sınıf
                if let results = vnRequest.results as? [VNClassificationObservation]{
                    if results.count > 0 {
                        let topResult = results.first
                        
                        //kullanıcıya göstereceğimiz işlemleri yazıyoruz
                        //kullanıcının arayüzüyle ilgili işlemler yapıyoruz ve bunu main'de yapmalıyız
                        DispatchQueue.main.async {
                            //yüzdelik olarak yazdırma işlemi
                            let confidenceLevel = (topResult?.confidence ?? 0) * 100
                            let rounded = Int(confidenceLevel * 100) / 100
                            self.resultLbl.text = "\(rounded)% it's \(topResult!.identifier)"
                            
                        }
                    }
                }
            }
            
            //HANDLER
            let handler = VNImageRequestHandler(ciImage: image)
            DispatchQueue.global(qos: .userInteractive).async {
                do{
                    try handler.perform([request])
                } catch{
                    print("error")
                }
            }

        }
        
    }
    
}

