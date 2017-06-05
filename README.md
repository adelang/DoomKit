# DoomKit
A Swift library for manipulating Doom WAD files and the data structures contained therein.

To use DoomKit in your project, add it as a dependency in your Package.Swift file:

```
let package = Package(
	name: "MyPackage",
	dependencies: [
		.Package(url: "https://github.com/adelang/DoomKit.git", "0.1.0"),
	]
)
```

# Example

Create a simple map and save it to a new WAD:

```
import DoomKit

let pwad = Wad()

let map = Map()

let v0 = Vertex(x: 200, y: 200)
map.vertices.append(v0)

let v1 = Vertex(x: 600, y: 200)
map.vertices.append(v1)

let v2 = Vertex(x: 600, y: 800)
map.vertices.append(v2)

let v3 = Vertex(x: 200, y: 800)
map.vertices.append(v3)

map.makeSector([v0, v1, v2, v3], createLinesAndSidesIfNeeded: true, floorHeight: 0, ceilingHeight: 192, floorTextureName: "RROCK01", ceilingTextureName: "CEIL1_1", lightLevel: 128, type: 0, tag: 0)

let playerStart = Thing(x: 400, y: 300, angle: .north, type: Thing.Definition.Player1Start)
map.things.append(playerStart)

let soulSphere = Thing(x: 400, y: 700, angle: .south, type: Thing.Definition.SoulSphere)
map.things.append(soulSphere)

map.writeToWad(pwad, mapName: "MAP01")

pwad.writeToPath("test.wad")
```

This should produce a test.wad that looks like this when loaded into Doom 2:

![alt text](https://raw.githubusercontent.com/adelang/DoomKit/master/test.png)

*Note: DoomKit does not currently include a node builder, if the source port you are using does not have an internal node builder you will have to build the nodes by hand (using a separate tool) before loading the test WAD into Doom 2.*
