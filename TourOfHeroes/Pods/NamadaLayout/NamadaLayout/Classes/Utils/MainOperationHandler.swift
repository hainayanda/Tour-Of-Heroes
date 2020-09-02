//
//  MultiOperationHandler.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 02/09/20.
//

import Foundation

public protocol ParallelOperationHandler {
    func addOperation(_ closure: @escaping () -> Void)
}

public class MainOperationHandler: ParallelOperationHandler {
    lazy var operationQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.name = uniqueKey
        operationQueue.maxConcurrentOperationCount = 1
        return operationQueue
    }()
    
    var uniqueKey: String {
        let address = Int(bitPattern: Unmanaged.passUnretained(self).toOpaque())
        return NSString(format: "%p", address) as String
    }
    
    public func addOperation(_ closure: @escaping () -> Void) {
        operationQueue.cancelAllOperations()
        operationQueue.addOperation(MainOperation(closure))
    }
    
    class MainOperation: Operation {
        var closure: () -> Void
        init(_ closure: @escaping () -> Void) {
            self.closure = closure
        }
        
        override func main() {
            guard !isCancelled else { return }
            DispatchQueue.main.sync {
                closure()
            }
        }
    }
}

