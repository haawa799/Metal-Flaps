//
//  MetalViewController.swift
//  Triangle
//
//  Created by Andrew K. on 6/24/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//


import UIKit
import QuartzCore
import Metal

class MetalViewController: UIViewController,MetalViewProtocol {
    
    var metalView: MetalView!
    
    let device: MTLDevice = MTLCreateSystemDefaultDevice()
    var commandQ: MTLCommandQueue?
    var scene: Scene?
    var baseEffect: BaseEffect?
    
    var fpsLabel: UILabel!
    
    //UIViewController
    init(coder aDecoder: NSCoder!)
    {
        super.init(coder: aDecoder)
    }
    
    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        metalView = self.view as? MetalView
        metalView.metalViewDelegate = self
        
        commandQ = device.newCommandQueue()
        _displayLink = CADisplayLink(target: self, selector: Selector.convertFromStringLiteral("_newFrame:"))
        _displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    deinit{
        tearDownMetal()
    }
    
    // Node
    
    func update(elapsed: CFTimeInterval)
    {
        scene!.updateWithDelta(elapsed)
    }
    
    //MetalViewController
    
    func setupMetal(baseEffect: BaseEffect, scene: Scene){
        
        self.baseEffect = baseEffect
        self.scene = scene
    }
    
    func tearDownMetal(){
        baseEffect = nil
        scene = nil
        commandQ = nil
        fpsLabel = nil
    }
    
    // MetalViewDelegate
    func render(metalView : MetalView)
    {
        if let commandQ = commandQ
        {
            var matrix: Matrix4 = Matrix4()
            scene!.render(commandQ, metalView: metalView, parentMVMatrix: matrix)
        }
    }
    
    func reshape(metalView : MetalView)
    {
        if let baseEffect = baseEffect
        {
            var ratio: Float = Float(self.view.bounds.size.width) / Float(self.view.bounds.size.height)
            baseEffect.projectionMatrix = Matrix4.makePerspectiveViewAngle(Matrix4.degreesToRad(85.0), aspectRatio: ratio, nearZ: 1.0, farZ: 150.0)
        }
    }
    
    
    //Private
    var _displayLink: CADisplayLink!
    var _lastFrameTimestamp: CFTimeInterval!
    var _gameLoopPaused: Bool!
    
    
    func _newFrame(displayLink: CADisplayLink){
        
        if _lastFrameTimestamp == nil
        {
            _lastFrameTimestamp = displayLink.timestamp
        }
        
        var elapsed:CFTimeInterval = displayLink.timestamp - _lastFrameTimestamp
        metalView.fpsLabel!.text = "fps: \(Int(1.0/elapsed))"
        _lastFrameTimestamp = displayLink.timestamp
        metalView.display()
        
        update(elapsed)
    }
}
