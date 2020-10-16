//
//  PDFCreator.swift
//  PDFMaker
//
//  Created by Ankit on 16/10/20.
//

import UIKit
import PDFKit

class PDFCreator: NSObject {
    
    let image1: UIImage
    let image2: UIImage
    
    init(image1: UIImage, image2: UIImage) {
        self.image1 = image1
        self.image2 = image2
    }
  
    func CreatePDF() -> Data {
        // 1
        let pdfMetaData = [
        kCGPDFContextCreator: "DocScan",
        kCGPDFContextAuthor: "thedrunkcoder.codes",
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        // 2
        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        // 3
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        // 4
        let data = renderer.pdfData { (context) in
            // 5
            context.beginPage()
            // 6
            _ = addImage(pageRect: pageRect, imageTop: 0.0)
            context.beginPage()
            _ = addImage2(pageRect: pageRect, imageTop: 0.0)
        }
        return data
    }

    func addImage(pageRect: CGRect, imageTop: CGFloat) -> CGFloat {
        // 1
        let maxHeight = pageRect.height * 1
        let maxWidth = pageRect.width * 1
        // 2
        let aspectWidth = maxWidth / image1.size.width
        let aspectHeight = maxHeight / image1.size.height
        let aspectRatio = min(aspectWidth, aspectHeight)
        // 3
        let scaledWidth = image1.size.width * aspectRatio
        let scaledHeight = image1.size.height * aspectRatio
        // 4
        let imageX = (pageRect.width - scaledWidth) / 2.0
        let imageRect = CGRect(x: imageX, y: imageTop,
                           width: scaledWidth, height: scaledHeight)
        // 5
        image1.draw(in: imageRect)
        return imageRect.origin.y + imageRect.size.height
    }
    
    func addImage2(pageRect: CGRect, imageTop: CGFloat) -> CGFloat {
        
        // 1
        let maxHeight = pageRect.height * 1
        let maxWidth = pageRect.width * 1
        // 2
        let aspectWidth = maxWidth / image2.size.width
        let aspectHeight = maxHeight / image2.size.height
        let aspectRatio = min(aspectWidth, aspectHeight)
        // 3
        let scaledWidth = image2.size.width * aspectRatio
        let scaledHeight = image2.size.height * aspectRatio
        // 4
        let imageX = (pageRect.width - scaledWidth) / 2.0
        let imageRect = CGRect(x: imageX, y: imageTop,
                           width: scaledWidth, height: scaledHeight)
        // 5
        image2.draw(in: imageRect)
        return imageRect.origin.y + imageRect.size.height
    }
    
}
