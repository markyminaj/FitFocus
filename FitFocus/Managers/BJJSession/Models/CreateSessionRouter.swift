//
//  CreateSessionRouter.swift
//
//
//

import SwiftUI

@MainActor
protocol CreateSessionRouter: GlobalRouter {
    
}

extension CoreRouter: CreateSessionRouter { }
