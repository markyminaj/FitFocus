//
//  Builder.swift
//  FitFocus
//
//  
//
import SwiftUI

@MainActor
protocol Builder {
    func build() -> AnyView
}
