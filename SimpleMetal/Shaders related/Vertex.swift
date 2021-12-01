//
//  Vertex.swift
//  Triangle
//
//  Created by Andrew K. on 6/24/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

import UIKit

@objc public class Vertex: NSObject
{
    @objc public var x,y,z,u,v,nX,nY,nZ: Float
    
    
    init(x:Float, y:Float, z:Float, u:Float ,v:Float ,nX:Float ,nY:Float ,nZ:Float)
    {
        self.x = x
        self.y = y
        self.z = z
        
        self.u = u
        self.v = v
        
        self.nX = nX
        self.nY = nY
        self.nZ = nZ
        
        super.init()
    }
    
    init(text: String)
    {
        let list = text.components(separatedBy: " ") as [NSString]
        var counter = 0
        
        self.x = (list[counter]).floatValue
        counter += 1
        self.y = (list[counter]).floatValue
        counter += 1
        self.z = (list[counter]).floatValue
        counter += 1
        
        self.u = (list[counter]).floatValue
        counter += 1
        self.v = (list[counter]).floatValue
        counter += 1
        
        self.nX = (list[counter]).floatValue
        counter += 1
        self.nY = (list[counter]).floatValue
        counter += 1
        self.nZ = (list[counter]).floatValue
        counter += 1
        
        super.init()
    }
    
}
