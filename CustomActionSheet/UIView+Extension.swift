//
//  UIView+Constraints.swift
//  CiLabs
//
//  Copyright © 2017 Netguru.co. All rights reserved.
//
import UIKit

typealias Constraint = (_ layoutView: UIView) -> NSLayoutConstraint

//
// Solution based on http://chris.eidhof.nl/post/micro-autolayout-dsl/
//
// https://www.netguru.com/codestories/painless-nslayoutanchors
extension UIView {
    
    /// Adds constraints using NSLayoutAnchors, based on description provided in params.
    /// Please refer to helper equal funtions for info how to generate constraints easily.
    ///
    /// - Parameter constraintDescriptions: constrains array
    /// - Returns: created constraints
    @discardableResult func addConstraints(_ constraintDescriptions: [Constraint]) -> [NSLayoutConstraint] {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraints = constraintDescriptions.map { $0(self) }
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
}


/// Describes constraint that is equal to constraint from different view.
/// Example: `equal(superView, \.centerXAnchor) will align view centerXAnchor to superview centerXAnchor`
///
/// - Parameters:
///   - view: that constrain should relate to
///   - to: constraints key path
/// - Returns: created constraint
func equal<Anchor, Axis>(_ view: UIView, _ to: KeyPath<UIView, Anchor>) -> Constraint where Anchor: NSLayoutAnchor<Axis> {
    return { layoutView in
        layoutView[keyPath: to].constraint(equalTo: view[keyPath: to])
    }
}


/// Describes constraint that will be equal to constant
/// Example: `equal(\.heightAnchor, to: 36) will create height constraint with value 36`
///
/// - Parameters:
///   - keyPath: constraint key path
///   - constant: value
/// - Returns: created constraint
func equal<LayoutDimension>(_ keyPath: KeyPath<UIView, LayoutDimension>, to constant: CGFloat) -> Constraint where LayoutDimension: NSLayoutDimension {
    return { layoutView in
        layoutView[keyPath: keyPath].constraint(equalToConstant: constant)
    }
}


/// Describes relation between constraints of two views
/// Example: `equal(logoImageView, \.topAnchor, \.bottomAnchor, constant: 80)`
/// will create constraint where topAnchor of current view is linked to bottomAnchor of passed view with offset 80
///
/// - Parameters:
///   - view: view that constraint is related from
///   - from: constraint key path of current view
///   - to: constraint key path of related view
///   - constant: value
/// - Returns: created constraint
func equal<Anchor, Axis>(_ view: UIView, _ from: KeyPath<UIView, Anchor>, _ to: KeyPath<UIView, Anchor>, constant: CGFloat = 0) -> Constraint where Anchor: NSLayoutAnchor<Axis> {
    return { layoutView in
        layoutView[keyPath: from].constraint(equalTo: view[keyPath: to], constant: constant)
    }
}

/// Describes relation between constraints of two views
/// Example: `equal(logoImageView, \.topAnchor, \.bottomAnchor, constant: 80)`
/// will create constraint where topAnchor of current view is linked to bottomAnchor of passed view with offset less or equal 80
///
/// - Parameters:
///   - view: view that constraint is related from
///   - from: constraint key path of current view
///   - to: constraint key path of related view
///   - constant: value
/// - Returns: created constraint
func equal<Anchor, Axis>(_ view: UIView, _ from: KeyPath<UIView, Anchor>, _ to: KeyPath<UIView, Anchor>, lessOrEqual: CGFloat = 0) -> Constraint where Anchor: NSLayoutAnchor<Axis> {
    return { layoutView in
        layoutView[keyPath: from].constraint(lessThanOrEqualTo: view[keyPath: to], constant: lessOrEqual)
    }
}

/// Describes relation between constraints of two views
/// Example: `equal(logoImageView, \.topAnchor, \.bottomAnchor, constant: 80)`
/// will create constraint where topAnchor of current view is linked to bottomAnchor of passed view with offest greater or equal to 80
///
/// - Parameters:
///   - view: view that constraint is related from
///   - from: constraint key path of current view
///   - to: constraint key path of related view
///   - constant: value
/// - Returns: created constraint
func equal<Anchor, Axis>(_ view: UIView, _ from: KeyPath<UIView, Anchor>, _ to: KeyPath<UIView, Anchor>, greaterOrEqual: CGFloat = 0) -> Constraint where Anchor: NSLayoutAnchor<Axis> {
    return { layoutView in
        layoutView[keyPath: from].constraint(greaterThanOrEqualTo: view[keyPath: to], constant: greaterOrEqual)
    }
}


/// Describes constraints from diffrent views where anchors should match with passed offset
/// Example: `equal(self, \.bottomAnchor, constant: -37)` will align bottomAnchors of current and passed view with offset -37
///
/// - Parameters:
///   - view: view that constraint is related from
///   - keyPath: constraint key path
///   - constant: value
/// - Returns: created constraint
func equal<Axis, Anchor>(_ view: UIView, _ keyPath: KeyPath<UIView, Anchor>, constant: CGFloat = 0) -> Constraint where Anchor: NSLayoutAnchor<Axis> {
    return equal(view, keyPath, keyPath, constant: constant)
}


/// Describes array of constraints that will pin view to its superview.
/// If invoked on iOS 11, this method will pin top and bottom view edges to `safeAreaLayoutGuide`!
/// Example `view.addConstraints(equalToSuperview())`
///
/// - Parameter insets: Optional insets parameter. By default it's set to .zero.
/// - Returns: Array of `Constraint`.
/// - Warning: This method uses force-unwrap on view's superview!
/// - Warning: Pins top and bottom edges to `safeAreaLayoutGuide`!
func equalToSuperview(with insets: UIEdgeInsets = .zero) -> [Constraint] {
    
    let top: Constraint
    let bottom: Constraint
    if #available(iOS 11, *) {
        top = { layoutView in
            layoutView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: layoutView.superview!.safeAreaLayoutGuide.topAnchor, constant: insets.top)
        }
        
        bottom = { layoutView in
            layoutView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: layoutView.superview!.safeAreaLayoutGuide.bottomAnchor, constant: insets.bottom)
        }
    } else {
        top = { layoutView in
            layoutView.topAnchor.constraint(equalTo: layoutView.superview!.topAnchor, constant: insets.top)
        }
        
        bottom = { layoutView in
            layoutView.bottomAnchor.constraint(equalTo: layoutView.superview!.bottomAnchor, constant: insets.bottom)
        }
    }
    
    let leading: Constraint = { layoutView in
        layoutView.leadingAnchor.constraint(equalTo: layoutView.superview!.leadingAnchor, constant: insets.left)
    }
    
    let trailing: Constraint = { layoutView in
        layoutView.trailingAnchor.constraint(equalTo: layoutView.superview!.trailingAnchor, constant: insets.right)
    }
    
    return [leading, top, trailing, bottom]
}
