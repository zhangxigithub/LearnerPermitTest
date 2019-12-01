//
//  Untilities.swift
//  VICRoad
//
//  Created by zhangxi on 2018/6/4.
//  Copyright © 2018 zhangxi. All rights reserved.
//

import Foundation
import UIKit


extension UIView
{
    func makeCircle()
    {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.width/2
    }
    
}
