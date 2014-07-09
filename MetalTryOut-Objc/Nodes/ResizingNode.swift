//
//  ResizingNode.swift
//  Metal Flaps
//
//  Created by Andrew K. on 7/9/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

import UIKit

class ResizingNode: Node {
    init(name: String,
        baseEffect: BaseEffect,
        vertices: Array<Vertex>?,
        vertexCount: Int,
        textureName: String?, width: Float, height: Float, depth: Float)
    {
        super.init(name: name, baseEffect: baseEffect, vertices: vertices, vertexCount: vertexCount, textureName: textureName)
        
        
    }
}
