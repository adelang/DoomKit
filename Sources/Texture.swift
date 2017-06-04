//
//  Texture.swift
//  DoomKit
//
//  Created by Arjan de Lang on 04-01-15.
//  Copyright (c) 2015 Blue Depths Media. All rights reserved.
//

import Cocoa

open class Texture {
	class PatchDescriptor {
		var patchName: String
		var xOffset: Int16 = 0
		var yOffset: Int16 = 0
		
		init(data: Data, dataOffset: inout Int, patchNames: [String]) {
			(data as NSData).getBytes(&xOffset, range: NSMakeRange(dataOffset, MemoryLayout<Int16>.size))
			dataOffset += MemoryLayout<Int16>.size

			(data as NSData).getBytes(&yOffset, range: NSMakeRange(dataOffset, MemoryLayout<Int16>.size))
			dataOffset += MemoryLayout<Int16>.size

			var patchNumber: Int16 = 0
			(data as NSData).getBytes(&patchNumber, range: NSMakeRange(dataOffset, MemoryLayout<Int16>.size))
			patchName = patchNames[Int(patchNumber)]
			dataOffset += MemoryLayout<Int16>.size

			// Ignore next two shorts
			dataOffset += 2 * MemoryLayout<Int16>.size
		}
	}
	
	var _name: String
	open var name: String { get { return _name } }
	var _width: Int16 = 0
	open var width: Int16 { get { return _width } }
	var _height: Int16 = 0
	open var height: Int16 { get { return _height } }
	var patchDescriptors = [PatchDescriptor]()
	var _cachedImage: NSImage?
	
	init(data: Data, dataOffset: inout Int, patchNames: [String]) {
		_name = String(data: data.subdata(in: (dataOffset ..< dataOffset + 8)), encoding: .ascii)!.trimmingCharacters(in: CharacterSet(charactersIn: "\0"))
		dataOffset += 8
		
		// Ignore next two shorts
		dataOffset += 2 * MemoryLayout<Int16>.size
		
		(data as NSData).getBytes(&_width, range: NSMakeRange(dataOffset, MemoryLayout<Int16>.size))
		dataOffset += MemoryLayout<Int16>.size

		(data as NSData).getBytes(&_height, range: NSMakeRange(dataOffset, MemoryLayout<Int16>.size))
		dataOffset += MemoryLayout<Int16>.size
		
		// Ignore next two shorts
		dataOffset += 2 * MemoryLayout<Int16>.size
		
		var numberOfPatchDescriptors: Int16 = 0
		(data as NSData).getBytes(&numberOfPatchDescriptors, range: NSMakeRange(dataOffset, MemoryLayout<Int16>.size))
		dataOffset += MemoryLayout<Int16>.size
		
		for _ in (0 ..< Int(numberOfPatchDescriptors)) {
			let patchDescriptor = PatchDescriptor(data: data, dataOffset: &dataOffset, patchNames: patchNames)
			patchDescriptors.append(patchDescriptor)
		}
	}

	open func imageWithPalette(_ palette: Palette, usingPatchesFromWad wad: Wad) -> NSImage {
		if let image = _cachedImage {
			return image
		}
		
		let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(_width), pixelsHigh: Int(_height), bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: NSCalibratedRGBColorSpace, bytesPerRow: Int(4 * width), bitsPerPixel: 32)
		NSGraphicsContext.setCurrent(NSGraphicsContext(bitmapImageRep: bitmap!))
		
		// Flip coordinate system
		var transform = AffineTransform.identity
		transform.translate(x: 0, y: CGFloat(_height))
		transform.scale(x: 1, y: -1)
		(transform as NSAffineTransform).concat()

		let image = NSImage()
		image.addRepresentation(bitmap!)

		for patchDescriptor in patchDescriptors {
			if let patchGraphic = Graphic.graphicWithLumpName(patchDescriptor.patchName, inWad: wad) {
				let patchImage = patchGraphic.imageWithPalette(palette)
				let patchBitmap = patchImage.representations.first as! NSBitmapImageRep
				patchBitmap.draw(at: NSMakePoint(CGFloat(patchDescriptor.xOffset), CGFloat(patchDescriptor.yOffset)))
			} else {
				print("Unable to find path with name '\(patchDescriptor.patchName)' for texture '\(_name)'")
			}
		}
		
		_cachedImage = image

		return image
	}
}
