//
//  Palette.swift
//  DoomKit
//
//  Created by Arjan de Lang on 03-01-15.
//  Copyright (c) 2015 Blue Depths Media. All rights reserved.
//

import Cocoa

open class Palette {
	open let colors: [NSColor]

	public init() {
		self.colors = [NSColor](repeating: NSColor.black, count: 256)
	}

	public init?(wad: Wad) {
		for lump in wad.lumps {
			if lump.name == "PLAYPAL" {
				if let data = lump.data {
					var mutableColors = [NSColor](repeating: NSColor.black, count: 256)
					var dataOffset = 0
					for colorNumber in (0..<256) {
						var r8: UInt8 = 0
						(data as NSData).getBytes(&r8, range: NSMakeRange(dataOffset, 1))
						dataOffset += 1
						let red = CGFloat(r8) / 255
		
						var g8: UInt8 = 0
						(data as NSData).getBytes(&g8, range: NSMakeRange(dataOffset, 1))
						dataOffset += 1
						let green = CGFloat(g8) / 255

						var b8: UInt8 = 0
						(data as NSData).getBytes(&b8, range: NSMakeRange(dataOffset, 1))
						dataOffset += 1
						let blue = CGFloat(b8) / 255

						mutableColors[colorNumber] = NSColor(calibratedRed: red, green: green, blue: blue, alpha: 1.0)
					}
					self.colors = mutableColors
					return
				}
			}
		}
		self.colors = [NSColor]()
		return nil
	}
}
