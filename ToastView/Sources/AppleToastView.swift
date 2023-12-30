//
//  AppleToastView.swift
//  ToastView
//
//  Created by BalajiRoyal on 08/11/23.
//

import UIKit

final class AppleToastView: UIView {
    struct ShadowStyle: Equatable {
        var color: CGColor = secondaryTextColor.cgColor
        var offset: CGSize = .init(width: 0, height: 4)
        var radius: CGFloat = 8
        var opacity: Float = 0.05

        init() {}

        static let standard: ShadowStyle = .init()
    }

    struct Style: Equatable {
        var minHeight: CGFloat = 40
        var minWidth: CGFloat = 120
        var backgroundColor: UIColor = secondarySurfaceColor
        var shadow: ShadowStyle = .standard
        var edgeInsets: NSDirectionalEdgeInsets = .init(top: 4, leading: 12, bottom: 4, trailing: 12)

        init() {}

        static let standard: Style = .init()
    }
    
    override var bounds: CGRect {
        didSet { layer.cornerRadius = bounds.height / 2 }
    }

    private let style: Style
    let child: MessageView
    
    init(child: MessageView, style: Style = .standard) {
        self.child = child
        self.style = style
        super.init(frame: .zero)
        commonInit()
    }

    required init?(coder: NSCoder) {
        self.style = .standard
        self.child = MessageView()
        super.init(coder: coder)
        commonInit()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layer.backgroundColor = style.backgroundColor.cgColor
        style.shadow.apply(to: layer)
    }

    func setUpViewConstraints(position: ToastView.Position) {
        guard let superview else { return }
        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: style.minHeight),
            leadingAnchor.constraint(greaterThanOrEqualTo: superview.layoutMarginsGuide.leadingAnchor),
            trailingAnchor.constraint(lessThanOrEqualTo: superview.layoutMarginsGuide.trailingAnchor),
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
        ])
        
        switch position {
        case .belowTopAnchor:
            topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        case .aboveTopAnchor:
            bottomAnchor.constraint(equalTo: superview.topAnchor, constant: -16).isActive = true
        case .aboveBottomAnchor:
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -16).isActive = true
        case .aboveCenter:
            centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: -50).isActive = true
        }
        layoutIfNeeded()
    }

    private func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        child.bgView.removeFromSuperview()
        addSubview(child)
        setUpSubViewConstraints()
        applyStyle()
    }

    private func applyStyle() {
        layer.backgroundColor = style.backgroundColor.cgColor
        clipsToBounds = true
        directionalLayoutMargins = style.edgeInsets
        layer.masksToBounds = false
        style.shadow.apply(to: layer)
    }

    private func setUpSubViewConstraints() {
        child.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            child.topAnchor.constraint(equalTo: topAnchor, constant: style.edgeInsets.top),
            child.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -style.edgeInsets.bottom),
            child.leadingAnchor.constraint(equalTo: leadingAnchor, constant: style.edgeInsets.leading),
            child.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -style.edgeInsets.trailing),
        ])
    }
}

extension AppleToastView.ShadowStyle {
    func apply(to layer: CALayer) {
        layer.shadowColor = color
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        
        layer.shadowPath = nil
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
