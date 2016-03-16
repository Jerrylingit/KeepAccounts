//
//  UIImage+Extension.swift
//  KeepAccounts
//
//  Created by admin on 16/3/16.
//  Copyright © 2016年 jerry. All rights reserved.
//

import Foundation

extension UIImage{
    public class func cropImage(original:UIImage, scale:CGFloat)->UIImage{
        let originalSize = original.size
        let newSize = CGSizeMake(originalSize.width * scale, originalSize.height * scale)
        
        //在画布里画原始图
        UIGraphicsBeginImageContext(newSize)
        original.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let cropedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return cropedImage
    }
    public class func compressImage(original:UIImage, compressionQuality:CGFloat)->NSData?{
        let imageData = UIImageJPEGRepresentation(original, compressionQuality)
        return imageData
    }
    public class func cropAndCompressImage(original:UIImage, scale:CGFloat, compressionQualiy:CGFloat)->NSData?{
        let cropImage = UIImage.cropImage(original, scale: scale)
        let imageData = compressImage(cropImage, compressionQuality: compressionQualiy)
        return imageData
    }
}