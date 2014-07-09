//
//  PipeWall.swift
//  Metal Flaps
//
//  Created by Andrew K. on 7/9/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

import UIKit

class PipeWall: Node {
   
    var width: Float
    var height: Float
    
    init(name: String, baseEffect:BaseEffect, heightBetween: Float, height: Float, width: Float)
    {
        self.width = width
        self.height = height
        
        super.init(name: name, baseEffect: baseEffect, vertices: nil, vertexCount: 0, textureName: nil)
        
        var upperPipe = Pipe(baseEffect: baseEffect)
        upperPipe.initialRotation.rotateAroundX(Matrix4.degreesToRad(90.0), y: 0.0, z: 0.0)
        upperPipe.initialWidth = width
        upperPipe.initialHeight = width//(height - heightBetween)/2
        upperPipe.initialDepth = width
        upperPipe.positionY += heightBetween * 0.5
        
        
        var botPipe = Pipe(baseEffect: baseEffect)
        botPipe.initialRotation.rotateAroundX(Matrix4.degreesToRad(-90.0), y: 0.0, z: 0.0)
        botPipe.initialWidth = width
        botPipe.initialHeight = width//(height - heightBetween)/2
        botPipe.initialDepth = width
        botPipe.positionY -= heightBetween * 0.5
        
        self.addChild(upperPipe)
        self.addChild(botPipe)
        
    }
    
}
