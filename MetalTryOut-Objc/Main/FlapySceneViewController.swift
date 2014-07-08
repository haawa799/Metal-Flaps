//
//  MySceneViewController.swift
//  Imported Model
//
//  Created by Andrew K. on 7/4/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

import UIKit

class FlapySceneViewController: MetalViewController {


    // UIViewController
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        var tapGesture = UITapGestureRecognizer(target: self, action: Selector.convertFromStringLiteral("flap"))
        self.view.addGestureRecognizer(tapGesture)
        
        var fbaseEffect = BaseEffect(device: device, vertexShaderName: "myVertexShader", fragmentShaderName: "myFragmentShader")
        fbaseEffect.lightDirection = [0.0,1.0,-1.0]
        fbaseEffect.compile()
        
        //
        
        var fscene = FlapyScene(baseEffect: fbaseEffect, bounds: self.view.bounds)
        setupMetal(fbaseEffect, scene: fscene)
    }
    
    // MySceneViewController
    
    func flap()
    {
        if let tScene = scene as? FlapyScene
        {
            tScene.flap()
        }
    }
    
}
