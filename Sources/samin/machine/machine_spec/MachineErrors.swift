import Foundation

enum MachineSpecError: Error {
    case unableToLoadFilter(filter: String)
    case invalidPosition
}