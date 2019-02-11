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
        backgroundViewTransparent.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        self.addSubview(backgroundViewTransparent)
        
        backgroundViewTransparent.addConstraints([
            equal(self, \.topAnchor),
            equal(self, \.bottomAnchor),
            equal(self, \.leadingAnchor),
            equal(self, \.trailingAnchor)
            ])
        
        // backgroundView
        backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = .white
        
        self.addSubview(backgroundView)
        
        let safeArea = self.layoutMarginsGuide
        backgroundView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        
        // title label
        let titleLabel = UILabel()
        titleLabel.text = title
        
        backgroundView.addSubview(titleLabel)
        
        titleLabel.addConstraints([
            equal(backgroundView, \.topAnchor, constant: 20),
            equal(backgroundView, \.trailingAnchor, constant: 20),
            equal(backgroundView, \.leadingAnchor, constant: 20)
            ])
        
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
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 16
        
        backgroundView.addSubview(stackView)
        
        stackView.addConstraints([
            equal(titleLabel, \.topAnchor, \.bottomAnchor, constant: 8),
            equal(backgroundView, \.centerXAnchor),
            equal(backgroundView, \.centerYAnchor)
            ])
        
        let horizontalLine = UIView()
        horizontalLine.backgroundColor = UIColor.red
        // set background color #F1F9FF
        
        backgroundView.addSubview(horizontalLine)
        
        horizontalLine.addConstraints([
            equal(\.heightAnchor, to: 1),
            equal(stackView, \.topAnchor, \.bottomAnchor, constant: 8),
            equal(backgroundView, \.leadingAnchor),
            equal(backgroundView, \.trailingAnchor)
            ])
        
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.red, for: .normal)
        
        backgroundView.addSubview(button)
        
        button.addConstraints([
            equal(backgroundView, \.centerXAnchor),
            equal(horizontalLine, \.topAnchor, \.bottomAnchor, constant: 8),
            equal(backgroundView, \.bottomAnchor, constant: -8)
            ])
        
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
