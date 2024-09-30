//
//  ApiConstants.swift
//  MNAD_CW_TEST
//
//  Created by Chamika Sakalasuriya on 2023-11-25.
//

import Foundation
import SwiftUI

public struct Constants {
    
    static let LAN: String = "41.8933203"
    static let LON: String = "12.4829321"
    static let APP_ID: String = "b3fc0ed125de946fbcfcbca5018d43fb"
    static let regularFont = "ProductSans-Regular"
    static let boldFont = "ProductSans-Bold"
    
    static let descriptiveText = Font.custom(regularFont, size: 18)
    static let descriptiveTextBold = Font.custom(boldFont, size: 18)
    static let normalText = Font.custom(regularFont, size: 21)
    static let largeText = Font.custom(boldFont, size: 100)
    static let titleText = Font.custom(boldFont, size: 35)
    static let title2Text = Font.custom(boldFont, size: 27)
    
    static let PRIMARY_COLOR: Color = Color(red: 246/255, green: 237/255, blue: 255/255)
    static let SECONDARY_COLOR: Color = Color(red: 208/255, green: 188/255, blue: 255/255)
}
