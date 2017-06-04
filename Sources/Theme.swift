//
//  Theme.swift
//  DoomKit
//
//  Created by Arjan de Lang on 26-12-14.
//  Copyright (c) 2014 Blue Depths Media. All rights reserved.
//

import Foundation

extension Map {
	struct Theme {
		let floorTexture: String
		let ceilingTexture: String
		let upperTexture: String
		let lowerTexture: String
		let middleTexture: String
		
		static var standard: Theme {
			get {
				return Theme(floorTexture: "", ceilingTexture: "", upperTexture: "", lowerTexture: "", middleTexture: "")
			}
		}
	}
}