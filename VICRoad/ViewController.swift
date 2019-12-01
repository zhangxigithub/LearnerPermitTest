//
//  ViewController.swift
//  VICRoad
//
//  Created by zhangxi on 2018/6/3.
//  Copyright © 2018 zhangxi. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController {

    
    @IBOutlet weak var testButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testButton.makeCircle()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func showWeb(_ sender: Any) {
        
        let vc = SFSafariViewController(url: URL(string: "https://www.vicroads.vic.gov.au")!)
        vc.preferredBarTintColor = RightColor
        vc.preferredControlTintColor = .white
        self.present(vc, animated: true)
        
    }
    


}

