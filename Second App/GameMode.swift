//
//  GameMode.swift
//  Second App
//
//  The selectable round lengths. Foundation-only so it stays trivially testable.
//

import Foundation

enum GameMode: String, CaseIterable, Identifiable, Codable {
    case classic
    case sprint
    case marathon

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .classic:
            return "Classic"
        case .sprint:
            return "Sprint"
        case .marathon:
            return "Marathon"
        }
    }

    /// Round length in seconds.
    var duration: Int {
        switch self {
        case .classic:
            return 30
        case .sprint:
            return 10
        case .marathon:
            return 60
        }
    }

    var subtitle: String {
        switch self {
        case .classic:
            return "30 seconds"
        case .sprint:
            return "10 seconds"
        case .marathon:
            return "60 seconds"
        }
    }

    static func mode(forID id: String) -> GameMode? {
        return GameMode(rawValue: id)
    }
}
