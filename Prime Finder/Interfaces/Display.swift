//
//  Display.swift
//  Prime Finder
//
//  Created by inan on 20.03.2018.
//  Copyright © 2018 inan. All rights reserved.
//

import UIKit

enum Modes : Int {
  case MValidator = 0
  case MNext1 = 1
  case Mnext10 = 2
  case Mnext100 = 3
  case MPrev1 = 4
  case MPrev10 = 5
  case Mprev100 = 6
}

class Display: UIView {
  private let mainFont:String = "Avenir-HeavyOblique"
  private let digitColor = UIColor(red: 0.0/255, green: 179/255, blue: 177/255, alpha: 1)
  private var digitStack = [String : UIImage]()
  private var modeStack = [String : UIImage]()
  private var mainHolderSize:CGSize = .zero
  private var digitHeight:CGFloat = 0
  private var maxDigitCount:Int = 12
  private var glowRadius : CGFloat = 0
  private var modeTextHeight:CGFloat = 0
  private var modeImageView:UIImageView!
  private var primeImageView:UIImageView!
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    // Cihazın ekran ölçülerini al
    var portraitBoundsOfScreen = UIScreen.main.bounds
    // landspace modda açılsıysa ölçüleri ters çevir
    if portraitBoundsOfScreen.width > portraitBoundsOfScreen.height{
      let reverseBounds = CGRect(x: 0, y: 0, width: portraitBoundsOfScreen.height, height: portraitBoundsOfScreen.width)
      portraitBoundsOfScreen = reverseBounds
    }
    self.digitHeight = floor(portraitBoundsOfScreen.width * 0.1)
    self.glowRadius = ceil(self.digitHeight * 0.14)
    self.modeTextHeight = ceil(self.digitHeight * 0.23)
    self.mainHolderSize = CGSize(width: floor(portraitBoundsOfScreen.width * 0.88), height: floor(portraitBoundsOfScreen.width * 0.18))
    
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
    
    let mainHolderView = UIView()
    mainHolderView.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(mainHolderView)
    self.addConstraints([
      NSLayoutConstraint(item: mainHolderView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
      NSLayoutConstraint(item: mainHolderView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0),
      NSLayoutConstraint(item: mainHolderView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: mainHolderSize.width),
      NSLayoutConstraint(item: mainHolderView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: mainHolderSize.height)
      ])
    
    
    let displayBackgroundImageView = UIImageView(frame : CGRect(x: 0, y: 0, width: self.mainHolderSize.width, height: self.mainHolderSize.height))
    displayBackgroundImageView.contentMode = .scaleToFill
    displayBackgroundImageView.image = createDisplayBackdroundImage()
    mainHolderView.addSubview(displayBackgroundImageView)
    
    let illuminationLayerHolderView = UIView(frame : CGRect(x: 0, y: 0, width: self.mainHolderSize.width, height: self.mainHolderSize.height))
    mainHolderView.addSubview(illuminationLayerHolderView)
    self.modeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.mainHolderSize.width, height: self.mainHolderSize.height))
    self.modeImageView.contentMode = .scaleToFill
    illuminationLayerHolderView.addSubview(self.modeImageView)
    updatesModes(mode: .MValidator)
    
    self.layoutIfNeeded()
    
  }
  
  public func updatesModes(mode: Modes){
    if self.modeImageView != nil{
      if let image = modeCreateImage(mode: mode){
        self.modeImageView.image = image
      }
    }
  }
  
  private func modeCreateImage(mode : Modes)-> UIImage! {
    var returnImage:UIImage!
    var text:String = ""
    var point:CGPoint = .zero
    var modeStackKey:String = ""
    switch mode {
    case .MValidator:
      text = "IS PRIME"
      modeStackKey = "validator"
      point = CGPoint(x: self.glowRadius, y: (self.mainHolderSize.height - self.digitHeight) / 2)
    case .MNext1:
      text = "NEXT 1"
      modeStackKey = "next1"
      point = CGPoint(x: self.glowRadius, y:(self.mainHolderSize.height / 2)-(self.modeTextHeight/2))
    case .Mnext10:
      text = "NEXT 10"
      modeStackKey = "next10"
      point = CGPoint(x: self.glowRadius, y:(self.mainHolderSize.height / 2)-(self.modeTextHeight/2))
    case .Mnext100:
      text = "NEXT 100"
      modeStackKey = "next100"
      point = CGPoint(x: self.glowRadius, y:(self.mainHolderSize.height / 2)-(self.modeTextHeight/2))
    case .MPrev1:
      text = "PREV 1"
      modeStackKey = "prev1"
      point = CGPoint(x: self.glowRadius, y: ((self.mainHolderSize.height - self.digitHeight)/2 + self.digitHeight) - self.modeTextHeight)
    case .MPrev10:
      text = "PREV 10"
      modeStackKey = "prev10"
      point = CGPoint(x: self.glowRadius, y: ((self.mainHolderSize.height - self.digitHeight)/2 + self.digitHeight) - self.modeTextHeight)
    case .Mprev100:
      text = "PREV 100"
      modeStackKey = "prev100"
      point = CGPoint(x: self.glowRadius, y: ((self.mainHolderSize.height - self.digitHeight)/2 + self.digitHeight) - self.modeTextHeight)
    }
    let modeImage = self.modeStack.filter({ (aImage: (key: String, value: UIImage)) -> Bool in
      return aImage.key == modeStackKey
    })
    if let filtered = modeImage.first {
      returnImage = filtered.value
    } else {
      
      UIGraphicsBeginImageContextWithOptions(self.mainHolderSize, false, UIScreen.main.nativeScale)
      if let textFont = UIFont(name: self.mainFont, size: self.modeTextHeight){
        
        let textFontAttributes:[NSAttributedStringKey : Any] = [
          NSAttributedStringKey.font : textFont,
          NSAttributedStringKey.foregroundColor : self.digitColor
        ]
        text.draw(at: point, withAttributes: textFontAttributes)
        if let imageFromContext = UIGraphicsGetImageFromCurrentImageContext() {
          returnImage = imageFromContext
          self.modeStack[modeStackKey] = imageFromContext
        }
        
      }
      UIGraphicsEndImageContext()
    }
    return returnImage
  }
  
  private func createDisplayBackdroundImage() -> UIImage! {
    var returnImage : UIImage!
    UIGraphicsBeginImageContextWithOptions(self.mainHolderSize, false, UIScreen.main.nativeScale)
    if let textFont = UIFont(name: self.mainFont, size: self.modeTextHeight){
      let text1 = "IS PRIME"
      let text2 = "NEXT 100"
      let text3 = "PREV 100"
      
      let textFontAttributes:[NSAttributedStringKey : Any] = [
        NSAttributedStringKey.font : textFont,
        NSAttributedStringKey.foregroundColor : self.digitColor.withAlphaComponent(0.15)
      ]
      text1.draw(at: CGPoint(x: self.glowRadius, y: (self.mainHolderSize.height - self.digitHeight) / 2), withAttributes: textFontAttributes)
      text2.draw(at: CGPoint(x: self.glowRadius, y:(self.mainHolderSize.height / 2)-(self.modeTextHeight/2)), withAttributes: textFontAttributes)
      text3.draw(at: CGPoint(x: self.glowRadius, y: ((self.mainHolderSize.height - self.digitHeight)/2 + self.digitHeight) - self.modeTextHeight), withAttributes: textFontAttributes)
      
    }
    
    let fontHeight = floor(self.modeTextHeight * 1.2)
    if let textFont = UIFont(name: self.mainFont, size: fontHeight) {
      let text1 = "NOT"
      let text2 = "PRIME"
      let text3 = "CALCULATING"
      let textFontAttributes:[NSAttributedStringKey : Any] = [
        NSAttributedStringKey.font : textFont,
        NSAttributedStringKey.foregroundColor : self.digitColor.withAlphaComponent(0.15)
      ]
      text1.draw(at: CGPoint(x: ceil(self.mainHolderSize.width * 0.8), y: (self.mainHolderSize.height - (fontHeight * 1.4))), withAttributes: textFontAttributes)
      text2.draw(at: CGPoint(x: ceil(self.mainHolderSize.width * 0.88), y: (self.mainHolderSize.height - (fontHeight * 1.4))), withAttributes: textFontAttributes)
      var approximateStringSize = (text3 as NSString).size(withAttributes: textFontAttributes)
      text3.draw(at: CGPoint(x: ((self.mainHolderSize.width * 0.5) - (approximateStringSize.width * 0.5)), y: (self.mainHolderSize.height - (fontHeight * 1.4))), withAttributes: textFontAttributes)
      if let context = UIGraphicsGetCurrentContext() {
        approximateStringSize = CGSize(width: approximateStringSize.width + (fontHeight / 2), height: approximateStringSize.height)
        let lineHeight = ceil(self.modeTextHeight * 0.2)
        let lineStartPoint = CGPoint(x: (self.mainHolderSize.width * 0.5) - (approximateStringSize.width * 0.5), y: self.mainHolderSize.height - (lineHeight * 0.5))
        let lineEndPoint = CGPoint(x: (self.mainHolderSize.width * 0.5) + (approximateStringSize.width * 0.5), y: self.mainHolderSize.height - (lineHeight * 0.5))
        context.addLines(between: [lineStartPoint, lineEndPoint])
        context.setStrokeColor(self.digitColor.withAlphaComponent(0.15).cgColor)
        context.setLineWidth(lineHeight)
        context.strokePath()
      }
      
    }
    if let generateBackgroundDigit = generetaDigit(number: nil , height: self.digitHeight, hasFloatingPoint: false, hasDecimalMark: false){
      var xPosition = self.mainHolderSize.width - self.glowRadius - generateBackgroundDigit.size.width
      for _ in 0..<self.maxDigitCount{
        generateBackgroundDigit.draw(at: CGPoint(x: xPosition, y: (self.mainHolderSize.height - digitHeight)/2))
        xPosition -= generateBackgroundDigit.size.width
      }
      
    }
    returnImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return returnImage
  }
  
  // Create Image From digitparts Font
  private func generetaDigit(number : Int! , height : CGFloat, hasFloatingPoint : Bool, hasDecimalMark : Bool) -> UIImage! {
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
        digitStackKey += "float"
        digitParts.append(1)
      }
      if hasDecimalMark{
        digitStackKey += "decimal"
        digitParts.append(2)
      }
    }else {
      digitStackKey = "digitHolow"
      digitParts = [1,2,3,4,5,6,7,8,9]
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
    return returnImage
    
  }
  
}

