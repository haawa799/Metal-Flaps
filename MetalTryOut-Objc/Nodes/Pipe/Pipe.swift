import UIKit

@objc class Pipe: Node {

    init(baseEffect: BaseEffect)
    {

        let url = Bundle.main.url(forResource: "pipe", withExtension: "txt")!
        let content = try! String(contentsOf: url, encoding: .utf8)

        var array = content.components(separatedBy: "\n")
        array.removeLast()
        
        let verticesArray:Array<Vertex> = array.map { Vertex(text: $0) }

        super.init(name: "Pipe", baseEffect: baseEffect, vertices: verticesArray, vertexCount: verticesArray.count, textureName: "pip.png")

        self.ambientIntensity = 0.800000
        self.diffuseIntensity = 0.700000
        self.specularIntensity = 0.800000
        self.shininess = 8.078431

        
        self.setScale(scale: 0.5)
    }
    
    
    override func updateWithDelta(delta: CFTimeInterval)
    {
        super.updateWithDelta(delta: delta)
//        rotationZ += Float(M_PI/2) * Float(delta)
    }

}
