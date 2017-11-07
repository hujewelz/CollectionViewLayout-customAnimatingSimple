//
//  PresentedViewController.swift
//  UICollectionViewLayoutSimple
//
//  Created by jewelz on 2017/8/3.
//  Copyright © 2017年 jewelz. All rights reserved.
//

import UIKit

class PresentedViewController: UIViewController {
    
    @IBOutlet private weak var button: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var imageWidthConstrain: NSLayoutConstraint!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
    
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        imageWidthConstrain.constant = view.frame.width - 40
        imageHeightConstraint.constant =  imageWidthConstrain.constant * image.size.height / image.size.width
        
        imageView.image = image
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        super.viewWillAppear(animated)
        view.bringSubview(toFront: button)
    }

    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
