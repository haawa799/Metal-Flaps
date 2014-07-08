import UIKit

@objc class Pipe: Node {

    init(baseEffect: BaseEffect)
    {

        var verticesArray:Array<Vertex> = []
        let path = NSBundle.mainBundle().pathForResource("pipe", ofType: "txt")
            var possibleContent = String.stringWithContentsOfFile(path, encoding: NSUTF8StringEncoding, error: nil)

            if let content = possibleContent {
            var array = content.componentsSeparatedByString("\n")
            array.removeLast()
            for line in array{
                var vertex = Vertex(text: line)
                verticesArray.append(vertex)
            }
        }


        super.init(name: "Pipe", baseEffect: baseEffect, vertices: verticesArray, vertexCount: verticesArray.count, textureName: "pip.png")

        self.ambientIntensity = 0.000000
        self.diffuseIntensity = 0.640000
        self.specularIntensity = 0.500000
        self.shininess = 96.078431

        
        self.setScale(0.5)
    }
    
    
    override func updateWithDelta(delta: CFTimeInterval)
    {
        super.updateWithDelta(delta)
        rotationZ += Float(M_PI/2) * Float(delta)
    }

}