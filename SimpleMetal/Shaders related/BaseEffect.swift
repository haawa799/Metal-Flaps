//
//  BaseEffect.swift
//  Triangle
//
//  Created by Andrew K. on 6/24/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

import UIKit
import Metal

@objc class BaseEffect: NSObject
{
    let device: MTLDevice
    var renderPipelineState:MTLRenderPipelineState?
    var pipeLineDescriptor:MTLRenderPipelineDescriptor
    var projectionMatrix:AnyObject = Matrix4()
    
    var lightColor = MTLClearColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    var lightDirection: [Float] = [0.0,0.0,0.0]
    
    init(device:MTLDevice ,vertexShaderName: String, fragmentShaderName:String)
    {
        self.device = device
        
        // Setup MTLRenderPipline descriptor object with vertex and fragment shader
        pipeLineDescriptor = MTLRenderPipelineDescriptor()
        let library = device.makeDefaultLibrary()!
        pipeLineDescriptor.vertexFunction = library.makeFunction(name: vertexShaderName)
        pipeLineDescriptor.fragmentFunction = library.makeFunction(name: fragmentShaderName)
        pipeLineDescriptor.sampleCount = 4
        
        pipeLineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        pipeLineDescriptor.depthAttachmentPixelFormat = MTLPixelFormat.depth32Float
        pipeLineDescriptor.stencilAttachmentPixelFormat = MTLPixelFormat.invalid
        
        super.init()
    }
    
    func compile() -> MTLRenderPipelineState?
    {
        // Compile the MTLRenderPipline object into immutable and cheap for use MTLRenderPipelineState
        renderPipelineState = try? device.makeRenderPipelineState(descriptor: pipeLineDescriptor)
        return renderPipelineState
    }
}
