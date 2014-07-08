//
//  TestScene.swift
//  Imported Model
//
//  Created by Andrew K. on 7/4/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

import UIKit

class FlapyScene: Scene {
    
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
        ram.setScale(0.9)
        
        pipe = Pipe(baseEffect: baseEffect)
        pipe.initialTransformation.rotateAroundX(Matrix4.degreesToRad(-90.0), y: 0.0, z: 0.0)
        
        var sceneWidth = Float(bounds.size.width)
        var sceneHeight = Float(bounds.size.height)
        
        backgroundSquare = RatioSquare(baseEffect: baseEffect, textureName: "bg.jpg", width: sceneWidth, height: sceneHeight)
        
        super.init(name: "FlapyScene", baseEffect: baseEffect, width: sceneWidth, height: sceneHeight)
        backgroundSquare.positionZ = -sceneOffsetZ
        
        
        addChild(backgroundSquare)
        addChild(ram)
        addChild(pipe)
        
        self.prepareToDraw()
        
        positionX = 0
        positionY = 0
        positionZ = -5
        setScale(1.0)
        
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
        if (ram.positionY <= -4.8) {
            ram.positionY = -4.8
        }
    }
    
    func flap()
    {
        playerVelocity = CGPoint(x: 0.0, y: impuls)
    }
    
}
