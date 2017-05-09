//: Playground - noun: a place where people can play

import UIKit

//  Parking Lot: Design a parking lot using object-oriented principles.

enum VehicleSize {
    case compact
    case motorcylce
    case large
}

class Vehicle {
    private var parkingSpots = [ParkingSpot]()
    private var licensePlate: String
    internal var spotsNeeded = 0
    internal var size: VehicleSize = .compact
    
    init(licensePlate: String) {
        self.licensePlate = licensePlate
    }
    
    func getSpotsNeeded() -> Int {
        return spotsNeeded
    }
    
    func getSize() -> VehicleSize {
        return size
    }
    
    func parkInSpot(spot: ParkingSpot) {
        parkingSpots.append(spot)
    }
    
    func clearSpots() {
        for i in 0 ..< parkingSpots.count {
            parkingSpots[i].removeVehicle()
        }
        parkingSpots = []
    }
    
    func canFitinSpot(spot: ParkingSpot) -> Bool {
        return false
    }
    
    func printOutput() {
    }
    
}

class Motorcyle: Vehicle {
    override init(licensePlate: String) {
        super.init(licensePlate: licensePlate)
        spotsNeeded = 1
        size = .motorcylce
    }
    
    override func canFitinSpot(spot: ParkingSpot) -> Bool {
        return true
    }
    
    override func printOutput() {
        print("Motorcycle")
    }
}

class Car: Vehicle {
    override init(licensePlate: String) {
        super.init(licensePlate: licensePlate)
        spotsNeeded = 1
        size = .compact
    }
    
    override func canFitinSpot(spot: ParkingSpot) -> Bool {
        return spot.getSpotSize() == .large || spot.getSpotSize() == .compact
    }
    
    override func printOutput() {
        print("Car")
    }
    
}

class Bus: Vehicle {
    override init(licensePlate: String) {
        super.init(licensePlate: licensePlate)
        spotsNeeded = 5
        size = .large
    }
    
    override func canFitinSpot(spot: ParkingSpot) -> Bool {
        return spot.getSpotSize() == .large
    }
    
    override func printOutput() {
        print("Bus")
    }
}

class ParkingSpot {
    
    private var vehicle: Vehicle?
    private var spotSize: VehicleSize
    private var row: Int
    private var spotNumber: Int
    private var level: Level
    
    init(level: Level, row: Int, spotNumber: Int, spotSize: VehicleSize) {
        self.level = level
        self.row = row
        self.spotNumber = spotNumber
        self.spotSize = spotSize
    }
    
    func isAvailable() -> Bool {
        return vehicle == nil
    }
    
    func canFitVehicle(vehicle: Vehicle) -> Bool {
        return isAvailable() && vehicle.canFitinSpot(spot: self)
    }
    
    func park(vehicle: Vehicle) -> Bool {
        if !canFitVehicle(vehicle: vehicle) {
            return false
        }
        self.vehicle = vehicle
        vehicle.parkInSpot(spot: self)
        return true
    }
    
    func getRow() -> Int {
        return row
    }
    
    func getSpotNumber() -> Int {
        return spotNumber
    }
    
    func getSpotSize() -> VehicleSize {
        return spotSize
    }
    
    func removeVehicle() {
        level.spotFreed()
        vehicle = nil
    }
    
    func printOutput() {
        if vehicle == nil {
            if spotSize == .compact {
                print("C")
            } else if spotSize == .large {
                print("L")
            } else if spotSize == .motorcylce {
                print("M")
            }
        } else {
            vehicle?.printOutput()
        }
    }
}


class Level {
    
    private var floor: Int
    private var spots = [ParkingSpot]()
    private var availableSpots = 0
    private let spotsPerRow = 10
    
    init(floor: Int, numberOfSpots: Int) {
        self.floor = floor
        let largeSpots = numberOfSpots / 4
        let bikeSpots = numberOfSpots / 4
        let compactSpots = numberOfSpots - largeSpots - bikeSpots
        for i in 0 ..< numberOfSpots {
            var size = VehicleSize.motorcylce
            if i < largeSpots {
                size = .large
            } else if i < largeSpots + compactSpots {
                size = .compact
            }
            let row = i / spotsPerRow
            let parkingSpot = ParkingSpot(level: self, row: row, spotNumber: i, spotSize: size)
            spots.append(parkingSpot)
        }
        availableSpots = numberOfSpots
    }
    
    func availableParkingSpots() -> Int {
        return availableSpots
    }
    
    func findAvailableSpots(vehicle: Vehicle) -> Int {
        let spotsNeeded = vehicle.getSpotsNeeded()
        var lastRow = -1
        var spotsFound = 0
        for i in 0 ..< spots.count {
            let parkingSpot = spots[i]
            if lastRow != parkingSpot.getRow() {
                spotsFound = 0
                lastRow = parkingSpot.getRow()
            }
            
            if parkingSpot.canFitVehicle(vehicle: vehicle) {
                spotsFound += 1
            } else {
                spotsFound = 0
            }
            if spotsFound == spotsNeeded {
                return i - (spotsNeeded - 1)
            }
        }
        return -1
    }
    
    func parkStartingAtSpot(spotNumber: Int, vehicle: Vehicle) -> Bool {
        vehicle.clearSpots()
        var success = true
        for i in spotNumber ..< spotNumber + vehicle.spotsNeeded {
            success = success && spots[i].park(vehicle: vehicle)
        }
        availableSpots -= vehicle.spotsNeeded
        return success
    }
    
    func parkVehicle(vehicle: Vehicle) -> Bool {
        if availableSpots < vehicle.getSpotsNeeded() {
            return false
        }
        let spotNumbers = findAvailableSpots(vehicle: vehicle)
        if spotNumbers < 0 {
            return false
        }
        
        return parkStartingAtSpot(spotNumber: spotNumbers, vehicle: vehicle)
    }
    
    func spotFreed() {
        availableSpots += 1
    }
    
    func printOutput() {
        var lastRow = -1
        for i in 0 ..< spots.count {
            let parkingSpot = spots[i]
            if parkingSpot.getRow() != lastRow {
                print(" ")
                lastRow = parkingSpot.getRow()
            }
            parkingSpot.printOutput()
        }
    }
}

class ParkingLot {
    private var levels = [Level]()
    let numOfLevels = 2
    
    init() {
        for i in 0 ..< numOfLevels {
            let level = Level(floor: i, numberOfSpots: 30)
            levels.append(level)
        }
    }
    
    func parkVehicle(vehicle: Vehicle) -> Bool {
        for i in 0 ..< levels.count {
            if levels[i].parkVehicle(vehicle: vehicle) {
                return true
            }
        }
        return false
    }
    
    func printOutput() {
        for i in 0 ..< levels.count {
            print("Level \(i): ")
            levels[i].printOutput()
            print("")
        }
        print("")
    }
    
    func getLevels() -> [Level] {
        return levels
    }
    
}

class Test {
    
    func startTest() {
        let lot = ParkingLot()
        var vehicle: Vehicle? = nil
        while vehicle == nil || lot.parkVehicle(vehicle: vehicle!) {
            lot.printOutput()
            let r = 1 // arc4random_uniform(10) // Don't want the loop to run too long so we choose a fix 1 here.
            if r < 2 {
                vehicle = Bus(licensePlate: "Bus")
            } else if r < 4 {
                vehicle = Motorcyle(licensePlate: "Motorcyle")
            } else {
                vehicle = Car(licensePlate: "Car")
            }
            print("\nParking a ")
            vehicle?.printOutput()
            print("")
        }
        print("Parking Failed. Final State: ")
        lot.printOutput()
        
        let levels = lot.getLevels()
        for i in 0 ..< levels.count {
            print("Available spots remaining in level \(i) is: \(levels[i].availableParkingSpots())")
        }
        
    }
    
    
}

let test = Test()
test.startTest()






























