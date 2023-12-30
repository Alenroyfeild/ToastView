//
//  MessageView.swift
//  ToastView
//
//  Created by BalajiRoyal on 08/11/23.
//

import UIKit

class MessageView: UIView {
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = primaryTextColor
        label.font = messageFont
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = primaryTextColor
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let loadingProgressIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.tintColor = primarySurfaceColor
        view.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var bgView = UIUtil.createVisualEffectsView(traitCollection: traitCollection)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(bgView)
        addSubview(loadingProgressIndicator)
        addSubview(imageView)
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            bgView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bgView.topAnchor.constraint(equalTo: topAnchor),
            bgView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bgView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            loadingProgressIndicator.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -4),
            loadingProgressIndicator.widthAnchor.constraint(equalToConstant: 18),
            loadingProgressIndicator.heightAnchor.constraint(equalToConstant: 18),
            loadingProgressIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            imageView.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -4),
            imageView.widthAnchor.constraint(equalToConstant: 18),
            imageView.heightAnchor.constraint(equalToConstant: 18),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 9),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 4),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -4),
        ])
    }
    
    func startSyncAnimation() {
        imageView.isHidden = true
        loadingProgressIndicator.startAnimating()
    }
    
    func stopSyncAnimation() {
        loadingProgressIndicator.stopAnimating()
    }
    
    func showPrefixImage(image: UIImage) {
        loadingProgressIndicator.isHidden = true
        imageView.image = image
        imageView.isHidden = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
