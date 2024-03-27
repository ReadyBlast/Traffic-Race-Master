//
//  AnimationEngine.swift
//  Traffic Race Master
//
//  Created by XE on 19.03.2024.
//

import UIKit
import Foundation

final class AnimationEngine {
    private var referenceView: UIView
    private var animatior: UIDynamicAnimator
    private var pushBehavior: UIPushBehavior
    private(set) var collisionBehavior: UICollisionBehavior
    var items: [UIDynamicItem] = []
    
    init(referenceView: UIView) {
        self.referenceView = referenceView
        
        animatior = UIDynamicAnimator(referenceView: referenceView)
        pushBehavior = UIPushBehavior(items: items, mode: .continuous)
        pushBehavior.setAngle((.pi / 2), magnitude: 2)
        animatior.addBehavior(pushBehavior)
        collisionBehavior = UICollisionBehavior(items: items)
        animatior.addBehavior(collisionBehavior)
    }
    
    func addItem(_ element: UIView) {
        pushBehavior.addItem(element)
        collisionBehavior.addItem(element)
        items.append(element)
    }
    func addSubviewToReferenceView(_ element: UIView) {
        referenceView.addSubview(element)
    }
    func removeItem(_ element: UIDynamicItem) {
        pushBehavior.removeItem(element)
        collisionBehavior.removeItem(element)
        for (index, item) in items.enumerated() {
            if element as! UIView == item as! UIView{
                items.remove(at: index)
            }
        }
    }
    func removeAllBehaviors() {
        animatior.removeAllBehaviors()
    }
    
    func equalToReferenceView(view: UIView) -> Bool { view == referenceView }
    
//    deinit {
//        print("Animation Engine deinitializated")
//    }
}
