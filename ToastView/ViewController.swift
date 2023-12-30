//
//  ViewController.swift
//  ToastView
//
//  Created by BalajiRoyal on 06/11/23.
//

import UIKit

class ViewController: UIViewController {
    let parentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .yellow
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    let positionsTV: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.layer.borderColor = UIColor.label.cgColor
        tv.layer.cornerRadius = 8
        tv.clipsToBounds = true
        tv.layer.borderWidth = 0.5
        return tv
    }()
    
    private lazy var sharedButton:UIButton = {
        let button=createButton()
        button.addTarget(self, action: #selector(btnSharedAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var isolatedButton:UIButton = {
        let button=createButton()
        button.addTarget(self, action: #selector(btnIsolatedAction), for: .touchUpInside)
        return button
    }()
    
    private let sharedLabel:UILabel = {
        let text=UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .left
        text.text = "Shared"
        text.textColor = UIColor(hexString: "#0B7BC3")
        return text
    }()
    
    private let isolatedLabel:UILabel = {
        let text=UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .left
        text.text = "Isolated"
        text.textColor = UIColor(hexString: "#0B7BC3")
        return text
    }()
    
    private let messageTF: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = "Toast Message"
        textField.placeholder = "Enter Toast Message"
        textField.textColor = .label
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    let positions: [ToastView.Position] = ToastView.Position.allCases
    var toastType: ToastView.type = .shared
    var modeType: ToastView.Mode = .showProgress
    var message: String {
        get {
            messageTF.text ?? "Toast Message is Empty"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    func setUpViews() {
        positionsTV.delegate = self
        positionsTV.dataSource = self
        positionsTV.register(UITableViewCell.self, forCellReuseIdentifier: "ToastViewPositionCell")
        
        view.addSubview(positionsTV)
        
        let tableViewNameLabel = createTitleLabel(text: "Positions List")
        view.addSubview(tableViewNameLabel)
        
        let instanceLabel = createTitleLabel(text: "Instance Type")
        instanceLabel.textAlignment = .left
        view.addSubview(instanceLabel)
        
        view.addSubview(instanceStack)
        
        let modeLabel = createTitleLabel(text: "Mode Type")
        modeLabel.textAlignment = .left
        view.addSubview(modeLabel)
        
        view.addSubview(modeStack)
        
        view.addSubview(messageTF)
        
        view.addSubview(parentView)
        
        NSLayoutConstraint.activate([
            tableViewNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableViewNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            tableViewNameLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor),
            
            positionsTV.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            positionsTV.topAnchor.constraint(equalTo: tableViewNameLabel.bottomAnchor, constant: 16),
            positionsTV.widthAnchor.constraint(equalToConstant: view.frame.width / 2),
            positionsTV.heightAnchor.constraint(equalToConstant: (view.frame.width / 2) * 1.25),
            
            messageTF.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            messageTF.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            messageTF.heightAnchor.constraint(equalToConstant: 44),
            messageTF.topAnchor.constraint(equalTo: positionsTV.bottomAnchor, constant: 24),
            
            instanceLabel.leadingAnchor.constraint(equalTo: positionsTV.trailingAnchor, constant: 16),
            instanceLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            instanceLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            instanceStack.leadingAnchor.constraint(equalTo: instanceLabel.leadingAnchor),
            instanceStack.trailingAnchor.constraint(equalTo: instanceLabel.trailingAnchor),
            instanceStack.topAnchor.constraint(equalTo: instanceLabel.bottomAnchor, constant: 16),
            instanceStack.heightAnchor.constraint(equalToConstant: 48),
            
            modeLabel.leadingAnchor.constraint(equalTo: positionsTV.trailingAnchor, constant: 16),
            modeLabel.topAnchor.constraint(equalTo: instanceStack.bottomAnchor, constant: 20),
            modeLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            modeStack.leadingAnchor.constraint(equalTo: modeLabel.leadingAnchor),
            modeStack.trailingAnchor.constraint(equalTo: modeLabel.trailingAnchor),
            modeStack.topAnchor.constraint(equalTo: modeLabel.bottomAnchor, constant: 16),
            modeStack.heightAnchor.constraint(equalToConstant: 48),
            
            parentView.heightAnchor.constraint(equalToConstant: view.frame.width * 0.65),
            parentView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.65),
            parentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            parentView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        sharedButton.isSelected = true
        loadingModeBtn.isSelected = true
        messageTF.delegate = self
    }
    
    func createButton() -> UIButton {
        let button=UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setImage(UIImage(systemName: "circle"),for: .normal)
        button.setImage(UIImage(systemName: "circle.fill"), for: .selected)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.widthAnchor.constraint(equalToConstant: 20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        button.layer.borderColor = UIColor.link.cgColor
        button.layer.borderWidth = 0.5
        return button
    }
    
    func createTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17)
        return label
    }
    
    func createNameLabel(text: String) -> UILabel {
        let label=UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = text
        label.textColor = UIColor(hexString: "#0B7BC3")
        return label
    }
    
    private lazy var sharedstack:UIStackView = {
        createHorizontalStack(views: [sharedButton,createNameLabel(text: "Shared")])
    }()
    
    private lazy var isolatedstack:UIStackView = {
        createHorizontalStack(views: [isolatedButton,createNameLabel(text: "Isolated")])
    }()
    
    private lazy var loadingModeStack: UIStackView = {
        createHorizontalStack(views: [loadingModeBtn,createNameLabel(text: "Loading")])
    }()
    
    private lazy var imageModeStack: UIStackView = {
        createHorizontalStack(views: [imageModeBtn,createNameLabel(text: "Image")])
    }()
    
    private func createHorizontalStack(views: [UIView]) -> UIStackView {
        let stack=UIStackView(arrangedSubviews: views)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 4
        stack.distribution = .fillProportionally
        return stack
    }
    
    private func createVerticalStack(stackViews: [UIStackView]) -> UIStackView {
        let stack=UIStackView(arrangedSubviews: stackViews)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }
    
    private lazy var instanceStack: UIStackView = {
        createVerticalStack(stackViews: [sharedstack,isolatedstack])
    }()
    
    private lazy var modeStack: UIStackView = {
        createVerticalStack(stackViews: [loadingModeStack,imageModeStack])
    }()
    
    private lazy var loadingModeBtn: UIButton = {
        let button = createButton()
        button.addTarget(self, action: #selector(btnLoadingAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var imageModeBtn: UIButton = {
        let button = createButton()
        button.addTarget(self, action: #selector(btnImageAction), for: .touchUpInside)
        return button
    }()
    
    @objc private func btnLoadingAction(_ sender: UIButton) {
        sender.isSelected = true
        imageModeBtn.isSelected = false
        modeType = .showProgress
    }
    
    @objc private func btnImageAction(_ sender: UIButton) {
        sender.isSelected = true
        loadingModeBtn.isSelected = false
        modeType = .showPrefixImage(image: UIImage(systemName: "exclamationmark.circle.fill")!)
    }
    
    @objc private func btnSharedAction(_ sender: UIButton) {
        sender.isSelected = true
        isolatedButton.isSelected = false
        toastType = .shared
    }
    
    @objc private func btnIsolatedAction(_ sender: UIButton) {
        sender.isSelected = true
        sharedButton.isSelected = false
        toastType = .isolated
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        positions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.translatesAutoresizingMaskIntoConstraints = false
        cell.textLabel?.text = positions[indexPath.row].rawValue
        cell.textLabel?.textColor = .label
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        let position = positions[indexPath.row]
        checkAndShowToastMessage(position: position)
    }
    
    func checkAndShowToastMessage(position: ToastView.Position) {
        switch toastType {
        case .shared:
            ToastView.shared.showToast(message: message, on: parentView, position: position, autoHide: true, mode: modeType, haptic: nil)
        case .isolated:
            ToastView().showToast(message: message, on: parentView, position: position, autoHide: true, mode: modeType, haptic: nil)
        }
    }
}
