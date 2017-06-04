//
//  Side.swift
//  DoomKit
//
//  Created by Arjan de Lang on 26-12-14.
//  Copyright (c) 2014 Blue Depths Media. All rights reserved.
//

import Foundation

open class SideDef: Equatable {
	open var xTextureOffset: Int16
	open var yTextureOffset: Int16
	open var upperTextureName: String
	open var lowerTextureName: String
	open var middleTextureName: String
	open var sector: Sector
	weak var lineDef: LineDef?
	open var startVertex: Vertex? {
		get {
			return self.lineDef?.rightSideDef == self ? self.lineDef?.startVertex : self.lineDef?.endVertex
		}
	}
	open var endVertex: Vertex! {
		get {
			return self.lineDef?.rightSideDef == self ? self.lineDef?.endVertex : self.lineDef?.startVertex
		}
	}
	
	open class func decodeSidesFromLump(_ lump: Wad.Lump, withSectors sectors: [Sector]) -> [SideDef] {
		var sideDefs: [SideDef] = []
		if let data = lump.data {
			for sideDataStart in stride(from: 0, to: data.count, by: 30) {
				var xTextureOffset: Int16 = 0
				(data as NSData).getBytes(&xTextureOffset, range: NSMakeRange(sideDataStart, 2))

				var yTextureOffset: Int16 = 0
				(data as NSData).getBytes(&yTextureOffset, range: NSMakeRange((sideDataStart + 2), 2))

				let upperTextureName = String(data: data.subdata(in: (sideDataStart + 4 ..< sideDataStart + 12)), encoding: .ascii)!.trimmingCharacters(in: CharacterSet(charactersIn: "\0"))

				let lowerTextureName = String(data: data.subdata(in: (sideDataStart + 12 ..< sideDataStart + 20)), encoding: .ascii)!.trimmingCharacters(in: CharacterSet(charactersIn: "\0"))

				let middleTextureName = String(data: data.subdata(in: (sideDataStart + 20 ..< sideDataStart + 28)), encoding: .ascii)!.trimmingCharacters(in: CharacterSet(charactersIn: "\0"))

				var sectorIndex: Int16 = 0
				(data as NSData).getBytes(&sectorIndex, range: NSMakeRange((sideDataStart + 28), 2))
				let sector = sectors[Int(sectorIndex)]

				sideDefs.append(SideDef(xTextureOffset: xTextureOffset, yTextureOffset: yTextureOffset, upperTextureName: upperTextureName, lowerTextureName: lowerTextureName, middleTextureName: middleTextureName, sector: sector))
			}
		}
		return sideDefs
	}

	open class func encodeSidesToLump(_ sideDefs: [SideDef], withSectors sectors: [Sector]) -> Wad.Lump {
		var data = Data()
		for side in sideDefs {
			data.append(Data(bytes: &side.xTextureOffset, count: 2))
			data.append(Data(bytes: &side.yTextureOffset, count: 2))
			data.append(side.upperTextureName.padding(toLength: 8, withPad: "\0", startingAt: 0).data(using: String.Encoding.ascii, allowLossyConversion: false)!)
			data.append(side.lowerTextureName.padding(toLength: 8, withPad: "\0", startingAt: 0).data(using: String.Encoding.ascii, allowLossyConversion: false)!)
			data.append(side.middleTextureName.padding(toLength: 8, withPad: "\0", startingAt: 0).data(using: String.Encoding.ascii, allowLossyConversion: false)!)
			var sectorIndex = Int16(sectors.index(of: side.sector)!)
			data.append(Data(bytes: &sectorIndex, count: 2))
		}
		return Wad.Lump(name: "SIDEDEFS", data: data)
	}
	
	init(xTextureOffset: Int16, yTextureOffset: Int16, upperTextureName: String, lowerTextureName: String, middleTextureName: String, sector: Sector) {
		self.xTextureOffset = xTextureOffset
		self.yTextureOffset = yTextureOffset
		self.upperTextureName = upperTextureName
		self.lowerTextureName = lowerTextureName
		self.middleTextureName = middleTextureName
		self.sector = sector
	}
}

public func ==(lhs: SideDef, rhs: SideDef) -> Bool {
	return lhs === rhs
}

