//
//  ToastViewTheme.swift
//  ToastView
//
//  Created by BalajiRoyal on 08/11/23.
//

import UIKit

//Colors
var primaryTextColor: UIColor {
    get {
        ToastViewTheme.primaryTextColor
    }
}
var primarySurfaceColor: UIColor {
    get {
        ToastViewTheme.primarySurfaceColor
    }
}
var secondaryTextColor: UIColor {
    get {
        ToastViewTheme.secondaryTextColor
    }
}
var secondarySurfaceColor: UIColor {
    get {
        ToastViewTheme.secondarySurfaceColor
    }
}

//Fonts
var messageFont: UIFont {
    get {
        ToastViewTheme.messageFont
    }
}

public class ToastViewTheme {
    public static var primaryTextColor: UIColor = .label
    public static var primarySurfaceColor: UIColor = .systemFill
    public static var secondaryTextColor: UIColor = .label
    public static var secondarySurfaceColor: UIColor = .systemFill
    
    public static var messageFont: UIFont = .systemFont(ofSize: 15, weight: .light)
    
    public init(primaryTextColor: UIColor, primarySurfaceColor: UIColor, secondaryTextColor: UIColor, secondarySurfaceColor: UIColor, messageFont: UIFont) {
        Self.primaryTextColor = primaryTextColor
        Self.primarySurfaceColor = primarySurfaceColor
        Self.secondaryTextColor = secondaryTextColor
        Self.secondarySurfaceColor = secondarySurfaceColor
        Self.messageFont = messageFont
    }
}
