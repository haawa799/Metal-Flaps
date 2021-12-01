//
//  MetalView.swift
//  Triangle
//
//  Created by Andrew K. on 6/24/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

import UIKit
import QuartzCore
import Metal

@objc public protocol MetalViewProtocol
{
    @objc func render(metalView : MetalView)
    @objc func reshape(metalView : MetalView)
}

@objc public class MetalView: UIView
{
    //Public API
    
    @objc public var metalViewDelegate: MetalViewProtocol?
    var frameBuffer: AnyObject!
    
    func setFPSLabelHidden(hidden: Bool){
        if let label = fpsLabel{
            label.isHidden = hidden
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
        setup()
    }
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
        setup()
    }
    
    func display()
    {
        let frameBuf = frameBuffer as! FrameBuffer
        
        frameBuf.drawableSize = self.bounds.size
        
        frameBuf.drawableSize.width  *= self.contentScaleFactor;
        frameBuf.drawableSize.height *= self.contentScaleFactor;
        
        var size = self.bounds.size
        
        size.width  *= self.contentScaleFactor
        size.height *= self.contentScaleFactor
        
        frameBuf.display(withDrawableSize: size)
    }
    
    //Private
    var lastFrameTimestamp: CFTimeInterval?
    var _metalLayer: CAMetalLayer!
    var fpsLabel: UILabel!
    
    
    public override class var layerClass: AnyClass {
        return CAMetalLayer.self
    }
    public override func layoutSubviews(){
        let rightConstraint = NSLayoutConstraint(item: fpsLabel!, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: -10.0)
        let botConstraint = NSLayoutConstraint(item: fpsLabel!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -40.0)
        let heightConstraint = NSLayoutConstraint(item: fpsLabel!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 25.0)
        let widthConstraint = NSLayoutConstraint(item: fpsLabel!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 60.0)
        
        self.addConstraints([rightConstraint,botConstraint,widthConstraint,heightConstraint])
        
        (frameBuffer as! FrameBuffer).layerSizeDidUpdate = true
        
        super.layoutSubviews()
    }
    
    func setup(){
    
        fpsLabel = UILabel()
        fpsLabel.translatesAutoresizingMaskIntoConstraints = false
        fpsLabel.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.6)
        self.addSubview(fpsLabel!)

        
        self.isOpaque = true
        self.backgroundColor = nil
        
        // setting this to yes will allow Main thread to display framebuffer when
        // view:setNeedDisplay: is called by main thread
        _metalLayer = self.layer as? CAMetalLayer
        
        self.contentScaleFactor = UIScreen.main.scale
        
        _metalLayer.presentsWithTransaction = false
        _metalLayer.drawsAsynchronously = true
        
        let device = MTLCreateSystemDefaultDevice()
        
        _metalLayer.device          = device
        _metalLayer.pixelFormat     = MTLPixelFormat.bgra8Unorm
        _metalLayer.framebufferOnly = true
        
        frameBuffer = FrameBuffer(metalView: self)
    }
}
