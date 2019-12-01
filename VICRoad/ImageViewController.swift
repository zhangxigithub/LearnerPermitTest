//
//  ImageViewController.swift
//  VICRoad
//
//  Created by zhangxi on 2018/6/4.
//  Copyright © 2018 zhangxi. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    
    static func showImage(image:UIImage?,frame:CGRect,parent:UIViewController)
    {
        
        let vc = ImageViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        
        vc.imageView.image = image
        vc.imageView.frame = frame
        

        parent.present(vc, animated: true)
        
    }
    
    var imageView = UIImageView()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.2) {
            self.imageView.frame.size.width = 300
            self.imageView.frame.size.height = 300
            self.imageView.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.view.addSubview(imageView)
        imageView.isUserInteractionEnabled = false
        imageView.contentMode = .scaleAspectFit

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true)
    }

    


}
