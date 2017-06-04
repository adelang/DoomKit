//
//  Math.swift
//  DoomKit
//
//  Created by Arjan de Lang on 01-11-15.
//  Copyright © 2015 Blue Depths Media. All rights reserved.
//

import Foundation

public struct Point {
	public var x: Double
	public var y: Double
	
	public func isOnLeftSideOfLine(_ line: Line) -> Bool {
		return true
	}
	
	public func isOnRightSideOfLine(_ line: Line) -> Bool {
		return !self.isOnLeftSideOfLine(line)
	}
}

public struct Line {
	public var startPoint: Point
	public var endPoint: Point
}

public struct Triangle {
	public var point1: Point
	public var point2: Point
	public var point3: Point
	
	public init(point1: Point, point2: Point, point3: Point) {
		self.point1 = point1
		self.point2 = point2
		self.point3 = point3
	}
	
	// Source: http://totologic.blogspot.fr/2014/01/accurate-point-in-triangle-test.html
	public func containsPoint(_ point: Point) -> Bool {
		let denominator = ((point2.y - point3.y) * (point1.x - point3.x) + (point3.x - point2.x) * (point1.y - point3.y))
		let a = ((point2.y - point3.y) * (point.x - point3.x) + (point3.x - point2.x) * (point.y - point3.y)) / denominator
		let b = ((point3.y - point1.y) * (point.x - point3.x) + (point1.x - point3.x) * (point.y - point3.y)) / denominator
		let c = 1 - a - b
		
		return 0 <= a && a <= 1 && 0 <= b && b <= 1 && 0 <= c && c <= 1
	}
}
