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

class ScanVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource, UIGestureRecognizerDelegate{
    
    var workingDirectory : URL?
    var allFiles : [File] = []
    var storedBarItem : UIBarButtonItem?
    
    @IBOutlet weak var backBttn: UIBarButtonItem!
    @IBOutlet var InstructionView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var emptyView: UIView!
    @IBOutlet weak var addBttn: UIBarButtonItem!
    @IBAction func backBttnTapped(_ sender: Any) {
        returnToPreviousDirectory()
    }
    
    //MARK: - Create directory
    func gotoDirectory(directory:URL) {
        if(directory.lastPathComponent == "DocScanner"){
            self.navigationItem.leftBarButtonItem = nil
            self.title = "HOME"
        }else{
            self.navigationItem.leftBarButtonItem = self.backBttn
            self.title = directory.lastPathComponent.uppercased()
        }
        self.workingDirectory = directory
        reloadTableData()
        self.tabBarController?.tabBar.isHidden = true
    }
    func returnToPreviousDirectory(){
        if(self.workingDirectory?.lastPathComponent == "DocScanner"){
        }else{
            self.workingDirectory?.deleteLastPathComponent()
            self.title = workingDirectory!.lastPathComponent.uppercased()
        }
        self.gotoDirectory(directory: self.workingDirectory!)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: -
    
    @IBAction func showaddTapped(_ sender: Any) {
        
        AlertUtil.shared.alertWithTextField(parent: self, title: "Add Folder", message: "Enter folder name to add new folder", placeholder: "Folder Name", value: "", proceedTitle: "Add", cancelTitle: "Later", didProceed: { (folderName) in
            let errorMessage = FileUtility.shared.createFolder(directory: self.workingDirectory!, name: folderName)
            if(errorMessage != ""){
                self.presentAlert(title: "Failed", message: errorMessage)
            }else{
                //                self.presentAlert(title: "Success", message: "Folder added successfully!")
                self.reloadTableData()
            }
        }) {
            print("canceled")
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if let directory = self.workingDirectory{
            self.allFiles = FileUtility.shared.scanDirectory(directory: directory)
        }else{
            self.workingDirectory = FileUtility.shared.defaultPath
            self.allFiles = FileUtility.shared.scanDirectory(directory: self.workingDirectory!)
        }
        self.collectionView.reloadData()
        
    }
    
    func reloadTableData() {
        self.allFiles.removeAll()
        self.allFiles = FileUtility.shared.scanDirectory(directory: self.workingDirectory!)
        self.collectionView.reloadData()
    }
    
    //MARK:- To create the collectionView on the page
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allFiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:FoldersCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoldersCVCell", for: indexPath) as! FoldersCVCell
        //cell.imageView.image = UIImage(named: imgArr[indexPath.row])
        //cell.dateLabel.text = dateArr[indexPath.row]
        //cell.documentName.text = nameArr[indexPath.row]
        
        cell.imageView?.image = self.allFiles[indexPath.row].image
        cell.documentName?.text = self.allFiles[indexPath.row].name
        cell.dateLabel?.text = self.allFiles[indexPath.row].size
        
        //cell.menuBttn.addTarget(self, action: #selector(showCamera), for: .touchUpInside)
        cell.layer.cornerRadius = 20
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedFile = self.allFiles[indexPath.row]
        switch  selectedFile.type{
        case .pdf:
            self.presentFile(path: selectedFile.path)
            break
        default:
            self.gotoDirectory(directory: selectedFile.url)
            break
        }
    }
    
    // Deprecated
    /*
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
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        // To hide the top line
        self.storedBarItem = self.backBttn
        self.navigationItem.leftBarButtonItem = nil
        self.navigationController?.navigationBar.shadowImage = UIImage()
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(longPressGR:)))
            longPressGR.minimumPressDuration = 0.5
            longPressGR.delaysTouchesBegan = true
            self.collectionView.addGestureRecognizer(longPressGR)
        //setUpMenu()
    }
    
    @objc
    func handleLongPress(longPressGR: UILongPressGestureRecognizer) {
        if longPressGR.state != .ended {
            return
        }
        
        let point = longPressGR.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: point)
        
        if let indexPath = indexPath {
            var cell = self.collectionView.cellForItem(at: indexPath)
            let deleteAction = self.contextualDeleteAction(forRowAt: indexPath)
        } else {
            print("Could not find index path")
        }
    }
    
    func contextualDeleteAction(forRowAt indexPath : IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Delete") { (contextAction, sourceView, completionHandler) in
            let errorMessage = FileUtility.shared.deleteFile(url: self.allFiles[indexPath.row].url)
            if(errorMessage == ""){
                self.reloadTableData()
                completionHandler(true)
            }else{
                self.presentAlert(title: "Failed", message: errorMessage)
                completionHandler(false)
            }
        }
        action.image = UIImage(named: "delete_forever")
        action.title = "Delete"
        action.backgroundColor = UIColor.red
        return action
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
    
}


extension ScanVC:UIDocumentInteractionControllerDelegate {
    func presentFile(path:String) {
        let documentInteractionController = UIDocumentInteractionController(url: URL(fileURLWithPath: path))
        documentInteractionController.delegate = self
        documentInteractionController.presentPreview(animated: true)
    }
    //MARK: UIDocumentInteractionController delegates
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}
