//
//  RatioSquare.swift
//  Metal Flaps
//
//  Created by Andrew K. on 7/5/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

import UIKit

class RatioSquare: Square {
   
    var ratio: Float
    
    init(baseEffect: BaseEffect, textureName: String?, width: Float, height: Float)
    {
        self.ratio = height/width
        
        super.init(baseEffect: baseEffect, textureName: textureName)
        
        self.scaleX = width
        self.scaleY = height
    }
    
    override func updateWithDelta(delta: CFTimeInterval)
    {
        
    }
}
