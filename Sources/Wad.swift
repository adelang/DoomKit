//
//  Wad.swift
//  DoomKit
//
//  Created by Arjan de Lang on 24-12-14.
//  Copyright (c) 2014 Blue Depths Media. All rights reserved.
//

import Foundation

open class Wad {
	public enum WadType: String {
		case Internal = "IWAD"
		case Patch = "PWAD"
	}

	public struct Lump {
		public let name: String
		public let data: Data?
	}
	
	open let type: WadType!
	open var lumps: [Lump] = []
	open var data: Data!
		
	public init() {
		type = .Patch
	}
	
	public init?(path: String) {
		do {
			let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
			self.data = data

			if let wadTypeString = String(data: data.subdata(in: (0 ..< 4)), encoding: .ascii) {
				switch wadTypeString {
				case "IWAD": self.type = .Internal
				case "PWAD": self.type = .Patch
				default:
					self.type = .Internal
					print("Error reading WAD at path \(path): unknown WAD type \(wadTypeString)")
					return nil
				}
			} else {
				self.type = .Internal
				print("Error reading WAD at path \(path): unable to read wad type")
				return nil
			}

			var numberOfLumps: Int32 = 0
			(data as NSData).getBytes(&numberOfLumps, range: NSMakeRange(4, 4))
			//println("numberOfLumps: \(numberOfLumps)")
			
			var directoryStartAddress: Int32 = 0
			(data as NSData).getBytes(&directoryStartAddress, range: NSMakeRange(8, 4))
			//println("directoryStartAddress: \(directoryStartAddress)")

			var lumpStartAddress = directoryStartAddress
			//println("reading directory...")

			for _ in 0 ..< numberOfLumps {
				//println("reading lump #\(lumpNumber)")

				var dataStartAddress: Int32 = 0
				(data as NSData).getBytes(&dataStartAddress, range: NSMakeRange(Int(lumpStartAddress), 4))
				//println("dataStartAddress: \(dataStartAddress)")
				
				var dataLength: Int32 = 0
				(data as NSData).getBytes(&dataLength, range: NSMakeRange(Int(lumpStartAddress + 4), 4))
				//println("dataLength: \(dataLength)")
				
				let name = String(data: data.subdata(in: Range(Int(lumpStartAddress) + 8 ..< Int(lumpStartAddress) + 16)), encoding: .ascii)!.trimmingCharacters(in: CharacterSet(charactersIn: "\0"))
				print("name: \(name)")
				
				var lumpData: Data? = nil
				if (dataLength > 0) {
					lumpData = data.subdata(in: Range(Int(dataStartAddress) ..< Int(dataStartAddress + dataLength)))
				}
				lumps.append(Lump(name: name, data: lumpData))
				
				lumpStartAddress += 16
			}
			print("Loaded \(lumps.count) lumps")
		} catch let error as NSError {
			self.type = .Internal
			print("Unable to read WAD data from file at path '\(path)': \(error)")
			return nil
		}
	}

	open func writeToPath(_ path: String) {
		let headerData = NSMutableData()
		let lumpData = NSMutableData()
		let directoryData = NSMutableData()
		
		// Write lump data and directory
		for lump in lumps {
			var dataStartAddress: Int32 = 0
			var dataLength: Int32 = 0
			if let data = lump.data {
				dataStartAddress = Int32(lumpData.length) + 12
				dataLength = Int32(data.count)
			  lumpData.append(data)
			}
			directoryData.append(Data(bytes: &dataStartAddress, count: 4))
			directoryData.append(Data(bytes: &dataLength, count: 4))
			directoryData.append(lump.name.padding(toLength: 8, withPad: "\0", startingAt: 0).data(using: String.Encoding.ascii, allowLossyConversion: false)!)
		}

		// Write header
		headerData.append(type.rawValue.data(using: String.Encoding.ascii, allowLossyConversion: false)!)

		var numberOfLumps = Int32(lumps.count)
		headerData.append(Data(bytes: &numberOfLumps, count: 4))

		var directoryStartAddress = Int32(lumpData.length + 12)
		headerData.append(Data(bytes: &directoryStartAddress, count: 4))

		// Combine data to build new Wad file
		let data = NSMutableData()
		data.append(headerData as Data)
		data.append(lumpData as Data)
		data.append(directoryData as Data)
		data.write(toFile: path, atomically: true)
	}
}
