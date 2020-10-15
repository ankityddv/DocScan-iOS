//
//  ScanVC.swift
//  DocScan
//
//  Created by Ankit on 15/10/20.
//

import UIKit
import PDFKit
import VisionKit

class ScanVC: UIViewController{
    
    @IBAction func scanBttnTapped(_ sender: Any) {
        configureDocumentView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // To hide the top line
        self.navigationController?.navigationBar.shadowImage = UIImage()
        // To hide the top line
        self.tabBarController?.tabBar.shadowImage = UIImage()
        self.tabBarController?.tabBar.backgroundImage = UIImage()
    }
    
    private func configureDocumentView(){
        let scanningDocumentVC = VNDocumentCameraViewController()
        scanningDocumentVC.delegate = self
        self.present(scanningDocumentVC, animated: true, completion: nil)
    }
    
}

extension ScanVC:VNDocumentCameraViewControllerDelegate {
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        for pageNumber in 0..<scan.pageCount {
            let image = scan.imageOfPage(at: pageNumber)
            print(image)
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        // You are responsible for dismissing the controller.
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        print(error)
        
        controller.dismiss(animated: true)
    }
}



/*
func createPDF(){
    // Create an empty PDF document
    let pdfDocument = PDFDocument()

    // Load or create your UIImage
    let imageOut = UIImage(...)

    // Create a PDF page instance from your image
    let pdfPage = PDFPage(image: imageOut!)

    // Insert the PDF page into your document
    pdfDocument.insert(pdfPage!, at: 0)

    // Get the raw data of your PDF document
    let data = pdfDocument.dataRepresentation()

    // The url to save the data to
    let url = URL(fileURLWithPath: "/Path/To/Your/PDF")

    // Save the data to the url
    try! data!.write(to: url)
}
*/
