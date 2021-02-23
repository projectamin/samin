//
// Created by swishy on 2/23/21.
//

import Foundation

protocol AminLog {

    // TODO do we need info etc rather than a single 'success' bucket?
    func error(message: String)
    func warning(message: String)
    func success(message: String)

    // Following are to support amin command output. TODO check we actually need something special.
    func aminIn(message: String)
    func aminOut(message: String)
    func aminError(message: String)
}
