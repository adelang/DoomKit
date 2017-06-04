//
//  Graphic.swift
//  DoomKit
//
//  Created by Arjan de Lang on 03-01-15.
//  Copyright (c) 2015 Blue Depths Media. All rights reserved.
//

import Cocoa

var __graphicsCache = [String: Graphic]()

open class Graphic {
	open var width: Int16 = 0
	open var height: Int16 = 0
	open var xOffset: Int16 = 0
	open var yOffset: Int16 = 0
	var _pixelData: [UInt8?] = []
	var _cachedImage: NSImage?

	open class func graphicWithLumpName(_ lumpName: String, inWad wad: Wad) -> Graphic? {
		if lumpName == "-" {
			return nil
		}
		
		if let graphic = __graphicsCache[lumpName] {
			return graphic
		}

		for lump in wad.lumps {
			if lump.name == lumpName {
				if let data = lump.data {
					var dataPointer = 0
					
					var width: Int16 = 0
					(data as NSData).getBytes(&width, range: NSMakeRange(dataPointer, MemoryLayout<Int16>.size))
					dataPointer += MemoryLayout<Int16>.size

					var height: Int16 = 0
					(data as NSData).getBytes(&height, range: NSMakeRange(dataPointer, MemoryLayout<Int16>.size))
					dataPointer += MemoryLayout<Int16>.size

					var xOffset: Int16 = 0
					(data as NSData).getBytes(&xOffset, range: NSMakeRange(dataPointer, MemoryLayout<Int16>.size))
					dataPointer += MemoryLayout<Int16>.size

					var yOffset: Int16 = 0
					(data as NSData).getBytes(&yOffset, range: NSMakeRange(dataPointer, MemoryLayout<Int16>.size))
					dataPointer += MemoryLayout<Int16>.size

					var pixelData = [UInt8?](repeating: nil, count: (Int(width) * Int(height)))

					var columnPointers: [UInt32] = []
					for _ in (0 ..< width) {
						var columnPointer: UInt32 = 0
						(data as NSData).getBytes(&columnPointer, range: NSMakeRange(dataPointer, MemoryLayout<UInt32>.size))
						columnPointers.append(columnPointer)
						dataPointer += MemoryLayout<UInt32>.size
					}

					var x: Int16 = 0
					for _ in columnPointers {
						readPoles: while(true) {
							var y: UInt8 = 0
							(data as NSData).getBytes(&y, range: NSMakeRange(dataPointer, MemoryLayout<UInt8>.size))
							dataPointer += MemoryLayout<UInt8>.size
							if y == 255 {
								break readPoles
							}

							var numberOfPixels: UInt8 = 0
							(data as NSData).getBytes(&numberOfPixels, range: NSMakeRange(dataPointer, MemoryLayout<UInt8>.size))
							dataPointer += MemoryLayout<UInt8>.size

							// Ignore first byte
							dataPointer += MemoryLayout<UInt8>.size

							var pixelIndex = Int(y) + Int(x * height)
							for _ in (0 ..< numberOfPixels) {
								var paletteIndex: UInt8 = 0
								(data as NSData).getBytes(&paletteIndex, range: NSMakeRange(dataPointer, MemoryLayout<UInt8>.size))
								pixelData[pixelIndex] = paletteIndex
								pixelIndex += 1
								dataPointer += MemoryLayout<UInt8>.size
							}

							// Also ignore last byte
							dataPointer += MemoryLayout<UInt8>.size
						}
						
						x += 1
					}

					let graphic = Graphic(width: width, height: height, xOffset: xOffset, yOffset: yOffset, pixelData: pixelData)
					
					__graphicsCache[lumpName] = graphic
					
					return graphic
				}
			}
		}
		print("Unable to find graphic with name '\(lumpName)'")
		return nil
	}

	open class func flatWithLumpName(_ lumpName: String, inWad wad: Wad) -> Graphic? {
		if lumpName == "-" {
			return nil
		}
		
		if let graphic = __graphicsCache[lumpName] {
			return graphic
		}

		for lump in wad.lumps {
			if lump.name == lumpName {
				if let data = lump.data {
					let width: Int16 = 64
					let height: Int16 = 64
					let xOffset: Int16 = 0
					let yOffset: Int16 = 0

					var pixelData = [UInt8](repeating: 0, count: (Int(width) * Int(height)))
					
					(data as NSData).getBytes(&pixelData, range: NSMakeRange(0, MemoryLayout<UInt8>.size * Int(width) * Int(height)))
					
					let graphic = Graphic(width: width, height: height, xOffset: xOffset, yOffset: yOffset, pixelData: pixelData)
					
					__graphicsCache[lumpName] = graphic
					
					return graphic
				}
			}
		}
		print("Unable to find graphic with name '\(lumpName)'")
		return nil
	}
	
	public init(width: Int16, height: Int16, xOffset: Int16, yOffset: Int16, pixelData: [UInt8?]) {
		self.width = width
		self.height = height
		self.xOffset = xOffset
		self.yOffset = yOffset
		self._pixelData = pixelData
	}

	open func imageWithPalette(_ palette: Palette) -> NSImage {
		if let image = _cachedImage {
			return image
		}

		let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(width), pixelsHigh: Int(height), bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: NSCalibratedRGBColorSpace, bytesPerRow: Int(4 * width), bitsPerPixel: 32)
		let image = NSImage()
		image.addRepresentation(bitmap!)

		var pixelIndex = 0
		for x in 0 ..< Int(width) {
			for y in 0 ..< Int(height) {
				let paletteIndex = _pixelData[pixelIndex]
				pixelIndex += 1
				let color: NSColor
				if let paletteIndex = paletteIndex {
					color = palette.colors[Int(paletteIndex)]
				} else {
					color = NSColor.clear
				}
				bitmap?.setColor(color, atX: x, y: y)
			}
		}

		_cachedImage = image

		return image
	}
}
