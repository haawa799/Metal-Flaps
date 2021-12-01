//
//  MySceneViewController.swift
//  Imported Model
//
//  Created by Andrew K. on 7/4/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

import UIKit

class FlapySceneViewController: MetalViewController,FlapyDelegate {

    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var optionsView: UIView!
    var score = 0
    var optionsVisible = false
    var flapyScene: FlapyScene!
    
    @IBAction func optionsVisibilityChange(sender: AnyObject) {
        optionsVisible = !optionsVisible
        optionsView.isHidden = optionsVisible
    }
    
    @IBAction func godMode(sender: UISwitch) {
        flapyScene.godMod = sender.isOn
    }
    @IBAction func rotation(sender: UISwitch) {
        flapyScene.rotates = sender.isOn
    }
    @IBAction func followRam(sender: UISwitch) {
        flapyScene.followRam = sender.isOn
    }
    @IBAction func wallpapersFollow(sender: UISwitch) {
        flapyScene.wallpapersFollows = sender.isOn
    }
    // UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(flap))
        self.view.addGestureRecognizer(tapGesture)
        
        let fbaseEffect = BaseEffect(device: device, vertexShaderName: "myVertexShader", fragmentShaderName: "myFragmentShader")
        fbaseEffect.lightDirection = [0.0,0.0,-1.0]
        _ = fbaseEffect.compile()
        
        flapyScene = FlapyScene(baseEffect: fbaseEffect, view: self.view)
        flapyScene.delegate = self
        setupMetal(baseEffect: fbaseEffect, scene: flapyScene!)
    }
    
    // MySceneViewController
    @objc func flap() {
        if let tScene = scene as? FlapyScene {
            tScene.flap()
        }
    }
    
    // FlapyDelegate
    func scoreIncrement() {
        score += 1
        scoreLabel!.text = "\(score)"
    }
    
    func resetScore() {
        score = 0
        scoreLabel!.text = "\(score)"
    }
    
}
