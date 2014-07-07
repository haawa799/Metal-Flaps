//
//  MySceneViewController.swift
//  Imported Model
//
//  Created by Andrew K. on 7/4/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

import UIKit

class MySceneViewController: MetalViewController {

//    var scene: TestScene!
//    var baseEffect: BaseEffect!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        var tapGesture = UITapGestureRecognizer(target: self, action: Selector.convertFromStringLiteral("flap"))
        self.view.addGestureRecognizer(tapGesture)
        
        var fbaseEffect = BaseEffect(device: device, vertexShaderName: "myVertexShader", fragmentShaderName: "myFragmentShader")
        fbaseEffect.lightDirection = [0.0,1.0,-1.0]
        var ratio: Float = Float(self.view.bounds.size.width) / Float(self.view.bounds.size.height)
        fbaseEffect.projectionMatrix = Matrix4.makePerspectiveViewAngle(Matrix4.degreesToRad(85.0), aspectRatio: ratio, nearZ: 1.0, farZ: 150.0)
        fbaseEffect.compile()
        
        //
        
        var fscene = TestScene(baseEffect: fbaseEffect, bounds: self.view.bounds)
        setupMetal(fbaseEffect, scene: fscene)
    }
    
    override func tearDownMetal()
    {
        scene = nil
        baseEffect = nil
    }
    
    override func update(elapsed: CFTimeInterval)
    {
        
        var matrix: Matrix4 = Matrix4()
        scene!.render(commandQ, metalView: metalView, parentMVMatrix: matrix)
        scene!.updateWithDelta(elapsed)
    }
    
    func flap()
    {
        if let tScene = scene as? TestScene
        {
            tScene.flap()
        }
    }
    
}
