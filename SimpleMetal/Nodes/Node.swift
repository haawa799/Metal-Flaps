//
//  Model.swift
//  Triangle
//
//  Created by Andrew K. on 6/24/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//
//
//
/////////////////////////////////////////////
//
//  Node class is a base class in game graph, it provides you ability to change transformation of node and all his
//  children. It provide you material specs such as shininess, specularIntensity etc. You should not draw node
//  itself using renderNode, but u should put your node inside Scene and call render(..) on Scene object.
//
//  Usualy Node subclasses are generated from 3D model files however you can take a look at Cube.swift for some 
//  primitive object
//
/////////////////////////////////////////////

import UIKit
import Metal
import QuartzCore


@objc public class Node: NSObject
{
    
    var time:CFTimeInterval = 0.0
    
    //initial values
    var baseEffect: BaseEffect
    var name: String
    var vertexCount: Int
    var texture: MTLTexture?
    var depthState: MTLDepthStencilState?
    
    //animation handles
    var positionX:Float = 0.0
    var positionY:Float = 0.0
    var positionZ:Float = 0.0
    var rotationX:Float = 0.0
    var rotationY:Float = 0.0
    var rotationZ:Float = 0.0
    var scaleX:Float    = 1.0
    var scaleY:Float    = 1.0
    var scaleZ:Float    = 1.0
    
    var initialRotation:AnyObject = Matrix4()
    var initialWidth:Float?// = 1.0
    var initialHeight:Float?// = 1.0
    var initialDepth:Float?// = 1.0
    
    //light specs
    @objc public var diffuseIntensity: Float = 1.0
    @objc public var ambientIntensity: Float = 1.0
    @objc public var specularIntensity: Float = 1.0
    @objc public var shininess: Float = 1.0
    
    
    // array of children nodes, you should never add or remove item from it directly, only throu addChild and removeChild
    var children:Array<Node> = Array<Node>()
    var numberOfSiblings: Int = 1
    
    //shaders input data
    var vertexBuffer: MTLBuffer?
    var uniformsBuffer: MTLBuffer?
    var samplerState: MTLSamplerState?
    
    var uniformBufferProvider: AnyObject?
    
    var tag = 0
    
    
    init(name: String,
        baseEffect: BaseEffect,
        vertices: Array<Vertex>?,
        vertexCount: Int,
        textureName: String?)
    {
        //Setup texture if present
        if let texName = textureName
        {
            let nameComponents = texName.components(separatedBy: ".")
            let mTexture: METLTexture = METLTexture(resourceName: nameComponents[0], ext: nameComponents[1])
            mTexture.finalize(baseEffect.device)
            self.texture = mTexture.texture
        }
        
        self.name = name
        self.baseEffect = baseEffect
        self.vertexCount = vertexCount
        
        super.init()
        
        if let trueVertices = vertices
        {
            self.vertexBuffer = generateVertexBuffer(vertices: trueVertices, vertexCount: vertexCount, device: baseEffect.device)
        }
        
        self.samplerState = generateSamplerStateForTexture(device: baseEffect.device)
        
        let depthStateDesc = MTLDepthStencilDescriptor()
        depthStateDesc.depthCompareFunction = MTLCompareFunction.less
        depthStateDesc.isDepthWriteEnabled = true
        depthState = baseEffect.device.makeDepthStencilState(descriptor: depthStateDesc)
    }
    
    
    //this method is only used by scene object to render it's children recursively
    func renderNode(node: Node, parentMatrix: AnyObject, projectionMatrix: AnyObject, renderPassDescriptor: MTLRenderPassDescriptor, commandBuffer: MTLCommandBuffer, encoder: MTLRenderCommandEncoder?, uniformProvider: AnyObject?) -> MTLRenderCommandEncoder
    {
        var commandEncoder:MTLRenderCommandEncoder
        
        if encoder == nil
        {
            commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
            commandEncoder.setDepthStencilState(depthState!)
            commandEncoder.setRenderPipelineState(baseEffect.renderPipelineState!)
            commandEncoder.setFragmentSamplerState(samplerState, index: 0)
            commandEncoder.setCullMode(MTLCullMode.front)
        }
        else
        {
            commandEncoder = encoder!
        }
        
        
        commandEncoder.pushDebugGroup(node.name)
        
        for child in node.children
        {
            let nodeModelMatrix: Matrix4 = node.modelMatrix() as! Matrix4
            nodeModelMatrix.multiplyLeft(parentMatrix as? Matrix4)
            _ = child.renderNode(node: child, parentMatrix: nodeModelMatrix, projectionMatrix: projectionMatrix, renderPassDescriptor: renderPassDescriptor, commandBuffer: commandBuffer, encoder: commandEncoder, uniformProvider: uniformProvider)
        }
        
        if node.vertexCount > 0
        {
            let nodeModelMatrix: Matrix4 = node.modelMatrix() as! Matrix4
            nodeModelMatrix.multiplyLeft(parentMatrix as? Matrix4)
            let uniform = node.getUniformsBufferFromUniformsProvider(provider: uniformProvider,mvMatrix: nodeModelMatrix, projMatrix: projectionMatrix, baseEffect: node.baseEffect)
            commandEncoder.setVertexBuffer(node.vertexBuffer, offset: 0, index: 0)
            commandEncoder.setVertexBuffer(uniform, offset: 0, index: 1)
            commandEncoder.setFragmentTexture(node.texture, index: 0)
            commandEncoder.drawPrimitives(type: MTLPrimitiveType.triangle, vertexStart: 0, vertexCount: node.vertexCount)
        }
        
        commandEncoder.popDebugGroup()
        
        return commandEncoder
    }
    
    func addChild(child: Node)
    {
        child.uniformBufferProvider = uniformBufferProvider
        numberOfSiblings += child.numberOfSiblings
        children.append(child)
    }
    
    func removeChild(child: Node)
    {
        numberOfSiblings -= child.numberOfSiblings
        var indexes = Array<Int>()
        for (index, value) in children.enumerated() {
            if value == child
            {
                indexes.append(index)
            }
        }
        for index in indexes
        {
            children.remove(at: index)
        }
        
        children.remove(at: 0)
    }
    
    // Transformation
    func setScale(scale: Float)
    {
        scaleX = scale
        scaleY = scale
        scaleZ = scale
    }
    
    func modelMatrix() -> AnyObject //AnyObject is used as a workaround against comiler error, waiting for fix in following betas
    {
        let matrix = Matrix4()
        
        // Scale
        var height: Float = 1.0
        var width: Float = 1.0
        var depth: Float = 1.0
        if let initialWidth = initialWidth
        {
            width = initialWidth * 0.5
        }
        if let initialHeight = initialHeight
        {
            height = initialHeight * 0.5
        }
        if let initialDepth = initialDepth
        {
            depth = initialDepth * 0.5
        }
        matrix.scale(scaleX * width, y: scaleY * height, z: scaleZ * depth)
        
        //Rotate
        let initialRotationMatCopy: Matrix4 = (initialRotation as! Matrix4).copy()
        matrix.rotateAroundX(rotationX, y: rotationY, z: rotationZ)
        matrix.multiplyLeft(initialRotationMatCopy)
        
        //Translation
        let translMat = Matrix4()
        translMat.translate(positionX, y: positionY, z: positionZ)
        matrix.multiplyLeft(translMat)
        
        
        
        return matrix
    }
    
    func updateWithDelta(delta: CFTimeInterval)
    {
        time += delta
        for child in children
        {
            child.updateWithDelta(delta: delta)
        }
    }
    
    // Generators of buffers which are passed to GPU
    func generateSamplerStateForTexture(device: MTLDevice) -> MTLSamplerState?
    {
        let pSamplerDescriptor:MTLSamplerDescriptor? = MTLSamplerDescriptor()
        
        if let sampler = pSamplerDescriptor
        {
            sampler.minFilter             = MTLSamplerMinMagFilter.nearest
            sampler.magFilter             = MTLSamplerMinMagFilter.nearest
            sampler.mipFilter             = MTLSamplerMipFilter.notMipmapped
            sampler.maxAnisotropy         = 1
            sampler.sAddressMode          = MTLSamplerAddressMode.clampToEdge
            sampler.tAddressMode          = MTLSamplerAddressMode.clampToEdge
            sampler.rAddressMode          = MTLSamplerAddressMode.clampToEdge
            sampler.normalizedCoordinates = true
            sampler.lodMinClamp           = 0
            sampler.lodMaxClamp           = Float.greatestFiniteMagnitude
        }
        else
        {
            print(">> ERROR: Failed creating a sampler descriptor!")
        }
        
        return device.makeSamplerState(descriptor: pSamplerDescriptor!)
    }
    
    func getUniformsBufferFromUniformsProvider(provider:AnyObject?,mvMatrix: AnyObject, projMatrix: AnyObject,baseEffect: BaseEffect) -> MTLBuffer?
    {
        let mv:Matrix4 = mvMatrix as! Matrix4
        let proj:Matrix4 = projMatrix as! Matrix4
        let generator: UniformsBufferGenerator = provider as! UniformsBufferGenerator
        uniformsBuffer = generator.buffer(withProjectionMatrix: proj, modelViewMatrix: mv, with: baseEffect, withModel: self)
        return uniformsBuffer
    }
    
    func generateVertexBuffer(vertices: Array<Vertex>, vertexCount: Int, device: MTLDevice) -> MTLBuffer?
    {
        vertexBuffer = VertexBufferGenerator.generateBufferVertices(vertices,
                                                                    vertexCount: vertexCount as NSNumber,
                                                                    device: device)
        return vertexBuffer
    }
}
