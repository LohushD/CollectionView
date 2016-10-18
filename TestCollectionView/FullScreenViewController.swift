//
//  FullScreenViewController.swift
//  TestCollectionView
//
//  Created by Dmytro Lohush on 10/18/16.
//  Copyright © 2016 tester. All rights reserved.
//

import UIKit

class FullScreenViewController: UIViewController {
    var data: CellEntity?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        if data != nil {
            imageView.image = UIImage(color: data!.colour)
            label.text = data!.text
        }
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(FullScreenViewController.handleTap)))
    }
    
    func handleTap(){
        dismissViewControllerAnimated(true, completion: nil)
    }
}
