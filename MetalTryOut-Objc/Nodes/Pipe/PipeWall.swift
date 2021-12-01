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
        
        upperPipe.initialRotation.rotateAroundX(Matrix4.degrees(toRad: 90.0), y: 0.0, z: 0.0)
        upperPipe.initialWidth = width
        upperPipe.initialHeight = width
        upperPipe.initialDepth = width
        upperPipe.positionY = midPoint + heightBetween * 0.5
        
        
        botPipe.initialRotation.rotateAroundX(Matrix4.degrees(toRad: -90.0), y: 0.0, z: 0.0)
        botPipe.initialWidth = width
        botPipe.initialHeight = width
        botPipe.initialDepth = width
        botPipe.positionY = midPoint - heightBetween * 0.5
        
        self.addChild(child: upperPipe)
        self.addChild(child: botPipe)

    }
    
    func changeMidPointToRandomPoint(previous: PipeWall)
    {
        
        let margin = height * 0.3
        let h = (height - 2*margin)*0.5
        
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
    
    func anyPipeIntersectsWithRect(ram:Node) -> Bool
    {
        let l:Float = height
        let k:Float = height*0.5 + midPoint
        let q:Float = heightBetween*0.5
        
        let botHeight:Float = k - q
        let upHeight:Float = l - k - q
        
        
        let ramR = nodeRect(node: ram)
        
        let rectWall = CGRect(x: CGFloat(positionX-width*0.5), y: CGFloat(0-height*0.5), width: CGFloat(width), height: CGFloat(height))
        
        
        let rUp = CGRect(x: rectWall.origin.x, y: rectWall.origin.y + CGFloat(botHeight) + CGFloat(heightBetween), width: rectWall.size.width, height: CGFloat(upHeight))
        
        let rDown = CGRect(x: rectWall.origin.x, y: rectWall.origin.y, width: rectWall.size.width, height: CGFloat(botHeight))
        
        
        let intersects = ramR.intersects(rDown) || ramR.intersects(rUp)
        return intersects
    }
    
    func nodeRect(node: Node) -> CGRect
    {
        var nodeWidth = node.scaleX
        if let nodeInitialWidth = node.initialWidth
        {
            nodeWidth *= nodeInitialWidth
        }
        var nodeHeight = node.scaleY
        if let nodeInitialHeight = node.initialHeight
        {
            nodeHeight *= nodeInitialHeight
        }
        let x = -nodeWidth*0.5 + node.positionX
        let y =  node.positionY
        
        let rect = CGRect(x: CGFloat(x), y: CGFloat(y), width: CGFloat(nodeWidth), height: CGFloat(nodeHeight))
        return rect
    }
}
