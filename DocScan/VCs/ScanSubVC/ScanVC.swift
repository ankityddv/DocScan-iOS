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

class ScanVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    var myCollectionView: UICollectionView?
    
    @IBOutlet weak var ScannedImageView: UIImageView!
    @IBOutlet var emptyView: UIView!
    @IBOutlet weak var addBttn: UIBarButtonItem!
    
    @IBAction func showaddTapped(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Select Photo", message: "Where do you want to select a photo?", preferredStyle: .actionSheet)
        
        let photoAction = UIAlertAction(title: "Photos", style: .default) { (action) in
          if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            let photoPicker = UIImagePickerController()
            photoPicker.delegate = self
            photoPicker.sourceType = .photoLibrary
            photoPicker.allowsEditing = false
            
            self.present(photoPicker, animated: true, completion: nil)
          }
        }
        actionSheet.addAction(photoAction)
        
        let cameraAction = UIAlertAction(title: "Scan", style: .default) { [self] (action) in
          configureDocumentView()
        }
        actionSheet.addAction(cameraAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    //HiddenButton
    @IBAction func showMenu(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // To hide the top line
        self.navigationController?.navigationBar.shadowImage = UIImage()
        // To hide the top line
        self.tabBarController?.tabBar.shadowImage = UIImage()
        self.tabBarController?.tabBar.backgroundImage = UIImage()
        createCollView()
        setUpMenu()
    }
    
    
    //MARK:- To create the collectionView on the page.
    func createCollView(){
        let view = UIView()
        view.backgroundColor = UIColor(named:"AppGrayColor")
                
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            layout.itemSize = CGSize(width: 180, height: 180)
                
            myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
            myCollectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
            myCollectionView?.backgroundColor = UIColor(named:"AppGrayColor")
            
            myCollectionView?.dataSource = self
            myCollectionView?.delegate = self
        
            view.addSubview(myCollectionView ?? UICollectionView())
                
            self.view = view
    }
    
    
    //MARK:- Set up uimenu Button
    func setUpMenu(){
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
            ScannedImageView.image = scan.imageOfPage(at: 0)
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

extension ScanVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5 // How many cells to display
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath)
        myCell.backgroundColor = UIColor(named:"AppWhiteColor")
        myCell.layer.cornerRadius = 20
        myCell.layer.masksToBounds = true
        return myCell
    }
}
// CollectionView shits
extension ScanVC: UICollectionViewDelegate {
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       print("User tapped on item \(indexPath.row)")
    }
}
