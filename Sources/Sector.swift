//
//  Sector.swift
//  DoomKit
//
//  Created by Arjan de Lang on 26-12-14.
//  Copyright (c) 2014 Blue Depths Media. All rights reserved.
//

import Foundation
import CoreGraphics

open class Sector: Equatable {
	class Delegate {
		
	}
	
	open var floorHeight: Int16
	open var ceilingHeight: Int16
	open var floorTextureName: String
	open var ceilingTextureName: String
	open var lightLevel: Int16
	open var type: Int16
	open var tag: Int16
	weak var map: Map?
	
	open var sideDefs: [SideDef] {
		get {
			return map?.sideDefs.filter({$0.sector == self}) ?? []
		}
	}
	
	open var loops: [[SideDef]] {
		get {
			var loops = [[SideDef]]()
			var availableSideDefs = self.sideDefs.filter({$0.lineDef != nil})
			tryNextStartingSideSef: while let startingSideDef = availableSideDefs.first {
				availableSideDefs.removeFirst()
				var loopSideDefs = [startingSideDef]
				findNextLoopSegment: while true {
					for sideDef in availableSideDefs {
						if sideDef.startVertex == loopSideDefs.last?.endVertex {
							// Add to loop and continue search
							loopSideDefs.append(sideDef)
							availableSideDefs.remove(at: availableSideDefs.index(of: sideDef)!)
							if sideDef.endVertex == loopSideDefs.first?.startVertex {
								// Loop complete
								loops.append(loopSideDefs)
								continue tryNextStartingSideSef
							}
							continue findNextLoopSegment
						}
					}
					break findNextLoopSegment
				}
			}
			return loops
		}
	}
	
	open class func decodeSectorsFromLump(_ lump: Wad.Lump, forMap map: Map) -> [Sector] {
		var sectors: [Sector] = []
		if let data = lump.data {
			for sectorDataStart in stride(from: 0, to: data.count, by: 26) {
				var floorHeight: Int16 = 0
				(data as NSData).getBytes(&floorHeight, range: NSMakeRange(sectorDataStart, 2))

				var ceilingHeight: Int16 = 0
				(data as NSData).getBytes(&ceilingHeight, range: NSMakeRange((sectorDataStart + 2), 2))

				let floorTextureName = String(data: data.subdata(in: (sectorDataStart + 4 ..< sectorDataStart + 12)), encoding: .ascii)!.trimmingCharacters(in: CharacterSet(charactersIn: "\0"))

				let ceilingTextureName = String(data: data.subdata(in: (sectorDataStart + 12 ..< sectorDataStart + 20)), encoding: .ascii)!.trimmingCharacters(in: CharacterSet(charactersIn: "\0"))

				var lightLevel: Int16 = 0
				(data as NSData).getBytes(&lightLevel, range: NSMakeRange((sectorDataStart + 20), 2))

				var type: Int16 = 0
				(data as NSData).getBytes(&type, range: NSMakeRange((sectorDataStart + 22), 2))

				var tag: Int16 = 0
				(data as NSData).getBytes(&tag, range: NSMakeRange((sectorDataStart + 24), 2))

				sectors.append(Sector(floorHeight: floorHeight, ceilingHeight: ceilingHeight, floorTextureName: floorTextureName, ceilingTextureName: ceilingTextureName, lightLevel: lightLevel, type: type, tag: tag, map: map))
			}
		}
		return sectors
	}

	open class func encodeSectorsToLump(_ sectors: [Sector]) -> Wad.Lump {
		var data = Data()
		for sector in sectors {
			data.append(Data(bytes: &sector.floorHeight, count: 2))
			data.append(Data(bytes: &sector.ceilingHeight, count: 2))
			data.append(sector.floorTextureName.padding(toLength: 8, withPad: "\0", startingAt: 0).data(using: String.Encoding.ascii, allowLossyConversion: false)!)
			data.append(sector.ceilingTextureName.padding(toLength: 8, withPad: "\0", startingAt: 0).data(using: String.Encoding.ascii, allowLossyConversion: false)!)
			data.append(Data(bytes: &sector.lightLevel, count: 2))
			data.append(Data(bytes: &sector.type, count: 2))
			data.append(Data(bytes: &sector.tag, count: 2))
		}
		return Wad.Lump(name: "SECTORS", data: data)
	}

	public init(floorHeight: Int16, ceilingHeight: Int16, floorTextureName: String, ceilingTextureName: String, lightLevel: Int16, type: Int16, tag: Int16, map: Map? = nil) {
		self.floorHeight = floorHeight
		self.ceilingHeight = ceilingHeight
		self.floorTextureName = floorTextureName
		self.ceilingTextureName = ceilingTextureName
		self.lightLevel = lightLevel
		self.type = type
		self.tag = tag
		self.map = map
	}
}

public func ==(lhs: Sector, rhs: Sector) -> Bool {
	return lhs === rhs
}
