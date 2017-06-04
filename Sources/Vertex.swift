//
//  Vertex.swift
//  DoomKit
//
//  Created by Arjan de Lang on 26-12-14.
//  Copyright (c) 2014 Blue Depths Media. All rights reserved.
//

import Foundation

open class Vertex: NSObject {
	dynamic open var x: Int16
	dynamic open var y: Int16

	open class func decodeVerticesFromLump(_ lump: Wad.Lump) -> [Vertex] {
		var vertices: [Vertex] = []
		if let data = lump.data {
			for vertexDataStart in stride(from: 0, to: data.count, by: 4) {
				var x: Int16 = 0
				(data as NSData).getBytes(&x, range: NSMakeRange(vertexDataStart, 2))

				var y: Int16 = 0
				(data as NSData).getBytes(&y, range: NSMakeRange((vertexDataStart + 2), 2))

				vertices.append(Vertex(x: x, y: y))
			}
		}
		return vertices
	}

	open class func encodeVerticesToLump(_ vertices: [Vertex]) -> Wad.Lump {
		var data = Data()
		for vertex in vertices {
			data.append(Data(bytes: &vertex.x, count: 2))
			data.append(Data(bytes: &vertex.y, count: 2))
		}
		return Wad.Lump(name: "VERTEXES", data: data)
	}
	
	public init(x: Int16, y: Int16) {
		self.x = x
		self.y = y
	}
}

public func ==(lhs: Vertex, rhs: Vertex) -> Bool {
	return lhs === rhs
}
