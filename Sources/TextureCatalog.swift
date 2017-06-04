//
//  TextureCatalog.swift
//  DoomKit
//
//  Created by Arjan de Lang on 04-01-15.
//  Copyright (c) 2015 Blue Depths Media. All rights reserved.
//

import Foundation

open class TextureCatalog {
	var _textures = [String: Texture]()
	
	public init(wad: Wad) {
		var patchNames = [String]()
		for lump in wad.lumps {
			if lump.name == "PNAMES" {
				if let data = lump.data {
					var dataOffset = 0
					
					var numberOfPatches: Int32 = 0
					(data as NSData).getBytes(&numberOfPatches, range: NSMakeRange(dataOffset, MemoryLayout<Int32>.size))
					dataOffset += MemoryLayout<Int32>.size
					
					for _ in (0 ..< Int(numberOfPatches)) {
						let name = NSString(data: data.subdata(in: (dataOffset ..< dataOffset + 8)), encoding: String.Encoding.ascii.rawValue)!.trimmingCharacters(in: CharacterSet(charactersIn: "\0"))
						patchNames.append(name)
						dataOffset += 8
					}
				}
			}
		}

		for lump in wad.lumps {
			if lump.name == "TEXTURE1" || lump.name == "TEXTURE2" {
				if let data = lump.data {
					var dataOffset = 0
					
					var numberOfTextures: Int32 = 0
					(data as NSData).getBytes(&numberOfTextures, range: NSMakeRange(dataOffset, MemoryLayout<Int32>.size))
					dataOffset += MemoryLayout<Int32>.size

					var textureDataOffsets = [Int32]()
					for _ in (0 ..< Int(numberOfTextures)) {
						var textureDataOffset: Int32 = 0
						(data as NSData).getBytes(&textureDataOffset, range: NSMakeRange(dataOffset, MemoryLayout<Int32>.size))
						textureDataOffsets.append(textureDataOffset)
						dataOffset += MemoryLayout<Int32>.size
					}

					for textureDataOffset in textureDataOffsets {
						var dataOffset = Int(textureDataOffset)
						let texture = Texture(data: data, dataOffset: &dataOffset, patchNames: patchNames)
						print("Loaded texture '\(texture.name)'")
						_textures[texture.name] = texture
					}
				}
			}
		}
	}
	
	open func textureNamed(_ name: String) -> Texture? {
		return _textures[name]
	}
}
