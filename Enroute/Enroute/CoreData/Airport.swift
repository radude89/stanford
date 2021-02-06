//
//  Airport.swift
//  Enroute
//
//  Created by Radu Dan on 03.02.2021.
//

import CoreData
import Combine
import MapKit

// MARK: - Public API
extension Airport {
    static func withICAO(_ icao: String, context: NSManagedObjectContext) -> Airport {
        let request = fetchRequest(NSPredicate(format: "icao_ = %@", icao))
        let airports = (try? context.fetch(request)) ?? []
        
        if let airport = airports.first {
            return airport
        } else {
            let airport = Airport(context: context)
            airport.icao = icao
            AirportInfoRequest.fetch(icao) { airportInfo in
                update(from: airportInfo, context: context)
            }
            return airport
        }
    }
    
    static func update(from info: AirportInfo, context: NSManagedObjectContext) {
        guard let icao = info.icao else {
            return
        }
        
        let airport = withICAO(icao, context: context)
        airport.latitude = info.latitude
        airport.longitude = info.longitude
        airport.location = info.location
        airport.timezone = info.timezone
        
        airport.objectWillChange.send()
        airport.flightsTo.forEach { $0.objectWillChange.send() }
        airport.flightsFrom.forEach { $0.objectWillChange.send() }
        
        try? context.save()
    }
    
    var flightsTo: Set<Flight> {
        get { (flightsTo_ as? Set<Flight>) ?? [] }
        set { flightsTo_ = newValue as NSSet }
    }
    
    var flightsFrom: Set<Flight> {
        get { (flightsFrom_ as? Set<Flight>) ?? [] }
        set { flightsFrom_ = newValue as NSSet }
    }
}

// MARK: - Parameters
extension Airport: Comparable {
    var icao: String {
        get { icao_! }
        set { icao_ = newValue }
    }
    
    var friendlyName: String {
        let friendly = AirportInfo.friendlyName(name: name ?? "", location: location ?? "")
        return friendly.isEmpty ? icao : friendly
    }
    
    public var id: String { icao }
    
    public static func < (lhs: Airport, rhs: Airport) -> Bool {
        lhs.location ?? lhs.friendlyName < rhs.location ?? rhs.friendlyName
    }
}

// MARK: - Fetch
extension Airport {
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<Airport> {
        let request = NSFetchRequest<Airport>(entityName: "Airport")
        request.sortDescriptors = [NSSortDescriptor(key: "location", ascending: true)]
        request.predicate = predicate
        return request
    }
    
    func fetchIncomingFlights() {
        Self.flightAwareRequest?.stopFetching()
        guard let context = managedObjectContext else {
            return
        }
        
        Self.flightAwareRequest = EnrouteRequest.create(airport: icao, howMany: 90)
        Self.flightAwareRequest?.fetch(andRepeatEvery: 60)
        Self.flightAwareResultsCancellable = Self.flightAwareRequest?.results.sink { results in
            for faflight in results {
                Flight.update(from: faflight, in: context)
            }
            do {
                try context.save()
            } catch(let error) {
                print("couldn't save flight update to CoreData: \(error.localizedDescription)")
            }
        }
    }
    
    private static var flightAwareRequest: EnrouteRequest!
    private static var flightAwareResultsCancellable: AnyCancellable?
}

// MARK: - MKAnnotation
extension Airport: MKAnnotation {
    public var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    public var title: String? {
        name ?? icao
    }
    
    public var subtitle: String? {
        location
    }
}
