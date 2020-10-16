//
//  ScanVC.swift
//  DocScan
//
//  Created by Ankit on 15/10/20.
//

import UIKit
import PDFKit
import Vision
import VisionKit

class ScanVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource{
    
    @IBOutlet var emptyView: UIView!
    @IBOutlet weak var addBttn: UIBarButtonItem!
    
    let imgArr = ["FolderIconPurple","FolderIconPink","FolderIconOrange"]
    let nameArr = ["Document 1","Document 2","Document 3"]
    let dateArr = ["17.10.2020","10.10.2020","11.10.2020"]
    
    @IBAction func showaddTapped(_ sender: Any) {
        showCamera()
    }
    
    @objc func showCamera(){
        let actionSheet = UIAlertController(title: "Select Photo", message: "Where do you want to select a photo?", preferredStyle: .actionSheet)
        
        let photoAction = UIAlertAction(title: "Choose an image", style: .default) { (action) in
          if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            let photoPicker = UIImagePickerController()
            photoPicker.delegate = self
            photoPicker.sourceType = .photoLibrary
            photoPicker.allowsEditing = false
            
            self.present(photoPicker, animated: true, completion: nil)
          }
        }
        actionSheet.addAction(photoAction)
        
        let cameraAction = UIAlertAction(title: "Scan an image", style: .default) { [self] (action) in
          configureDocumentView()
        }
        actionSheet.addAction(cameraAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // To hide the top line
        self.navigationController?.navigationBar.shadowImage = UIImage()
        // To hide the top line
        //self.tabBarController?.tabBar.shadowImage = UIImage()
        //self.tabBarController?.tabBar.backgroundImage = UIImage()
        setUpMenu()
    }
    
    //MARK:- To create the collectionView on the page
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:FoldersCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoldersCVCell", for: indexPath) as! FoldersCVCell
        cell.imageView.image = UIImage(named: imgArr[indexPath.row])
        cell.dateLabel.text = dateArr[indexPath.row]
        cell.documentName.text = nameArr[indexPath.row]
        cell.menuBttn.addTarget(self, action: #selector(showCamera), for: .touchUpInside)
        cell.layer.cornerRadius = 20
        return cell
    }
    //MARK:- Set up uimenu Button
    
    @objc func setUpMenu(){
        let saveAction = UIAction(title: "") { action in
            // whatever
            print("save action!")
        }
        let saveMenu = UIMenu(title: "", children: [
            UIAction(title: "Copy", image: UIImage(systemName: "doc.on.doc")) { action in
                    //Copy Menu Child Selected
                },
             UIAction(title: "Rename", image: UIImage(systemName: "pencil")) { action in
                    //Rename Menu Child Selected
                },
             UIAction(title: "Duplicate", image: UIImage(systemName: "plus.square.on.square")) { action in
                    //Duplicate Menu Child Selected
                },
             UIAction(title: "Move", image: UIImage(systemName: "folder")) { action in
                    //Move Menu Child Selected
                },
              ])
        if #available(iOS 14.0, *) {
            let addButton = UIBarButtonItem(image: UIImage(named: "MenuBttn"), menu: saveMenu)
            navigationItem.leftBarButtonItem = addButton
        } else {
            // Fallback on earlier versions
            print("LOl")
        }
    }
    
    //MARK:- Set up scanner
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
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        print(error)
        
        controller.dismiss(animated: true)
    }
}
