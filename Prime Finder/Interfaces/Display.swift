//
//  Display.swift
//  Prime Finder
//
//  Created by inan on 20.03.2018.
//  Copyright © 2018 inan. All rights reserved.
//

import UIKit

class Display: UIView {
  private let digitColor = UIColor(red: 0.0/255, green: 179/255, blue: 177/255, alpha: 1)
  private var digitStack = [String : UIImage]()

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    //Create Display ImageView
    let imageView = UIImageView()
    imageView.contentMode = .scaleToFill
    imageView.image = #imageLiteral(resourceName: "display")
    imageView.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(imageView)
    self.addConstraints([
      NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
      NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0),
      NSLayoutConstraint(item: imageView, attribute: .bottom , relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
      NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
      
      ])
    self.layoutIfNeeded()
    
  }
  
  // Create Image From digitparts Font
  private func generetaDigit(number : Int, height : CGFloat, hasFloatingPoint : Bool, hasDecimalMark : Bool) -> UIImage! {
    var returnImage : UIImage!
    var digitStackKey:String = ""
    var digitParts = [Int]()
    
    if number != nil {
    switch number {
    case 0:
      digitStackKey = "digit0"
      digitParts = [3,4,5,7,8,9]
    case 1:
      digitStackKey = "digit1"
      digitParts = [5,8]
    case 2:
      digitStackKey = "digit2"
      digitParts = [3,5,6,7,9]
    case 3:
      digitStackKey = "digit3"
      digitParts = [3,5,6,8,9]
    case 4:
      digitStackKey = "digit4"
      digitParts = [4,5,6,8]
    case 5:
      digitStackKey = "digit5"
      digitParts = [3,4,6,8,9]
    case 6:
      digitStackKey = "digit6"
      digitParts = [3,4,6,7,8,9]
    case 7:
      digitStackKey = "digit7"
      digitParts = [3,5,8]
    case 8:
      digitStackKey = "digit8"
      digitParts = [3,4,5,6,7,8,9]
    case 9:
      digitStackKey = "digit9"
      digitParts = [3,4,5,6,8,9]
    default:
      digitStackKey = "digit0"
      digitParts = [3,4,5,7,8,9]
      break
    }
      
      if hasFloatingPoint{
        digitParts.append(1)
      }
      if hasDecimalMark{
        digitParts.append(2)
      }
      
      let digitImage = self.digitStack.filter({ (aImage: (key: String, value: UIImage)) -> Bool in
        return aImage.key == digitStackKey
      })
      if let filtered = digitImage.first {
        returnImage = filtered.value
      } else {
        let fontAspectRatio:CGFloat = 0.62
        let cropRatio:CGFloat = 0.0344
        let rect = CGRect(x: 0, y: 0, width: floor(height * fontAspectRatio), height: height)
        let cropSize:CGFloat = height * cropRatio
        let textDrawRect = CGRect(x: -(((height - rect.size.width) / 2) + cropSize), y: -cropSize, width: height + (cropSize * 2), height: height + (cropSize * 2))
        if let textFont = UIFont(name: "digitparts", size: textDrawRect.size.height) {
          UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.nativeScale)
          
          
          digitParts.forEach({ (part) in
            let text:String = "\(part)"
            var aDigitColor = self.digitColor
            if digitStackKey == "digitHolow" {
              aDigitColor = self.digitColor.withAlphaComponent(0.15)
            }
            let textFontAttributes:[NSAttributedStringKey : Any] = [
              NSAttributedStringKey.font : textFont,
              NSAttributedStringKey.foregroundColor : aDigitColor
            ]
            text.draw(in: textDrawRect, withAttributes: textFontAttributes)
          })
          
          
          if let imageFromContext = UIGraphicsGetImageFromCurrentImageContext() {
            returnImage = imageFromContext
            self.digitStack[digitStackKey] = imageFromContext
          }
          UIGraphicsEndImageContext()
        }
      }
      }
    return returnImage
    
  }

}
