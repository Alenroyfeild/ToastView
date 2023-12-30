//
//  UIUtil.swift
//  ToastView
//
//  Created by BalajiRoyal on 06/11/23.
//

import UIKit

final class UIUtil {
    static func createVisualEffectsView(traitCollection: UITraitCollection) -> UIVisualEffectView {
        let blurEffectView =  VisualEffectView(traitCollection: traitCollection)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        return blurEffectView
    }
    
    class VisualEffectView: UIVisualEffectView {
        
        init(traitCollection: UITraitCollection) {
            super.init(effect: VisualEffectView.getBlurEffect(traitCollection))
        }
        
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            if #available(iOSApplicationExtension 13.0, *),
               previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
                effect = VisualEffectView.getBlurEffect(traitCollection)
            }
        }
        
        static func getBlurEffect(_ traitCollection: UITraitCollection) -> UIBlurEffect {
            if #available(iOS 13.0, *) {
                return UIBlurEffect(style: traitCollection.userInterfaceStyle == .dark ? .systemThinMaterialDark : .systemThinMaterialLight)
            } else {
                return UIBlurEffect(style: .light)
            }
        }
    }
}
