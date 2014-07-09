//
//  TestScene.swift
//  Imported Model
//
//  Created by Andrew K. on 7/4/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

import UIKit

class FlapyScene: Scene {
    
    let gravity:CGFloat = 800.0
    let impuls:CGFloat = 500.0
    
    var ram: Ram
    var backgroundSquare: RatioSquare
    
    var pipe : Pipe
    
    let numberOfSheeps = 1
    
    var playerVelocity = CGPoint(x: 0.0, y: 0.0)
    var verticalVelocity = 0.0
    
    init(baseEffect: BaseEffect, view: UIView)
    {
        
        var sceneWidth = Float(view.bounds.size.width)
        var sceneHeight = Float(view.bounds.size.height)
        
        ram = Ram(baseEffect: baseEffect)
        ram.initialWidth = sceneWidth * 0.15
        ram.initialHeight = sceneWidth * 0.15
        ram.initialDepth = sceneWidth * 0.15
        
        
        
        pipe = Pipe(baseEffect: baseEffect)
        pipe.initialRotation.rotateAroundX(Matrix4.degreesToRad(-90.0), y: 0.0, z: 0.0)

        pipe.initialWidth = sceneWidth * 0.2
        pipe.initialHeight = sceneHeight * 0.2
        pipe.initialDepth = sceneWidth * 0.2
        
        backgroundSquare = RatioSquare(baseEffect: baseEffect, textureName: "bg.jpg", width: sceneWidth, height: sceneHeight)
        
        super.init(name: "FlapyScene", baseEffect: baseEffect, width: sceneWidth, height: sceneHeight)

        
        
        addChild(backgroundSquare)
        addChild(ram)
        addChild(pipe)
        
        self.prepareToDraw()

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
        var gravity = CGPoint(x: CGFloat(0.0) * CGFloat(delta), y: CGFloat(-self.gravity) * CGFloat(delta))
        var gravityStep = CGPoint(x: CGFloat(gravity.x) * CGFloat(delta), y: gravity.y * CGFloat(delta))
        playerVelocity = CGPoint(x: playerVelocity.x + gravity.x, y: playerVelocity.y + gravity.y)
        
        // Apply velocity
        var velocityStep = CGPoint(x: playerVelocity.x * CGFloat(delta), y: playerVelocity.y * CGFloat(delta))
        ram.positionY = Float(ram.positionY) + Float(velocityStep.y)
        // Temporary halt when hits ground
        if (ram.positionY <= 0.0-height*0.5) {
            ram.positionY = 0.0-height*0.5
            println(height)
        }
    }
    
    func flap()
    {
        playerVelocity = CGPoint(x: 0.0, y: impuls)
    }
    
}
