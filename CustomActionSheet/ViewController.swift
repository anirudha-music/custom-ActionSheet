//
//  ViewController.swift
//  CustomActionSheet
//
//  Created by Anirudha Mahale on 11/02/19.
//  Copyright © 2019 Anirudha Mahale. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let button = UIButton()
    let button2 = UIButton()
    let button3 = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        button.setTitle("Hello", for: .normal)
        button2.setTitle("Bello", for: .normal)
        button3.setTitle("Wello", for: .normal)
        
        print(self.view.bounds)
    }

    @IBAction func didTapActionSheet(_ sender: Any) {
        let actionSheet = ActionSheetX(frame: self.view.bounds)
        actionSheet.setupView("Select image", buttons: [button, button2, button3])
        actionSheet.show()
    }
}

