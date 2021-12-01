import UIKit

@objc class Ram: Node {

    init(baseEffect: BaseEffect)
    {

        let url = Bundle.main.url(forResource: "ram", withExtension: "txt")!
        let content = try! String(contentsOf: url, encoding: .utf8)

        var array = content.components(separatedBy: "\n")
        array.removeLast()
        
        let verticesArray:Array<Vertex> = array.map { Vertex(text: $0) }
        super.init(name: "Ram", baseEffect: baseEffect, vertices: verticesArray, vertexCount: verticesArray.count, textureName: "char_ram_col.jpg")
        
        self.ambientIntensity = 0.400000
        self.diffuseIntensity = 0.800000
        self.specularIntensity = 0.000000
        self.shininess = 0.098039
        
    }
    
    override func updateWithDelta(delta: CFTimeInterval)
    {
        super.updateWithDelta(delta: delta)
        
        //        rotationZ += Float(M_PI/10) * Float(delta)
//        rotationZ += Float(M_PI/8) * Float(delta)
    }

}
