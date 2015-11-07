//
//  Helper.swift
//  ChatDemo-UI2.0
//
//  Created by Jeff Wong on 15/7/20.
//  Copyright (c) 2015年 Jeff Wong. All rights reserved.
//

import UIKit

protocol ZFString {
    func removeFirstSpaceString() -> String
    func widthForDisplaying(font: UIFont) -> CGFloat
}

extension String: ZFString {
    // MARK: 移除首个为空格的字符
    func removeFirstSpaceString() -> String {
        if self == "" {
            return self
        }
        let firstIndex = self.startIndex.advancedBy(1)
        let firstCharacter = self.substringToIndex(firstIndex)
        var retStr: String
        if firstCharacter == " " {
            retStr = self.substringFromIndex(firstIndex)
        }else {
            retStr = self
        }
        return retStr
    }
    // MARK: 以某种字体显示在UILabel中的UILabel的宽度
    func widthForDisplaying(font: UIFont) -> CGFloat {
        let nsStr = NSString(string: self)
        let size = nsStr.sizeWithAttributes([NSFontAttributeName: font])
        return size.width
    }
    
    func sizeForTextInLabel(font: UIFont, maxSize: CGSize) -> CGSize {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 5
        return NSString(string: self).boundingRectWithSize(
            maxSize,
            options: .UsesLineFragmentOrigin,
            attributes: [
                NSFontAttributeName: font,
                NSParagraphStyleAttributeName: paragraph],
            context: nil).size
    }
}