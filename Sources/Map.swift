//
//  Map.swift
//  DoomKit
//
//  Created by Arjan de Lang on 25-12-14.
//  Copyright (c) 2014 Blue Depths Media. All rights reserved.
//

import Foundation

open class Map {
	open var things: [Thing] = []
	open var vertices: [Vertex] = []
	open var lineDefs: [LineDef] = []
	open var sideDefs: [SideDef] = []
	open var sectors: [Sector] = []
	
	class func rangeOfLumpsForMapWithName(_ mapName: String, inWad wad: Wad) -> CountableRange<Int>? {
		var mapFound = false
		var startLumpIndex = -1
		
		var lumpIndex = 0
		findMapLumps: for lump in wad.lumps {
			if !mapFound {
				if lump.name == mapName {
					mapFound = true
					startLumpIndex = lumpIndex
					print("Found lump name \(mapName)'!")
				}
			} else {
				switch (lump.name) {
				case "THINGS": break
				case "LINEDEFS": break
				case "SIDEDEFS": break
				case "VERTEXES": break
				case "SEGS": break
				case "SSECTORS": break
				case "NODES": break
				case "SECTORS": break
				case "REJECT": break
				case "BLOCKMAP": break
				default:
					print("Found non-map lump or unrecognized map lump '\(lump.name)', assuming end of map data")
					break findMapLumps
				}
			}
			lumpIndex += 1
		}
		
		if startLumpIndex >= 0 {
			return (startLumpIndex ..< lumpIndex)
		} else {
			return nil
		}
	}
	
	public init() {
	}
	
	public init?(wad: Wad, mapName: String) {
		var thingsLump: Wad.Lump?
		var verticesLump: Wad.Lump?
		var linesLump: Wad.Lump?
		var sidesLump: Wad.Lump?
		var sectorsLump: Wad.Lump?
		
		if let range = Map.rangeOfLumpsForMapWithName(mapName, inWad: wad) {
			for lump in wad.lumps[range] {
				switch (lump.name) {
				case "THINGS":
					print("Things found!")
					thingsLump = lump
				case "LINEDEFS":
					print("Linedefs found!")
					linesLump = lump
				case "SIDEDEFS":
					print("Sidedefs found!")
					sidesLump = lump
				case "VERTEXES":
					print("Vertices found!")
					verticesLump = lump
				case "SEGS":
					print("Segs found!")
				case "SSECTORS":
					print("SSectors found!")
				case "NODES":
					print("Nodes found!")
				case "SECTORS":
					print("Sectors found!")
					sectorsLump = lump
				case "REJECT":
					print("Reject found!")
				case "BLOCKMAP":
					print("Blockmap found!")
				default: break
				}
			}
		
			if let lump = thingsLump {
				things = Thing.decodeThingsFromLump(lump)
			}
			
			if let lump = sectorsLump {
				sectors = Sector.decodeSectorsFromLump(lump, forMap: self)
			}

			if let lump = verticesLump {
				vertices = Vertex.decodeVerticesFromLump(lump)
			}
			
			if let lump = sidesLump {
				sideDefs = SideDef.decodeSidesFromLump(lump, withSectors: sectors)
			}

			if let lump = linesLump {
				lineDefs = LineDef.decodeLinesFromLump(lump, withVertices: vertices, sideDefs: sideDefs)
			}
		} else {
			print("Error loading map: '\(mapName)' not found in WAD")
			return nil
		}
	}

	open func makeSector(_ vertices: [Vertex], createLinesAndSidesIfNeeded: Bool, floorHeight: Int16, ceilingHeight: Int16, floorTextureName: String, ceilingTextureName: String, lightLevel: Int16, type: Int16, tag: Int16) {
		let sector = Sector(floorHeight: floorHeight, ceilingHeight: ceilingHeight, floorTextureName: floorTextureName, ceilingTextureName: ceilingTextureName, lightLevel: lightLevel, type: type, tag: tag)

		var vertexIndex = 0
		for startVertex in vertices {
			var endVertex: Vertex
			if (vertexIndex + 1) < vertices.count {
				endVertex = vertices[vertexIndex + 1]
			} else {
				endVertex = vertices[0]
			}

			var lineDef: LineDef?
			var sideDef: SideDef?
			for existingLineDef in lineDefs {
				if existingLineDef.startVertex == startVertex && existingLineDef.endVertex == endVertex {
					lineDef = existingLineDef
					sideDef = lineDef?.leftSideDef
				} else if (existingLineDef.startVertex == endVertex && existingLineDef.endVertex == startVertex) {
					lineDef = existingLineDef
					sideDef = lineDef?.rightSideDef
				}
			}
			if lineDef == nil {
				sideDef = SideDef(xTextureOffset: 0, yTextureOffset: 0, upperTextureName: "-", lowerTextureName: "-", middleTextureName: "STONE4", sector: sector)
				sideDefs.append(sideDef!)

				lineDef = LineDef(startVertex: startVertex, endVertex: endVertex, flags: 0, specialType: 0, sectorTag: 0, rightSideDef: nil, leftSideDef: sideDef)
				lineDefs.append(lineDef!)
			}
			
			vertexIndex += 1
		}
		
		sectors.append(sector)
	}

	open func writeToWad(_ wad: Wad, mapName: String) {
		if let range = Map.rangeOfLumpsForMapWithName(mapName, inWad: wad) {
			wad.lumps.removeSubrange(range)
		}
		wad.lumps.append(Wad.Lump(name: mapName, data: nil))
		wad.lumps.append(Thing.encodeThingsToLump(things))
		wad.lumps.append(LineDef.encodeLinesToLump(lineDefs, withVertices: vertices, sideDefs: sideDefs))
		wad.lumps.append(SideDef.encodeSidesToLump(sideDefs, withSectors: sectors))
		wad.lumps.append(Vertex.encodeVerticesToLump(vertices))
		wad.lumps.append(Sector.encodeSectorsToLump(sectors))
	}
	
//	public func writeToWadAtPath(path: String) {
//		let headerData = NSMutableData()
//		let lumpData = NSMutableData()
//		let directoryData = NSMutableData()
//		var lumps: [Wad.Lump] = []
//		
//		lumps.append(Wad.Lump(name: "Map01", data: NSData(bytes: UnsafePointer<Void>.null(), length: 0)))
//		
//		// Write lump data and directory
//		for lump in lumps {
//			lumpData.appendData(lump.data)
//
//			var dataStartAddress = Int32(directoryData.length) + 12
//			directoryData.appendData(NSData(bytes: &dataStartAddress, length: 4))
//
//			var dataLength = Int32(lump.data.length)
//			directoryData.appendData(NSData(bytes: &dataLength, length: 4))
//			
//			directoryData.appendData(lump.name.stringByPaddingToLength(8, withString: "\0", startingAtIndex: 0).dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: false)!)
//		}
//
//		// Write header
//		headerData.appendData("PWAD".dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: false)!)
//
//		var numberOfLumps = Int32(lumps.count)
//		headerData.appendData(NSData(bytes: &numberOfLumps, length: 4))
//
//		var directoryStartAddress = Int32(lumpData.length + 12)
//		headerData.appendData(NSData(bytes: &directoryStartAddress, length: 4))
//
//		// Combine data to build new Wad file
//		let data = NSMutableData()
//		data.appendData(headerData)
//		data.appendData(lumpData)
//		data.appendData(directoryData)
//		data.writeToFile(path, atomically: true)
//	}
}
