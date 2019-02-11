//
//  ActionSheetX.swift
//  CustomActionSheet
//
//  Created by Anirudha Mahale on 11/02/19.
//  Copyright © 2019 Anirudha Mahale. All rights reserved.
//

import UIKit

class ActionSheetX: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var backgroundView: UIView!
    private var backgroundViewTransparent: UIView!
    // private var hideViewBottomConstraint: NSLayoutConstraint!
    private var offset: CGFloat = 300
    
    func setupView(_ title: String, buttons: [UIButton]) {
        // backgroundViewTransparent
        backgroundViewTransparent = UIView()
        backgroundViewTransparent.translatesAutoresizingMaskIntoConstraints = false
        backgroundViewTransparent.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        self.addSubview(backgroundViewTransparent)
        
        backgroundViewTransparent.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        backgroundViewTransparent.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        backgroundViewTransparent.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundViewTransparent.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        // backgroundView
        backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = .white
        
        self.addSubview(backgroundView)
        
        // backgroundView.heightAnchor.constraint(equalToConstant: 230).isActive = true
        let safeArea = self.layoutMarginsGuide
        backgroundView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        // title label
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        
        backgroundView.addSubview(titleLabel)
        
        titleLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20).isActive = true
        
        var stackViewSubviews = [UIView]()
        for button in buttons {
            let image = UIImageView()
            image.image = button.imageView?.image ?? UIImage(named: "wifi.png")
            
            let label = UILabel()
            label.text = button.titleLabel?.text ?? ""
            
            let stackView = UIStackView(arrangedSubviews: [image, label])
            stackView.axis = .vertical
            stackView.spacing = 8
            stackView.alignment = .center
            
            stackViewSubviews.append(stackView)
        }
        
        let stackView = UIStackView(arrangedSubviews: stackViewSubviews)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 16
        
        backgroundView.addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        stackView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor).isActive = true
        
        let horizontalLine = UIView()
        horizontalLine.backgroundColor = UIColor.red
        // set background color #F1F9FF
        horizontalLine.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.addSubview(horizontalLine)
        
        horizontalLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        horizontalLine.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8).isActive = true
        horizontalLine.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        horizontalLine.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.addSubview(button)
        button.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: horizontalLine.bottomAnchor, constant: 8).isActive = true
        
        button.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -8).isActive = true
        
        button.addTarget(self, action: #selector(self.hide), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hide))
        backgroundViewTransparent.addGestureRecognizer(tapGesture)
        
        UIApplication.shared.keyWindow?.addSubview(self)
        backgroundViewTransparent.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        
        backgroundView.transform = .init(translationX: 0, y: offset)
    }
    
    func show() {
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundViewTransparent.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            self.backgroundView.transform = .identity
        })
    }
    
    @objc func hide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundViewTransparent.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.backgroundView.transform = .init(translationX: 0, y: self.offset)
        }) { (_) in
            self.removeFromSuperview()
        }
    }
}
