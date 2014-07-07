//
//  TestScene.swift
//  Imported Model
//
//  Created by Andrew K. on 7/4/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

import UIKit

class TestScene: Scene {
    
    let gravity:CGFloat = 8.0
    let impuls:CGFloat = 5.0
    
    var ram: Ram
    var backgroundSquare: RatioSquare
    
    var pipe : Pipe
    
    let numberOfSheeps = 1
    
    var playerVelocity = CGPoint(x: 0.0, y: 0.0)
    var verticalVelocity = 0.0
    
    init(baseEffect: BaseEffect, bounds: CGRect)
    {
        ram = Ram(baseEffect: baseEffect)
        pipe = Pipe(baseEffect: baseEffect)
        let width:Float = 3.1
        backgroundSquare = RatioSquare(baseEffect: baseEffect, textureName: "bg.jpg", width: width, height: Float(bounds.size.height)/Float(bounds.size.width)*width
            
        )
        
        super.init(name: "TestScene", baseEffect: baseEffect)
        
        backgroundSquare.positionZ = -2
        children.append(backgroundSquare)
        children.append(ram)
        children.append(pipe)
        
        positionX = 0
        positionY = 0
        positionZ = -5
        setScale(1.0)
        
        ram.setScale(0.9)
        pipe.positionX -= 2.0
    }
    
    override func updateWithDelta(delta: CFTimeInterval)
    {
        updatePlayer(delta)
        for child in children
        {
            child.updateWithDelta(delta)
        }
    }
    
    
    func updatePlayer(delta: CFTimeInterval)
    {
        // Apply gravity
        var gravity = CGPoint(x: 0.0 * delta, y: -self.gravity * delta)
        var gravityStep = CGPoint(x: gravity.x * delta, y: gravity.y * delta)
        playerVelocity = CGPoint(x: playerVelocity.x + gravity.x, y: playerVelocity.y + gravity.y)//CGPointAdd(playerVelocity, gravityStep)
        
        // Apply velocity
        var velocityStep = CGPoint(x: playerVelocity.x * delta, y: playerVelocity.y * delta)
        ram.positionZ = Float(ram.positionZ) + Float(velocityStep.y)
        // Temporary halt when hits ground
        if (ram.positionZ <= -4.8) {
            ram.positionZ = -4.8
        }
    }
    
    func flap()
    {
        playerVelocity = CGPoint(x: 0.0, y: impuls)
    }
    
}
