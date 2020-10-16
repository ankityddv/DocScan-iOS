//
//  PDFCreator.swift
//  PDFMaker
//
//  Created by Ankit on 16/10/20.
//

import UIKit
import PDFKit

class PDFCreator: NSObject {
  let image: UIImage
  
  init(image: UIImage) {
    self.image = image
  }
  
  func createFlyer() -> Data {
    // 1
    let pdfMetaData = [
      kCGPDFContextCreator: "Flyer Builder",
      kCGPDFContextAuthor: "raywenderlich.com",
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
      let imageBottom = addImage(pageRect: pageRect, imageTop: 18.0)
      
      //let context = context.cgContext
      //drawTearOffs(context, pageRect: pageRect, tearOffY: pageRect.height * 4.0 / 5.0, numberTabs: 8)
    }
    
    return data
  }

  func addImage(pageRect: CGRect, imageTop: CGFloat) -> CGFloat {
    // 1
    let maxHeight = pageRect.height * 0.4
    let maxWidth = pageRect.width * 0.8
    // 2
    let aspectWidth = maxWidth / image.size.width
    let aspectHeight = maxHeight / image.size.height
    let aspectRatio = min(aspectWidth, aspectHeight)
    // 3
    let scaledWidth = image.size.width * aspectRatio
    let scaledHeight = image.size.height * aspectRatio
    // 4
    let imageX = (pageRect.width - scaledWidth) / 2.0
    let imageRect = CGRect(x: imageX, y: imageTop,
                           width: scaledWidth, height: scaledHeight)
    // 5
    image.draw(in: imageRect)
    return imageRect.origin.y + imageRect.size.height
  }
  
    /*
  // 1
  func drawTearOffs(_ drawContext: CGContext, pageRect: CGRect,
                    tearOffY: CGFloat, numberTabs: Int) {
    // 2
    drawContext.saveGState()
    drawContext.setLineWidth(2.0)
    
    // 3
    drawContext.move(to: CGPoint(x: 0, y: tearOffY))
    drawContext.addLine(to: CGPoint(x: pageRect.width, y: tearOffY))
    drawContext.strokePath()
    drawContext.restoreGState()
    
    // 4
    drawContext.saveGState()
    let dashLength = CGFloat(72.0 * 0.2)
    drawContext.setLineDash(phase: 0, lengths: [dashLength, dashLength])
    // 5
    let tabWidth = pageRect.width / CGFloat(numberTabs)
    for tearOffIndex in 1..<numberTabs {
      // 6
      let tabX = CGFloat(tearOffIndex) * tabWidth
      drawContext.move(to: CGPoint(x: tabX, y: tearOffY))
      drawContext.addLine(to: CGPoint(x: tabX, y: pageRect.height))
      drawContext.strokePath()
    }
    // 7
    drawContext.restoreGState()
  }
    */
}
