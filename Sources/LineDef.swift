//
//  Line.swift
//  DoomKit
//
//  Created by Arjan de Lang on 26-12-14.
//  Copyright (c) 2014 Blue Depths Media. All rights reserved.
//

import Foundation

open class LineDef {
	open var startVertex: Vertex
	open var endVertex: Vertex
	open var flags: Int16
	open var specialType: Int16
	open var sectorTag: Int16
	open var rightSideDef: SideDef? {
		willSet {
			rightSideDef?.lineDef = nil
		}
		didSet {
			rightSideDef?.lineDef = self
		}
	}
	open var leftSideDef: SideDef?

	open class func decodeLinesFromLump(_ lump: Wad.Lump, withVertices vertices: [Vertex], sideDefs: [SideDef]) -> [LineDef] {
		var lineDefs: [LineDef] = []
		if let data = lump.data {
			for lineDataStart in stride(from: 0, to: data.count, by: 14) {
				var startVertexIndex: Int16 = 0
				(data as NSData).getBytes(&startVertexIndex, range: NSMakeRange(lineDataStart, 2))
				let startVertex = vertices[Int(startVertexIndex)]

				var endVertexIndex: Int16 = 0
				(data as NSData).getBytes(&endVertexIndex, range: NSMakeRange((lineDataStart + 2), 2))
				let endVertex = vertices[Int(endVertexIndex)]

				var flags: Int16 = 0
				(data as NSData).getBytes(&flags, range: NSMakeRange((lineDataStart + 4), 2))

				var specialType: Int16 = 0
				(data as NSData).getBytes(&specialType, range: NSMakeRange((lineDataStart + 6), 2))

				var sectorTag: Int16 = 0
				(data as NSData).getBytes(&sectorTag, range: NSMakeRange((lineDataStart + 8), 2))

				var rightSideDefIndex: Int16 = 0
				(data as NSData).getBytes(&rightSideDefIndex, range: NSMakeRange((lineDataStart + 10), 2))
				var rightSideDef: SideDef? = nil
				if rightSideDefIndex > 0 && Int(rightSideDefIndex) < sideDefs.count {
					rightSideDef = sideDefs[Int(rightSideDefIndex)]
				}

				var leftSideDefIndex: Int16 = 0
				(data as NSData).getBytes(&leftSideDefIndex, range: NSMakeRange((lineDataStart + 12), 2))
				var leftSideDef: SideDef? = nil
				if leftSideDefIndex > 0 && Int(leftSideDefIndex) < sideDefs.count {
					leftSideDef = sideDefs[Int(leftSideDefIndex)]
				}

				lineDefs.append(LineDef(startVertex: startVertex, endVertex: endVertex, flags: flags, specialType: specialType, sectorTag: sectorTag, rightSideDef: rightSideDef, leftSideDef: leftSideDef))
			}
		}
		return lineDefs
	}

	open class func encodeLinesToLump(_ lineDefs: [LineDef], withVertices vertices: [Vertex], sideDefs: [SideDef]) -> Wad.Lump {
		var data = Data()
		for lineDef in lineDefs {
			var startVertexIndex = Int16(vertices.index(of: lineDef.startVertex)!)
			data.append(Data(bytes: &startVertexIndex, count: 2))

			var endVertexIndex = Int16(vertices.index(of: lineDef.endVertex)!)
			data.append(Data(bytes: &endVertexIndex, count: 2))

			data.append(Data(bytes: &lineDef.flags, count: 2))

			data.append(Data(bytes: &lineDef.specialType, count: 2))

			data.append(Data(bytes: &lineDef.sectorTag, count: 2))

			var rightSideIndex = (lineDef.rightSideDef != nil) ? Int16(sideDefs.index(of: lineDef.rightSideDef!)!) : -1
			data.append(Data(bytes: &rightSideIndex, count: 2))

			var leftSideIndex = (lineDef.leftSideDef != nil) ? Int16(sideDefs.index(of: lineDef.leftSideDef!)!) : -1
			data.append(Data(bytes: &leftSideIndex, count: 2))
		}
		return Wad.Lump(name: "LINEDEFS", data: data)
	}
	
	init(startVertex: Vertex, endVertex: Vertex, flags: Int16, specialType: Int16, sectorTag: Int16, rightSideDef: SideDef?, leftSideDef: SideDef?) {
		self.startVertex = startVertex
		self.endVertex = endVertex
		self.flags = flags
		self.specialType = specialType
		self.sectorTag = sectorTag
		self.rightSideDef = rightSideDef
		self.rightSideDef?.lineDef = self
		self.leftSideDef = leftSideDef
		self.leftSideDef?.lineDef = self
	}
}

