//
//  AsyncNetworkOperation.swift
//  GB_VK
//
//  Created by Zen on 30.11.17.
//  Copyright © 2017 Zen. All rights reserved.
//

import Foundation
import UIKit

class AsyncNetworkOperation: Operation {
    internal var dataTask: URLSessionDataTask!
    
    // MARK: - Private
    
    internal enum State: String {
        case ready, executing, finished
        fileprivate var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }
    
    internal var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
}

extension AsyncNetworkOperation {
    override var isAsynchronous: Bool {
        return true
    }
    
    override var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    override var isExecuting: Bool {
        return state == .executing
    }
    
    override var isFinished: Bool {
        return state == .finished
    }
    
    override func cancel() {
        dataTask.cancel()
        super.cancel()
        state = .finished
    }
    
    override func start() {
        if isCancelled {
            state = .finished
            return
        }
        main()
    }
}
