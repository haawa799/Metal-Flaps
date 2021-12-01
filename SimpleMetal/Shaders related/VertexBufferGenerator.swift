//
//  VertexBufferGenerator.swift
//  Metal Flaps
//
//  Created by Andrii Kharchyshyn on 01.12.2021.
//  Copyright © 2021 Andrew Kharchyshyn. All rights reserved.
//

import Foundation
import MetalKit

final class VertexBufferGenerator {
    
    static func generateBufferVertices(vertices: [Vertex],
                                       vertexCount: Int,
                                       device: MTLDevice) -> MTLBuffer {
        
        let kNumberOfPositionComponents = 4
        let kNumberOfNormalComponents = 3
        let kNumberOfTextureComponents = 2
        
        
        let count = (kNumberOfPositionComponents + kNumberOfTextureComponents + kNumberOfNormalComponents) * vertexCount
        var vertexData = [Float].init(repeating: 0, count: count)
        var counter = 0
        
        for vertexID in 0..<vertexCount {
            
            let vertex = vertices[vertexID]
            
            vertexData[counter] = vertex.x
            counter += 1
            vertexData[counter] = vertex.y
            counter += 1
            vertexData[counter] = vertex.z
            counter += 1
            
            vertexData[counter] = vertex.nX
            counter += 1
            vertexData[counter] = vertex.nY
            counter += 1
            vertexData[counter] = vertex.nZ
            counter += 1
            
            vertexData[counter] = vertex.u
            counter += 1
            vertexData[counter] = vertex.v
            counter += 1
        }
        
        let vertexBuffer = device.makeBuffer(bytes: &vertexData, length: MemoryLayout.size(ofValue: vertexData), options: [])!
        
        return vertexBuffer
    }
    
}
