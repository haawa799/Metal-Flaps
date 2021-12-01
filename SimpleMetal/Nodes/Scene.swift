//
//  Scene.swift
//  Imported Model
//
//  Created by Andrew K. on 7/4/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

import UIKit
import Metal

class Scene: Node {

    
    var avaliableUniformBuffers: DispatchSemaphore?
    
    var width: Float = 0.0
    var height: Float = 0.0
    
    let perspectiveAngleRad: Float = Matrix4.degrees(toRad: 85.0)
    var sceneOffsetZ: Float = 0.0
    
//    var projectionMatrix: AnyObject
    
    init(name: String, baseEffect: BaseEffect, width: Float, height: Float)
    {
        self.width = width
        self.height = height
        
        sceneOffsetZ = (height * 0.5) / tanf(perspectiveAngleRad * 0.5)
        let ratio: Float = Float(width) / Float(height)
        
    
        baseEffect.projectionMatrix = Matrix4.makePerspectiveViewAngle(perspectiveAngleRad, aspectRatio: ratio, nearZ: 0.1, farZ: 10.5 * sceneOffsetZ)
        
        super.init(name: name, baseEffect: baseEffect, vertices: nil, vertexCount: 0, textureName: nil)
        
        positionZ = -1 * sceneOffsetZ
    }
    
    func prepareToDraw()
    {
        let numberOfUniformBuffersToUse = 3 * self.numberOfSiblings
        print("bufs \(numberOfUniformBuffersToUse)")
        avaliableUniformBuffers = DispatchSemaphore(value: numberOfUniformBuffersToUse)
        self.uniformBufferProvider = UniformsBufferGenerator(numberOfInflightBuffers: CInt(numberOfUniformBuffersToUse), with: baseEffect.device)
        
    }
    
    func render(commandQueue: MTLCommandQueue, metalView: MetalView, parentMVMatrix: AnyObject)
    {
        
        let parentModelViewMatrix: Matrix4 = parentMVMatrix as! Matrix4
        let myModelViewMatrix: Matrix4 = modelMatrix() as! Matrix4
        myModelViewMatrix.multiplyLeft(parentModelViewMatrix)
        let projectionMatrix: Matrix4 = baseEffect.projectionMatrix as! Matrix4
        
        
        //We are using 3 uniform buffers, we need to wait in case CPU wants to write in first uniform buffer, while GPU is still using it (case when GPU is 2 frames ahead CPU)
        avaliableUniformBuffers?.wait()
        
        guard let commandBuffer = commandQueue.makeCommandBuffer(), let renderPathDescriptor = metalView.frameBuffer.renderPassDescriptor else {
            return
        }
        commandBuffer.addCompletedHandler {
            (buffer:MTLCommandBuffer!) -> Void in
            self.avaliableUniformBuffers?.signal()
        }
        
        var commandEncoder: MTLRenderCommandEncoder?
        
        for child in children {
            commandEncoder = renderNode(node: child, parentMatrix: myModelViewMatrix, projectionMatrix: projectionMatrix, renderPassDescriptor: renderPathDescriptor!, commandBuffer: commandBuffer, encoder: commandEncoder, uniformProvider: uniformBufferProvider)
        }
        
        if let drawableAnyObject = metalView.frameBuffer.currentDrawable as? MTLDrawable {
            commandBuffer.present(drawableAnyObject)
        }
        
        commandEncoder?.endEncoding()
        
        // Commit commandBuffer to his commandQueue in which he will be executed after commands before him in queue
        commandBuffer.commit();
    }
}
