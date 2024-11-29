//
//  HapticManager.swift
//  Secret Snap
//
//  Created by Karan Verma on 29/11/24.
//


import UIKit

final class HapticManager {
    
    // Singleton instance
    static let shared = HapticManager()
    
    // Private initializer to restrict instantiation
    private init() {}
    
    // MARK: - Public Methods
    
    /// Generates haptic feedback for success
    func generateSuccessHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    /// Generates haptic feedback for warning
    func generateWarningHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
    
    /// Generates haptic feedback for error
    func generateErrorHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
    /// Generates light haptic impact
    func generateLightImpactHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    /// Generates medium haptic impact
    func generateMediumImpactHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    /// Generates heavy haptic impact
    func generateHeavyImpactHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
    
    /// Generates rigid haptic impact
    func generateRigidImpactHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred()
    }
    
    /// Generates soft haptic impact
    func generateSoftImpactHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
    }
    
    /// Generates selection change haptic feedback
    func generateSelectionHaptic() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}