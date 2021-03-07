import Foundation

enum MachineSpecError: Error {
    case failedToLoadMachineSpec
    case unableToLoadFilter(filter: String)
    case invalidPosition
}