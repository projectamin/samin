import Foundation

class CommandResult {
    var status: String?
    var type: CommandType?
    // TODO verify these are needed - aim is to output as we execute rather than buffer and dump.
    // TODO need to discuss with Bryan re runtime implications in stream processing.
    var error: String?
    var out: String?
}
