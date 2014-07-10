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
    var heightBetween: Float
    
    var upperPipe: Pipe
    var botPipe: Pipe
    
    var midPoint: Float
    
    init(name: String, baseEffect:BaseEffect, heightBetween: Float, height: Float, width: Float)
    {
        self.width = width
        self.height = height
        
        upperPipe = Pipe(baseEffect: baseEffect)
        botPipe = Pipe(baseEffect: baseEffect)
        midPoint = 0
        self.heightBetween = heightBetween
        
        super.init(name: name, baseEffect: baseEffect, vertices: nil, vertexCount: 0, textureName: nil)
        
        upperPipe.initialRotation.rotateAroundX(Matrix4.degreesToRad(90.0), y: 0.0, z: 0.0)
        upperPipe.initialWidth = width
        upperPipe.initialHeight = width
        upperPipe.initialDepth = width
        upperPipe.positionY = midPoint + heightBetween * 0.5
        
        
        botPipe.initialRotation.rotateAroundX(Matrix4.degreesToRad(-90.0), y: 0.0, z: 0.0)
        botPipe.initialWidth = width
        botPipe.initialHeight = width
        botPipe.initialDepth = width
        botPipe.positionY = midPoint - heightBetween * 0.5
        
        self.addChild(upperPipe)
        self.addChild(botPipe)

    }
    
    func changeMidPointToRandomPoint(previous: PipeWall)
    {
        
        var margin = height * 0.3
        var h = (height - 2*margin)*0.5
        
        var posY = previous.midPoint + Float(drand48())*Float(h) - h*0.5
        if posY <= -(height*0.5 - margin)
        {
            posY = -(height*0.5 - margin)
        }
        if posY >= (height*0.5 - margin)
        {
            posY = (height*0.5 - margin)
        }
        
        midPoint = posY
        botPipe.positionY = midPoint - heightBetween * 0.5
        upperPipe.positionY = midPoint + heightBetween * 0.5
    }
    
    func anyPipeIntersectsWithRect(rect:CGRect) -> Bool
    {
        
        var rectUp = upperPipe.rect2DInParentsCoords()
        rectUp = CGRect(x: CGFloat(rectUp.origin.x + CGFloat(positionX)), y: CGFloat(rectUp.origin.y + CGFloat(positionY)), width: rectUp.size.width , height: rectUp.size.width)
        
        var rectBot = botPipe.rect2DInParentsCoords()
        rectBot = CGRect(x: CGFloat(rectBot.origin.x + CGFloat(positionX)), y: CGFloat(rectBot.origin.y + CGFloat(positionY)), width: rectBot.size.width , height: rectBot.size.width)
        
        var intersects = rect.intersects(rectUp) | rect.intersects(rectBot)
        return intersects
    }
}
