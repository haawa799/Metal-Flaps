//
//  TestScene.swift
//  Imported Model
//
//  Created by Andrew K. on 7/4/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

import UIKit
import AVFoundation

protocol FlapyDelegate
{
    func scoreIncrement()
    func resetScore()
}

class FlapyScene: Scene {
    
    var godMod = false
    var rotates = false
    var followRam = false
    var wallpapersFollows = false
    
    var delegate: FlapyDelegate?
    
    let gravity:CGFloat = 500.0
    let impuls:CGFloat = 180.0
    
    var sceneWidth:Float = 0.0
    var sceneHeight:Float = 0.0
    
    var ram: Ram
    var backgroundSquare: RatioSquare
    
    var pipeWalls : [PipeWall]
    let numberOfPipes = 4
    let startDelta:Float = 0.0
    
    var playerVelocity = CGPoint(x: 0.0, y: 0.0)
    var verticalVelocity = 0.0
    var gap:Float = 0.0
    var startOffset: Float = 0.0
    
    var pipeWidth:Float = 0.0
    
    let pipesVelocity:Float = 130.0
    
    var timePerPipeChange:Float = 0.0
    var timeSinceLastPipe:Float = 0.0
    
    //States
    var isPaused = true
    
    init(baseEffect: BaseEffect, view: UIView)
    {
        
        sceneWidth = Float(view.bounds.size.width)
        sceneHeight = Float(view.bounds.size.height)
        
        pipeWidth = sceneWidth * 0.2
        
        gap = (sceneWidth - 2*pipeWidth) * 0.5
        startOffset = sceneWidth + startDelta
        
        ram = Ram(baseEffect: baseEffect)
        pipeWalls = Array<PipeWall>()
        backgroundSquare = RatioSquare(baseEffect: baseEffect, textureName: "bg.jpg", width: sceneWidth, height: sceneHeight)
        
        timePerPipeChange = (gap + pipeWidth) / pipesVelocity
        
        super.init(name: "FlapyScene", baseEffect: baseEffect, width: sceneWidth, height: sceneHeight)

        for var i = 0; i<numberOfPipes; i++
        {
            var pipe = PipeWall(name: "pipeWall\(i)", baseEffect: baseEffect, heightBetween: 2*pipeWidth, height: sceneHeight, width: pipeWidth)
            pipe.positionX = startOffset + (gap + pipeWidth)*Float(i)
            pipe.positionZ = sceneWidth * 0.2
            pipe.tag = i
            pipeWalls.append(pipe)
            addChild(pipe)
        }
        
        ram.initialWidth = sceneWidth * 0.15
        ram.initialHeight = sceneWidth * 0.15
        ram.initialDepth = sceneWidth * 0.15
        ram.positionZ = sceneWidth * 0.2
        ram.positionX = sceneWidth * -0.2
        
        addChild(backgroundSquare)
        addChild(ram)
        
        self.prepareToDraw()

    }
    
    override func updateWithDelta(delta: CFTimeInterval)
    {
        if rotates
        {
            rotationY += Float(M_PI/8) * Float(delta)
        }
        
        if isPaused == false
        {
            timeSinceLastPipe += Float(delta)
            if timeSinceLastPipe >= timePerPipeChange
            {
                timeSinceLastPipe = 0
                delegate?.scoreIncrement()
            }
            
            updatePlayer(delta)
            updatePipes(delta)
            for child in children
            {
                child.updateWithDelta(delta)
            }
            
            if godMod == false
            {
                collisionCheck()
            }
        }
    }
    
    func collisionCheck()
    {
        for pipe in pipeWalls
        {
            if pipe.anyPipeIntersectsWithRect(ram)
            {
                gameOver()
                break;
            }
        }
    }
    
    func updatePipes(delta: CFTimeInterval)
    {
        var deltaX = Float(delta) * pipesVelocity
        
        for pipe in pipeWalls
        {
            pipe.positionX -= deltaX
            var leftMargin:Float = sceneWidth + pipe.width
            if pipe.positionX <= -leftMargin
            {
                var tag = pipe.tag - 1
                if tag == -1
                {
                    tag = numberOfPipes - 1
                }
                
                pipe.positionX = pipeWalls[tag].positionX + gap + pipe.width
                pipe.changeMidPointToRandomPoint(pipeWalls[tag])
            }
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
        if (ram.positionY <= 0.0-height*0.39) {
            ram.positionY = 0.0-height*0.39
        }
        
        if (ram.positionY >= 0.0+height*0.38) {
            ram.positionY = 0.0+height*0.38
        }
        
        if followRam
        {
            self.positionY = -ram.positionY
        }
        
        if wallpapersFollows
        {
            self.backgroundSquare.positionY = ram.positionY
        }
    }
    
    func flap()
    {
        if isPaused == true
        {
            isPaused = false
        }
        playerVelocity = CGPoint(x: 0.0, y: impuls)
//        playPop()
    }
    
    func gameOver()
    {
        isPaused = true
        delegate?.resetScore()
        
        resetPipes()
    }
    
    func resetPipes()
    {
        for var i = 0; i<numberOfPipes; i++
        {
            var pipe = pipeWalls[i]
            pipe.positionX = startOffset + (gap + pipeWidth)*Float(i)
            pipe.positionZ = sceneWidth * 0.2
        }
    }
    
    func playSoundWithName(name: String)
    {
        var path = NSBundle.mainBundle().pathForResource(name, ofType: nil)
        var url = NSURL(fileURLWithPath: path!)
        var player = AVAudioPlayer(contentsOfURL: url, error: nil)
        player.volume = 1.0
        player.play()
    }
    
}
