//
//  Logger.swift
//  Mapzin
//
//  Created by Amir Malamud on 03/06/2024.
//

import Foundation
import SwiftyBeaver

class Logger {
    static let shared = Logger()

    private init() {
        let console = ConsoleDestination()
        SwiftyBeaver.addDestination(console)
    }

    func log(_ message: String, level: SwiftyBeaver.Level) {
        switch level {
        case .verbose:
            SwiftyBeaver.verbose(message)
        case .debug:
            SwiftyBeaver.debug(message)
        case .info:
            SwiftyBeaver.info(message)
        case .warning:
            SwiftyBeaver.warning(message)
        case .error:
            SwiftyBeaver.error(message)
        case .critical:
            SwiftyBeaver.critical(message)
        case .
        fault:
            SwiftyBeaver.fault(message)
        }
    }

    func verbose(_ message: String) {
        log(message, level: .verbose)
    }

    func debug(_ message: String) {
        log(message, level: .debug)
    }

    func info(_ message: String) {
        log(message, level: .info)
    }

    func warning(_ message: String) {
        log(message, level: .warning)
    }

    func error(_ message: String) {
        log(message, level: .error)
    }

    func critical(_ message: String) {
        log(message, level: .critical)
    }

    func fault(_ message: String) {
        log(message, level: .fault)
    }
}
