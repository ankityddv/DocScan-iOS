//
//  DocumentsVC.swift
//  DocScan
//
//  Created by Ankit on 16/10/20.
//

import UIKit
import Vision
import VisionKit
import PDFKit

class DocumentsVC: UIViewController {
    
    var pdfView: PDFView!
    
    @IBAction func shareBttnAction(_ sender: Any) {
        shareAction()
    }
    
    
    
    @IBOutlet weak var imgView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // To hide the top line
        self.navigationController?.navigationBar.shadowImage = UIImage()
        configureDocumentView()
    }
    
    @objc func shareAction() {
      // 1
      guard
        let image = imgView.image
        else{
          // 2
          let alert = UIAlertController(title: "All Information Not Provided", message: "You must supply all information to create a flyer.", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
          present(alert, animated: true, completion: nil)
          return
      }
      
      // 3
      let pdfCreator = PDFCreator(image: image)
      let pdfData = pdfCreator.createFlyer()
      let vc = UIActivityViewController(activityItems: [pdfData], applicationActivities: [])
      present(vc, animated: true, completion: nil)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
      if
        let _ = imgView.image {
        return true
      }
      
      let alert = UIAlertController(title: "All Information Not Provided", message: "You must supply all information to create a flyer.", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      present(alert, animated: true, completion: nil)
      
      return false
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "previewSegue" {
        guard let vc = segue.destination as? PDFPreviewViewController else { return }
        
        if let image = imgView.image {
          let pdfCreator = PDFCreator(image: image)
          vc.documentData = pdfCreator.createFlyer()
        }
      }
    }
    
    
    //MARK:-
    
    private func configureDocumentView(){
        let scanningDocumentVC = VNDocumentCameraViewController()
        scanningDocumentVC.delegate = self
        self.present(scanningDocumentVC, animated: true, completion: nil)
    }
    
    
}

extension DocumentsVC:VNDocumentCameraViewControllerDelegate {
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        for pageNumber in 0..<scan.pageCount {
            let image = scan.imageOfPage(at: pageNumber)
            print(image)
            imgView.image = scan.imageOfPage(at: 0)
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        print(error)
        
        controller.dismiss(animated: true)
    }
}
extension DocumentsVC: UIImagePickerControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    
    guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
      return
    }
    
    imgView.image = selectedImage
    imgView.isHidden = false
    
    dismiss(animated: true, completion: nil)
  }
}
