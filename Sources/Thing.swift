//
//  Thing.swift
//  DoomKit
//
//  Created by Arjan de Lang on 26-12-14.
//  Copyright (c) 2014 Blue Depths Media. All rights reserved.
//

import Foundation

open class Thing: NSObject {
	public enum Attribute {
		case countsTowardsItemPercentage
		case isPickup
		case isWeapon
		case isMonster
		case impassable
		case floatsOrHangsFromCeiling
	}
	
	public struct Definition {
		public let typeNumber: UInt16
		public let name: String
		public let radius: UInt
		public let spriteBaseName: String
		public let attributes: [Attribute]
		public let availability: [Game]

		public static let Player1Start     = Definition(typeNumber: 0x0001, name: "Player 1 start",                         radius: 16,  spriteBaseName: "PLAY", attributes: [],                        availability: [DoomShareware, Doom, Doom2])
		public static let Player2Start     = Definition(typeNumber: 0x0002, name: "Player 2 start",                         radius: 16,  spriteBaseName: "PLAY", attributes: [],                        availability: [DoomShareware, Doom, Doom2])
		public static let Player3Start     = Definition(typeNumber: 0x0003, name: "Player 3 start",                         radius: 16,  spriteBaseName: "PLAY", attributes: [],                        availability: [DoomShareware, Doom, Doom2])
		public static let Player4Start     = Definition(typeNumber: 0x0004, name: "Player 4 start",                         radius: 16,  spriteBaseName: "PLAY", attributes: [],                        availability: [DoomShareware, Doom, Doom2])
		public static let BlueKeycard      = Definition(typeNumber: 0x0005, name: "Blue keycard",                           radius: 20,  spriteBaseName: "BKEY", attributes: [.isPickup],               availability: [DoomShareware, Doom, Doom2])
		public static let YellowKeycard    = Definition(typeNumber: 0x0006, name: "Yellow keycard",                         radius: 20,  spriteBaseName: "YKEY", attributes: [.isPickup],               availability: [DoomShareware, Doom, Doom2])
		public static let SpiderMastermind = Definition(typeNumber: 0x0007, name: "Spider mastermind",                      radius: 128, spriteBaseName: "SPID", attributes: [.isMonster, .impassable], availability: [Doom, Doom2])
		public static let Backpack         = Definition(typeNumber: 0x0008, name: "Backpack",                               radius: 20,  spriteBaseName: "BPAK", attributes: [.isPickup],               availability: [DoomShareware, Doom, Doom2])
		public static let Sergeant         = Definition(typeNumber: 0x0008, name: "Former Human Sergeant",                  radius: 20,  spriteBaseName: "SPOS", attributes: [.isMonster, .impassable], availability: [DoomShareware, Doom, Doom2])
		public static let BloodyMess1      = Definition(typeNumber: 0x000A, name: "Bloody mess",                            radius: 16,  spriteBaseName: "PLAY", attributes: [],                        availability: [DoomShareware, Doom, Doom2])
		public static let DeathMatchStart  = Definition(typeNumber: 0x000B, name: "Deathmatch start",                       radius: 20,  spriteBaseName: "PLAY", attributes: [],                        availability: [DoomShareware, Doom, Doom2])
//12	C	S	16	PLAY	W		Bloody mess
//13	D	S	20	RKEY	AB	P	Red keycard
//14	E	S	20	none1	-		Teleport landing
//15	F	S	16	PLAY	N		Dead player
//16	10	R	40	CYBR	+	MO	Cyberdemon
//17	11	R	20	CELP	A	P2	Cell charge pack
//18	12	S	20	POSS	L		Dead former human
//19	13	S	20	SPOS	L		Dead former sergeant
//20	14	S	20	TROO	M		Dead imp
//21	15	S	30	SARG	N		Dead demon
//22	16	R	31	HEAD	L		Dead cacodemon
//23	17	R	16	SKUL	K		Dead lost soul (invisible)
//24	18	S	16	POL5	A		Pool of blood and flesh
//25	19	R	16	POL1	A	O	Impaled human
//26	1A	R	16	POL6	AB	O	Twitching impaled human
//27	1B	R	16	POL4	A	O	Skull on a pole
//28	1C	R	16	POL2	A	O	Five skulls "shish kebab"
//29	1D	R	16	POL3	AB	O	Pile of skulls and candles
//30	1E	R	16	COL1	A	O	Tall green pillar
//31	1F	R	16	COL2	A	O	Short green pillar
//32	20	R	16	COL3	A	O	Tall red pillar
//33	21	R	16	COL4	A	O	Short red pillar
//34	22	S	16	CAND	A		Candle
//35	23	S	16	CBRA	A	O	Candelabra
//36	24	R	16	COL5	AB	O	Short green pillar with beating heart
//37	25	R	16	COL6	A	O	Short red pillar with skull
//38	26	R	20	RSKU	AB	P	Red skull key
//39	27	R	20	YSKU	AB	P	Yellow skull key
//40	28	R	20	BSKU	AB	P	Blue skull key
//41	29	R	16	CEYE	ABCB	O	Evil eye
//42	2A	R	16	FSKU	ABC	O	Floating skull
//43	2B	R	16	TRE1	A	O	Burnt tree
//44	2C	R	16	TBLU	ABCD	O	Tall blue firestick
//45	2D	R	16	TGRN	ABCD	O	Tall green firestick
//46	2E	S	16	TRED	ABCD	O	Tall red firestick
//47	2F	R	16	SMIT	A	O	Stalagmite
//48	30	S	16	ELEC	A	O	Tall techno pillar
//49	31	R	16	GOR1	ABCB	O^	Hanging victim, twitching
//50	32	R	16	GOR2	A	O^	Hanging victim, arms out
//51	33	R	16	GOR3	A	O^	Hanging victim, one-legged
//52	34	R	16	GOR4	A	O^	Hanging pair of legs
//53	35	R	16	GOR5	A	O^	Hanging leg
//54	36	R	32	TRE2	A	O	Large brown tree
//55	37	R	16	SMBT	ABCD	O	Short blue firestick
//56	38	R	16	SMGT	ABCD	O	Short green firestick
//57	39	R	16	SMRT	ABCD	O	Short red firestick
//58	3A	S	30	SARG	+	MO	Spectre
//59	3B	R	16	GOR2	A	^	Hanging victim, arms out
//60	3C	R	16	GOR4	A	^	Hanging pair of legs
//61	3D	R	16	GOR3	A	^	Hanging victim, one-legged
//62	3E	R	16	GOR5	A	^	Hanging leg
//63	3F	R	16	GOR1	ABCB	^	Hanging victim, twitching
//64	40	2	20	VILE	+	MO	Arch-Vile
//65	41	2	20	CPOS	+	MO	Chaingunner
//66	42	2	20	SKEL	+	MO	Revenant
//67	43	2	48	FATT	+	MO	Mancubus
//68	44	2	64	BSPI	+	MO	Arachnotron
//69	45	2	24	BOS2	+	MO	Hell Knight
//70	46	2	10	FCAN	ABC	O	Burning barrel
//71	47	2	31	PAIN	+	MO^	Pain Elemental
//72	48	2	16	KEEN	A+	MO^	Commander Keen
//73	49	2	16	HDB1	A	O^	Hanging victim, guts removed
//74	4A	2	16	HDB2	A	O^	Hanging victim, guts and brain removed
		public static let HangingCorpse2   = Definition(typeNumber: 0x004A, name: "Hanging victim, guts and brain removed", radius: 16,  spriteBaseName: "HDB2", attributes: [.impassable, .floatsOrHangsFromCeiling], availability: [Doom2])
//75	4B	2	16	HDB3	A	O^	Hanging torso, looking down
//76	4C	2	16	HDB4	A	O^	Hanging torso, open skull
//77	4D	2	16	HDB5	A	O^	Hanging torso, looking up
//78	4E	2	16	HDB6	A	O^	Hanging torso, brain removed
//79	4F	2	16	POB1	A		Pool of blood
//80	50	2	16	POB2	A		Pool of blood
//81	51	2	16	BRS1	A		Pool of brains
//82	52	2	20	SGN2	A	WP3	Super shotgun
//83	53	2	20	MEGA	ABCD	AP	Megasphere
		public static let MegaSphere = Definition(typeNumber: 0x0053, name: "Megasphere", radius: 20, spriteBaseName: "MEGA", attributes: [.countsTowardsItemPercentage, .isPickup], availability: [Doom2])
//84	54	2	20	SSWV	+	MO	Wolfenstein SS
//85	55	2	16	TLMP	ABCD	O	Tall techno floor lamp
//86	56	2	16	TLP2	ABCD	O	Short techno floor lamp
//87	57	2	0	none4	-		Spawn spot
//88	58	2	16	BBRN	+	O5	Boss Brain
//89	59	2	20	none6	-		Spawn shooter
//2001	7D1	S	20	SHOT	A	WP3	Shotgun
//2002	7D2	S	20	MGUN	A	WP3	Chaingun
//2003	7D3	S	20	LAUN	A	WP3	Rocket launcher
//2004	7D4	R	20	PLAS	A	WP3	Plasma rifle
//2005	7D5	S	20	CSAW	A	WP7	Chainsaw
//2006	7D6	R	20	BFUG	A	WP3	BFG 9000
//2007	7D7	S	20	CLIP	A	P2	Ammo clip
//2008	7D8	S	20	SHEL	A	P2	Shotgun shells
//2010	7DA	S	20	ROCK	A	P2	Rocket
//2011	7DB	S	20	STIM	A	P8	Stimpack
//2012	7DC	S	20	MEDI	A	P8	Medikit
		public static let SoulSphere = Definition(typeNumber: 0x07DD, name: "Soul sphere", radius: 20, spriteBaseName: "SOUL", attributes: [.countsTowardsItemPercentage, .isPickup], availability: [DoomShareware, Doom, Doom2])
//2014	7DE	S	20	BON1	ABCDCB	AP	Health potion
//2015	7DF	S	20	BON2	ABCDCB	AP	Spiritual armor
//2018	7E2	S	20	ARM1	AB	P9	Green armor
//2019	7E3	S	20	ARM2	AB	P10	Blue armor
//2022	7E6	R	20	PINV	ABCD	AP	Invulnerability
//2023	7E7	R	20	PSTR	A	AP	Berserk
//2024	7E8	S	20	PINS	ABCD	AP	Invisibility
//2025	7E9	S	20	SUIT	A	P	Radiation suit
//2026	7EA	S	20	PMAP	ABCDCB	AP11	Computer map
//2028	7EC	S	16	COLU	A	O	Floor lamp
//2035	7F3	S	10	BAR1	AB+	O	Barrel
//2045	7FD	S	20	PVIS	AB	AP	Light amplification visor
//2046	7FE	S	20	BROK	A	P2	Box of rockets
//2047	7FF	R	20	CELL	A	P2	Cell charge
//2048	800	S	20	AMMO	A	P2	Box of ammo
//2049	801	S	20	SBOX	A	P2	Box of shells
		public static let Imp = Definition(typeNumber: 0x0BB9, name: "Imp", radius: 20, spriteBaseName: "TROO", attributes: [.isMonster, .impassable], availability: [DoomShareware, Doom, Doom2])
		public static let Demon = Definition(typeNumber: 0x0BBA, name: "Demon", radius: 30, spriteBaseName: "SARG", attributes: [.isMonster, .impassable], availability: [DoomShareware, Doom, Doom2])
		public static let BaronOfHell = Definition(typeNumber: 0x0BBB, name: "Baron of Hell", radius: 24, spriteBaseName: "BOSS", attributes: [.isMonster, .impassable], availability: [DoomShareware, Doom, Doom2])
		public static let FormerHumanTrooper = Definition(typeNumber: 0x0BBC, name: "Former Human Trooper", radius: 20, spriteBaseName: "POSS", attributes: [.isMonster, .impassable], availability: [DoomShareware, Doom, Doom2])
		public static let Cacodemon = Definition(typeNumber: 0x0BBD, name: "Cacodemon", radius: 31, spriteBaseName: "HEAD", attributes: [.isMonster, .impassable, .floatsOrHangsFromCeiling], availability: [Doom, Doom2])
		public static let LostSoul = Definition(typeNumber: 0x0BBE, name: "Lost Soul", radius: 16, spriteBaseName: "SKUL", attributes: [.isMonster, .impassable, .floatsOrHangsFromCeiling], availability: [Doom, Doom2])

		static var _definitions = [
			Player1Start,
			Player2Start,
			Player3Start,
			Player4Start,
			BlueKeycard,
			YellowKeycard,
			SpiderMastermind,
			Backpack,
			Sergeant,
			BloodyMess1,
			DeathMatchStart,
			HangingCorpse2,
			MegaSphere,
			SoulSphere,
			Imp,
			Demon,
			BaronOfHell,
			FormerHumanTrooper,
			Cacodemon,
			LostSoul,
		]
		
		public static var definitions: [Definition] {
			get {
				return _definitions
			}
		}
	}
	
	public enum ThingType: UInt16 {
		case unknown = 0x0000
		case player1Start = 0x0001
		case soulSphere = 0x0053
	}
	
	public enum Flag: UInt16 {
		case existsAtEasyDifficulty = 0x0001
		case existsAtNormalDifficulty = 0x0002
		case existsAtHardDifficulty = 0x0004
	}
	
	public enum Angle: UInt16 {
		case east = 0
		case northEast = 45
		case north = 90
		case northWest = 135
		case west = 180
		case southWest = 225
		case south = 270
		case southEast = 315
	}

	dynamic open var x: Int16
	dynamic open var y: Int16
	dynamic open var rawAngle: UInt16
	open var angle: Angle { get { return Angle(rawValue: rawAngle) ?? .north } set { rawAngle = newValue.rawValue } }
	dynamic open var rawType: UInt16
	open var type: ThingType { get { return ThingType(rawValue: rawType) ?? .unknown } set { rawType = newValue.rawValue } }
	open var definition: Definition? {
		get {
			for definition in Definition.definitions {
				if definition.typeNumber == self.rawType {
					return definition
				}
			}
			return nil
		}
		set {
			self.rawType = newValue?.typeNumber ?? 0
		}
	}
	dynamic open var rawFlags: UInt16
	// Convenience accessors for thing flags
	open var existsAtEasyDifficulty: Bool { get { return getFlag(.existsAtEasyDifficulty) } set { setFlag(.existsAtEasyDifficulty, newValue: newValue) } }
	open var existsAtNormalDifficulty: Bool { get { return getFlag(.existsAtNormalDifficulty) } set { setFlag(.existsAtNormalDifficulty, newValue: newValue) } }
	open var existsAtHardDifficulty: Bool { get { return getFlag(.existsAtHardDifficulty) } set { setFlag(.existsAtHardDifficulty, newValue: newValue) } }

	func getFlag(_ flag: Flag) -> Bool {
		return (rawFlags & flag.rawValue) != UInt16(0)
	}
	
	func setFlag(_ flag: Flag, newValue: Bool) {
		if newValue {
			rawFlags |= flag.rawValue
		} else {
			rawFlags &= ~flag.rawValue
		}
	}

	open class func decodeThingsFromLump(_ lump: Wad.Lump) -> [Thing] {
		var things: [Thing] = []
		if let data = lump.data {
			for thingDataStart in stride(from: 0, to: data.count, by: 10) {
				var x: Int16 = 0
				(data as NSData).getBytes(&x, range: NSMakeRange(thingDataStart, 2))

				var y: Int16 = 0
				(data as NSData).getBytes(&y, range: NSMakeRange((thingDataStart + 2), 2))

				var rawAngle: UInt16 = 0
				(data as NSData).getBytes(&rawAngle, range: NSMakeRange((thingDataStart + 4), 2))

				var rawType: UInt16 = 0
				(data as NSData).getBytes(&rawType, range: NSMakeRange((thingDataStart + 6), 2))

				var rawFlags: UInt16 = 0
				(data as NSData).getBytes(&rawFlags, range: NSMakeRange((thingDataStart + 8), 2))

				things.append(Thing(x: x, y: y, rawAngle: rawAngle, rawType: rawType, rawFlags: rawFlags))
			}
		}
		return things
	}

	open class func encodeThingsToLump(_ things: [Thing]) -> Wad.Lump {
		var data = Data()
		for thing in things {
			data.append(Data(bytes: &thing.x, count: 2))
			data.append(Data(bytes: &thing.y, count: 2))
			data.append(Data(bytes: &thing.rawAngle, count: 2))
			data.append(Data(bytes: &thing.rawType, count: 2))
			data.append(Data(bytes: &thing.rawFlags, count: 2))
		}
		return Wad.Lump(name: "THINGS", data: data)
	}

	public init(x: Int16, y: Int16, rawAngle: UInt16, rawType: UInt16, rawFlags: UInt16) {
		self.x = x
		self.y = y
		self.rawAngle = rawAngle
		self.rawType = rawType
		self.rawFlags = rawFlags
	}

	public convenience init(x: Int16, y: Int16, angle: Angle, type: Definition, flags: [Flag]) {
		var rawFlags: UInt16 = 0
		for flag in flags {
			rawFlags |= flag.rawValue
		}
		self.init(x: x, y: y, rawAngle: angle.rawValue, rawType: type.typeNumber, rawFlags: rawFlags)
	}

	public convenience init(x: Int16, y: Int16, angle: Angle, type: Definition) {
		self.init(x: x, y: y, angle: angle, type: type, flags: [.existsAtEasyDifficulty, .existsAtNormalDifficulty, .existsAtHardDifficulty])
	}
}

public func ==(lhs: Thing, rhs: Thing) -> Bool {
	return lhs === rhs
}
