import UIKit
public struct LayoutProxy {
    /// The width of the view.
    public var width: Dimension {
        return Dimension(context, view, .width, needsSafeArea)
    }
    /// The height of the view.
    public var height: Dimension {
        return Dimension(context, view, .height, needsSafeArea)
    }
    /// The size of the view. This property affects both `width` and `height`.
    public var size: Size {
        return Size(context, [
            Dimension(context, view, .width, needsSafeArea),
            Dimension(context, view, .height, needsSafeArea)
            ])
    }
    /// The top edge of the view.
    public var top: Edge {
        return Edge(context, view, .top, needsSafeArea)
    }
    /// The right edge of the view.
    public var right: Edge {
        return Edge(context, view, .right, needsSafeArea)
    }
    /// The bottom edge of the view.
    public var bottom: Edge {
        return Edge(context, view, .bottom, needsSafeArea)
    }
    /// The left edge of the view.
    public var left: Edge {
        return Edge(context, view, .left, needsSafeArea)
    }
    /// All edges of the view. This property affects `top`, `bottom`, `leading`
    /// and `trailing`.
    public var edges: Edges {
        return Edges(context, [
            Edge(context, view, .top, needsSafeArea),
            Edge(context, view, .leading, needsSafeArea),
            Edge(context, view, .bottom, needsSafeArea),
            Edge(context, view, .trailing, needsSafeArea)
            ])
    }
    /// The leading edge of the view.
    public var leading: Edge {
        return Edge(context, view, .leading, needsSafeArea)
    }
    /// The trailing edge of the view.
    public var trailing: Edge {
        return Edge(context, view, .trailing, needsSafeArea)
    }
    /// The horizontal center of the view.
    public var centerX: Edge {
        return Edge(context, view, .centerX, needsSafeArea)
    }
    /// The vertical center of the view.
    public var centerY: Edge {
        return Edge(context, view, .centerY, needsSafeArea)
    }
    /// The center point of the view. This property affects `centerX` and
    /// `centerY`.
    public var center: Point {
        return Point(context, [
            Edge(context, view, .centerX, needsSafeArea),
            Edge(context, view, .centerY, needsSafeArea)
            ])
    }
    /// The baseline of the view.
    public var baseline: Edge {
        return Edge(context, view, .lastBaseline, needsSafeArea)
    }
    /// The last baseline of the view.
    public var lastBaseline: Edge {
        return Edge(context, view, .lastBaseline, needsSafeArea)
    }
    #if os(iOS) || os(tvOS)
    /// The first baseline of the view. iOS exclusive.
    @available(iOS, introduced: 8.0)
    public var firstBaseline: Edge {
        return Edge(context, view, .firstBaseline, needsSafeArea)
    }
    /// All edges of the view with their respective margins. This property
    /// affects `topMargin`, `bottomMargin`, `leadingMargin` and
    /// `trailingMargin`.
    @available(iOS, introduced: 8.0)
    public var edgesWithinMargins: Edges {
        return Edges(context, [
            Edge(context, view, .topMargin, needsSafeArea),
            Edge(context, view, .leadingMargin, needsSafeArea),
            Edge(context, view, .bottomMargin, needsSafeArea),
            Edge(context, view, .trailingMargin, needsSafeArea)
            ])
    }
    /// The left margin of the view. iOS exclusive.
    @available(iOS, introduced: 8.0)
    public var leftMargin: Edge {
        return Edge(context, view, .leftMargin, needsSafeArea)
    }
    /// The right margin of the view. iOS exclusive.
    @available(iOS, introduced: 8.0)
    public var rightMargin: Edge {
        return Edge(context, view, .rightMargin, needsSafeArea)
    }
    /// The top margin of the view. iOS exclusive.
    @available(iOS, introduced: 8.0)
    public var topMargin: Edge {
        return Edge(context, view, .topMargin, needsSafeArea)
    }
    /// The bottom margin of the view. iOS exclusive.
    @available(iOS, introduced: 8.0)
    public var bottomMargin: Edge {
        return Edge(context, view, .bottomMargin, needsSafeArea)
    }
    /// The leading margin of the view. iOS exclusive.
    @available(iOS, introduced: 8.0)
    public var leadingMargin: Edge {
        return Edge(context, view, .leadingMargin, needsSafeArea)
    }
    /// The trailing margin of the view. iOS exclusive.
    @available(iOS, introduced: 8.0)
    public var trailingMargin: Edge {
        return Edge(context, view, .trailingMargin, needsSafeArea)
    }
    /// The horizontal center within the margins of the view. iOS exclusive.
    @available(iOS, introduced: 8.0)
    public var centerXWithinMargins: Edge {
        return Edge(context, view, .centerXWithinMargins, needsSafeArea)
    }
    /// The vertical center within the margins of the view. iOS exclusive.
    @available(iOS, introduced: 8.0)
    public var centerYWithinMargins: Edge {
        return Edge(context, view, .centerYWithinMargins, needsSafeArea)
    }
    /// The center point within the margins of the view. This property affects
    /// `centerXWithinMargins` and `centerYWithinMargins`. iOS exclusive.
    @available(iOS, introduced: 8.0)
    public var centerWithinMargins: Point {
        return Point(context, [
            Edge(context, view, .centerXWithinMargins, needsSafeArea),
            Edge(context, view, .centerYWithinMargins, needsSafeArea)
            ])
    }
    #endif
    internal let context: Context
    internal let view: View
    private let needsSafeArea: Bool
    /// The superview of the view, if it exists.
    public var superview: LayoutProxy? {
        if let superview = view.superview {
            return LayoutProxy(context, superview)
        } else {
            return nil
        }
    }
    #if os(iOS) || os(tvOS)
    /// The safeArea of the view.
    @available(iOS, introduced: 11.0)
    public var safeArea: LayoutProxy {
        return LayoutProxy(context, view, true)
    }
    #endif
    init(_ context: Context, _ view: View, _ needsSafeArea: Bool = false) {
        self.context = context
        self.view = view
        self.needsSafeArea = needsSafeArea
    }
}

internal protocol LayoutItem: class {}
extension View: LayoutItem {}
#if os(iOS) || os(tvOS)
    @available(iOS 9.0, tvOS 9.0, *)
    extension UILayoutGuide: LayoutItem {}
#endif
public struct Expression<T> {
    let value: T
    var coefficients: [Coefficients]
    init(_ value: T, _ coefficients: [Coefficients]) {
        assert(coefficients.count > 0)
        self.value = value
        self.coefficients = coefficients
    }
}
//
//  Edges.swift
//  Cartography
//
//  Created by Robert Böhnke on 19/06/14.
//  Copyright (c) 2014 Robert Böhnke. All rights reserved.
//

public struct Edges: Compound, RelativeCompoundEquality, RelativeCompoundInequality {
    public let context: Context
    public let properties: [Property]
    internal init(_ context: Context, _ properties: [Property]) {
        self.context = context
        self.properties = properties
    }
}
/// Insets all edges.
///
/// - parameter edges: The edges to inset.
/// - parameter all:   The amount by which to inset all edges, in points.
///
/// - returns: A new expression with the inset edges.
///
public func inset(_ edges: Edges, _ all: CGFloat) -> Expression<Edges> {
    return inset(edges, all, all, all, all)
}
/// Insets the horizontal and vertical edges.
///
/// - parameter edges:      The edges to inset.
/// - parameter horizontal: The amount by which to inset the horizontal edges, in
///                    points.
/// - parameter vertical:   The amount by which to inset the vertical edges, in
///                    points.
///
/// - returns: A new expression with the inset edges.
///
public func inset(_ edges: Edges, _ horizontal: CGFloat, _ vertical: CGFloat) -> Expression<Edges> {
    return inset(edges, vertical, horizontal, vertical, horizontal)
}
/// Insets edges individually.
///
/// - parameter edges:    The edges to inset.
/// - parameter top:      The amount by which to inset the top edge, in points.
/// - parameter leading:  The amount by which to inset the leading edge, in points.
/// - parameter bottom:   The amount by which to inset the bottom edge, in points.
/// - parameter trailing: The amount by which to inset the trailing edge, in points.
///
/// - returns: A new expression with the inset edges.
///
public func inset(_ edges: Edges, _ top: CGFloat, _ leading: CGFloat, _ bottom: CGFloat, _ trailing: CGFloat) -> Expression<Edges> {
    return Expression(edges, [
        Coefficients(1, top),
        Coefficients(1, leading),
        Coefficients(1, -bottom),
        Coefficients(1, -trailing)
        ])
}
#if os(iOS) || os(tvOS)
    /// Insets edges individually with UIEdgeInset.
    ///
    /// - parameter edges:    The edges to inset.
    /// - parameter insets:   The amounts by which to inset all edges, in points via UIEdgeInsets.
    ///
    /// - returns: A new expression with the inset edges.
    ///
    public func inset(_ edges: Edges, _ insets: UIEdgeInsets) -> Expression<Edges> {
        return inset(edges, insets.top, insets.left, insets.bottom, insets.right)
    }
#endif
//
//  Edge.swift
//  Cartography
//
//  Created by Robert Böhnke on 17/06/14.
//  Copyright (c) 2014 Robert Böhnke. All rights reserved.
//

public struct Edge : Property, RelativeEquality, RelativeInequality, Addition, Multiplication {
    public let attribute: LayoutAttribute
    public let context: Context
    public let view: View
    public let needsSafeArea: Bool
    internal init(_ context: Context, _ view: View, _ attribute: LayoutAttribute, _ needsSafeArea: Bool) {
        self.attribute = attribute
        self.context = context
        self.view = view
        self.needsSafeArea = needsSafeArea
    }
}
//
//  Dimension.swift
//  Cartography
//
//  Created by Robert Böhnke on 17/06/14.
//  Copyright (c) 2014 Robert Böhnke. All rights reserved.
//

public struct Dimension : Property, NumericalEquality, RelativeEquality, NumericalInequality, RelativeInequality, Addition, Multiplication {
    public let attribute: LayoutAttribute
    public let context: Context
    public let view: View
    public let needsSafeArea: Bool
    internal init(_ context: Context, _ view: View, _ attribute: LayoutAttribute, _ needsSafeArea: Bool) {
        self.attribute = attribute
        self.context = context
        self.view = view
        self.needsSafeArea = needsSafeArea
    }
}
//
//  Context.swift
//  Cartography
//
//  Created by Robert Böhnke on 06/10/14.
//  Copyright (c) 2014 Robert Böhnke. All rights reserved.
//
public typealias LayoutRelation = NSLayoutRelation
public class Context {
    internal var constraints: [Constraint] = []
    #if os(iOS) || os(tvOS)
    internal func addConstraint(_ from: Property, to: LayoutSupport, coefficients: Coefficients = Coefficients(), relation: LayoutRelation = .equal) -> NSLayoutConstraint {
        from.view.car_translatesAutoresizingMaskIntoConstraints = false
        let item: LayoutItem
        if #available(iOS 11.0, tvOS 11.0, *), from.needsSafeArea {
            item = from.view.safeAreaLayoutGuide
        } else {
            item = from.view
        }
        let layoutConstraint = NSLayoutConstraint(item: item,
                                                  attribute: from.attribute,
                                                  relatedBy: relation,
                                                  toItem: to.layoutGuide,
                                                  attribute: to.attribute,
                                                  multiplier: CGFloat(coefficients.multiplier),
                                                  constant: CGFloat(coefficients.constant))
        var view = from.view
        while let superview = view.superview {
            view = superview
        }
        constraints.append(Constraint(view: view, layoutConstraint: layoutConstraint))
        return layoutConstraint
    }
    internal func addConstraint(_ from: Property, to: Property? = nil, coefficients: Coefficients = Coefficients(), relation: LayoutRelation = .equal) -> NSLayoutConstraint {
        from.view.car_translatesAutoresizingMaskIntoConstraints = false
        let item: LayoutItem
        let toItem: LayoutItem?
        if #available(iOS 11.0, tvOS 11.0, *), from.needsSafeArea {
            item = from.view.safeAreaLayoutGuide
        } else {
            item = from.view
        }
        if #available(iOS 11.0, tvOS 11.0, *), let needsSafeArea = to?.needsSafeArea, needsSafeArea {
            toItem = to?.view.safeAreaLayoutGuide
        } else {
            toItem = to?.view
        }
        let layoutConstraint = NSLayoutConstraint(item: item,
                                                  attribute: from.attribute,
                                                  relatedBy: relation,
                                                  toItem: toItem,
                                                  attribute: to?.attribute ?? .notAnAttribute,
                                                  multiplier: CGFloat(coefficients.multiplier),
                                                  constant: CGFloat(coefficients.constant))
        if let to = to {
            if let common = closestCommonAncestor(from.view, b: to.view ) {
                constraints.append(Constraint(view: common, layoutConstraint: layoutConstraint))
            } else {
                fatalError("No common superview found between \(from.view) and \(to.view)")
            }
        } else {
            constraints.append(Constraint(view: from.view, layoutConstraint: layoutConstraint))
        }
        return layoutConstraint
    }
    #else
    internal func addConstraint(_ from: Property, to: Property? = nil, coefficients: Coefficients = Coefficients(), relation: LayoutRelation = .equal) -> NSLayoutConstraint {
    from.view.car_translatesAutoresizingMaskIntoConstraints = false
    let item: LayoutItem = from.view
    let toItem: LayoutItem? = to?.view
    let layoutConstraint = NSLayoutConstraint(item: item,
    attribute: from.attribute,
    relatedBy: relation,
    toItem: toItem,
    attribute: to?.attribute ?? .notAnAttribute,
    multiplier: CGFloat(coefficients.multiplier),
    constant: CGFloat(coefficients.constant))
    if let to = to {
    if let common = closestCommonAncestor(from.view, b: to.view ) {
    constraints.append(Constraint(view: common, layoutConstraint: layoutConstraint))
    } else {
    fatalError("No common superview found between \(from.view) and \(to.view)")
    }
    } else {
    constraints.append(Constraint(view: from.view, layoutConstraint: layoutConstraint))
    }
    return layoutConstraint
    }
    #endif
    internal func addConstraint(_ from: Compound, coefficients: [Coefficients]? = nil, to: Compound? = nil, relation: LayoutRelation = .equal) -> [NSLayoutConstraint] {
        var results: [NSLayoutConstraint] = []
        for i in 0..<from.properties.count {
            let n: Coefficients = coefficients?[i] ?? Coefficients()
            results.append(addConstraint(from.properties[i], to: to?.properties[i], coefficients: n, relation: relation))
        }
        return results
    }
}
//
//  ConstraintGroup.swift
//  Cartography
//
//  Created by Robert Böhnke on 22/01/15.
//  Copyright (c) 2015 Robert Böhnke. All rights reserved.
//
import Foundation
public class ConstraintGroup {
    private var constraints: [Constraint] = []
    @available(OSX, introduced: 10.10)
    @available(iOS, introduced: 8.0)
    public var active: Bool {
        get {
            return constraints
                .map { $0.layoutConstraint.isActive }
                .reduce(true) { $0 && $1 }
        }
        set {
            for constraint in constraints {
                constraint.layoutConstraint.isActive = newValue
            }
        }
    }
    public init() {
    }
    internal func replaceConstraints(_ constraints: [Constraint]) {
        for constraint in self.constraints {
            constraint.uninstall()
        }
        self.constraints = constraints
        for constraint in self.constraints {
            constraint.install()
        }
    }
}
//
//  Constraint.swift
//  Cartography
//
//  Created by Robert Böhnke on 06/10/14.
//  Copyright (c) 2014 Robert Böhnke. All rights reserved.
//

internal class Constraint {
    // Set to weak to avoid a retain cycle on the associated view.
    weak var view: View?
    let layoutConstraint: NSLayoutConstraint
    func install() {
        view?.addConstraint(layoutConstraint)
    }
    func uninstall() {
        view?.removeConstraint(layoutConstraint)
    }
    init(view: View, layoutConstraint: NSLayoutConstraint) {
        self.view = view
        self.layoutConstraint = layoutConstraint
    }
}
//
//  Constrain.swift
//  Cartography
//
//  Created by Robert Böhnke on 30/09/14.
//  Copyright (c) 2014 Robert Böhnke. All rights reserved.
//
import Foundation
/// Updates the constraints of a single view.
///
/// - parameter view:    The view to layout.
/// - parameter replace: The `ConstraintGroup` whose constraints should be
///                      replaced.
/// - parameter block:   A block that declares the layout for `view`.
///
@discardableResult public func constrain(_ view: View, replace group: ConstraintGroup? = nil, block: (LayoutProxy) -> ()) -> ConstraintGroup {
    let constraintGroup = group ?? ConstraintGroup()
    let context = Context()
    block(LayoutProxy(context, view))
    constraintGroup.replaceConstraints(context.constraints)
    return constraintGroup
}
/// Updates the constraints of two views.
///
/// - parameter view1:   A view to layout.
/// - parameter view2:   A view to layout.
/// - parameter replace: The `ConstraintGroup` whose constraints should be
///                      replaced.
/// - parameter block:   A block that declares the layout for the views.
///
@discardableResult public func constrain(_ view1: View, _ view2: View, replace group: ConstraintGroup? = nil, block: (LayoutProxy, LayoutProxy) -> ()) -> ConstraintGroup {
    let constraintGroup = group ?? ConstraintGroup()
    let context = Context()
    block(LayoutProxy(context, view1), LayoutProxy(context, view2))
    constraintGroup.replaceConstraints(context.constraints)
    return constraintGroup
}
/// Updates the constraints of three views.
///
/// - parameter view1:   A view to layout.
/// - parameter view2:   A view to layout.
/// - parameter view3:   A view to layout.
/// - parameter replace: The `ConstraintGroup` whose constraints should be
///                      replaced.
/// - parameter block:   A block that declares the layout for the views.
///
@discardableResult public func constrain(_ view1: View, _ view2: View, _ view3: View, replace group: ConstraintGroup? = nil, block: (LayoutProxy, LayoutProxy, LayoutProxy) -> ()) -> ConstraintGroup {
    let constraintGroup = group ?? ConstraintGroup()
    let context = Context()
    block(LayoutProxy(context, view1), LayoutProxy(context, view2), LayoutProxy(context, view3))
    constraintGroup.replaceConstraints(context.constraints)
    return constraintGroup
}
/// Updates the constraints of four views.
///
/// - parameter view1:   A view to layout.
/// - parameter view2:   A view to layout.
/// - parameter view3:   A view to layout.
/// - parameter view4:   A view to layout.
/// - parameter replace: The `ConstraintGroup` whose constraints should be
///                      replaced.
/// - parameter block:   A block that declares the layout for the views.
///
@discardableResult public func constrain(_ view1: View, _ view2: View, _ view3: View, _ view4: View, replace group: ConstraintGroup? = nil, block: (LayoutProxy, LayoutProxy, LayoutProxy, LayoutProxy) -> ()) -> ConstraintGroup {
    let constraintGroup = group ?? ConstraintGroup()
    let context = Context()
    block(LayoutProxy(context, view1), LayoutProxy(context, view2), LayoutProxy(context, view3), LayoutProxy(context, view4))
    constraintGroup.replaceConstraints(context.constraints)
    return constraintGroup
}
/// Updates the constraints of five views.
///
/// - parameter view1:   A view to layout.
/// - parameter view2:   A view to layout.
/// - parameter view3:   A view to layout.
/// - parameter view4:   A view to layout.
/// - parameter view5:   A view to layout.
/// - parameter replace: The `ConstraintGroup` whose constraints should be
///                      replaced.
/// - parameter block:   A block that declares the layout for the views.
///
@discardableResult public func constrain(_ view1: View, _ view2: View, _ view3: View, _ view4: View, _ view5: View, replace group: ConstraintGroup? = nil, block: (LayoutProxy, LayoutProxy, LayoutProxy, LayoutProxy, LayoutProxy) -> ()) -> ConstraintGroup {
    let constraintGroup = group ?? ConstraintGroup()
    let context = Context()
    block(LayoutProxy(context, view1), LayoutProxy(context, view2), LayoutProxy(context, view3), LayoutProxy(context, view4), LayoutProxy(context, view5))
    constraintGroup.replaceConstraints(context.constraints)
    return constraintGroup
}
/// Updates the constraints of an array of views.
///
/// - parameter views:   The views to layout.
/// - parameter replace: The `ConstraintGroup` whose constraints should be
///                      replaced.
/// - parameter block:   A block that declares the layout for `views`.
///
@discardableResult public func constrain(_ views: [View], replace group: ConstraintGroup? = nil, block: ([LayoutProxy]) -> ()) -> ConstraintGroup {
    let constraintGroup = group ?? ConstraintGroup()
    let context = Context()
    block(views.map({ LayoutProxy(context, $0) }))
    constraintGroup.replaceConstraints(context.constraints)
    return constraintGroup
}
/// Updates the constraints of a dictionary of views.
///
/// - parameter views:   The views to layout.
/// - parameter replace: The `ConstraintGroup` whose constraints should be
///                      replaced.
/// - parameter block:   A block that declares the layout for `views`.
///
@discardableResult public func constrain<T>(_ views: [T: View], replace group: ConstraintGroup? = nil, block: (([T : LayoutProxy]) -> ())) -> ConstraintGroup {
    let constraintGroup = group ?? ConstraintGroup()
    let context = Context()
    let proxies = views.map { ($0, LayoutProxy(context, $1)) }
    var dict = [T:LayoutProxy]()
    proxies.forEach {
        dict[$0.0] = $0.1
    }
    block(dict)
    constraintGroup.replaceConstraints(context.constraints)
    return constraintGroup
}
/// Removes all constraints for a group.
///
/// - parameter clear: The `ConstraintGroup` whose constraints should be removed.
///
public func constrain(clear group: ConstraintGroup) {
    group.replaceConstraints([])
}
//
//  Compound.swift
//  Cartography
//
//  Created by Robert Böhnke on 18/06/14.
//  Copyright (c) 2014 Robert Böhnke. All rights reserved.
//

public protocol Compound {
    var context: Context { get }
    var properties: [Property] { get }
}
/// Compound properties conforming to this protocol can use the `==` operator
/// with other compound properties of the same type.
public protocol RelativeCompoundEquality : Compound { }
/// Declares a property equal to a the result of an expression.
///
/// - parameter lhs: The affected property. The associated view will have
///             `translatesAutoresizingMaskIntoConstraints` set to `false`.
/// - parameter rhs: The expression.
///
/// - returns: An `NSLayoutConstraint`.
///
@discardableResult public func == <P: RelativeCompoundEquality>(lhs: P, rhs: Expression<P>) -> [NSLayoutConstraint] {
    return lhs.context.addConstraint(lhs, coefficients: rhs.coefficients, to: rhs.value)
}
/// Declares a property equal to another compound property.
///
/// - parameter lhs: The affected property. The associated view will have
///             `translatesAutoresizingMaskIntoConstraints` set to `false`.
/// - parameter rhs: The other property.
///
@discardableResult public func == <P: RelativeCompoundEquality>(lhs: P, rhs: P) -> [NSLayoutConstraint] {
    return lhs.context.addConstraint(lhs, to: rhs)
}
/// Compound properties conforming to this protocol can use the `<=` and `>=`
/// operators with other compound properties of the same type.
public protocol RelativeCompoundInequality : Compound { }
/// Declares a property less than or equal to another compound property.
///
/// - parameter lhs: The affected property. The associated view will have
///             `translatesAutoresizingMaskIntoConstraints` set to `false`.
/// - parameter rhs: The other property.
///
/// - returns: An `NSLayoutConstraint`.
///
@discardableResult public func <= <P: RelativeCompoundInequality>(lhs: P, rhs: P) -> [NSLayoutConstraint] {
    return lhs.context.addConstraint(lhs, to: rhs, relation: .lessThanOrEqual)
}
/// Declares a property greater than or equal to another compound property.
///
/// - parameter lhs: The affected property. The associated view will have
///             `translatesAutoresizingMaskIntoConstraints` set to `false`.
/// - parameter rhs: The other property.
///
/// - returns: An `NSLayoutConstraint`.
///
@discardableResult public func >= <P: RelativeCompoundInequality>(lhs: P, rhs: P) -> [NSLayoutConstraint] {
    return lhs.context.addConstraint(lhs, to: rhs, relation: .greaterThanOrEqual)
}
/// Declares a property less than or equal to the result of an expression.
///
/// - parameter lhs: The affected property. The associated view will have
///             `translatesAutoresizingMaskIntoConstraints` set to `false`.
/// - parameter rhs: The other property.
///
/// - returns: An `NSLayoutConstraint`.
///
@discardableResult public func <= <P: RelativeCompoundInequality>(lhs: P, rhs: Expression<P>) -> [NSLayoutConstraint] {
    return lhs.context.addConstraint(lhs, coefficients: rhs.coefficients, to: rhs.value, relation: .lessThanOrEqual)
}
/// Declares a property greater than or equal to the result of an expression.
///
/// - parameter lhs: The affected property. The associated view will have
///             `translatesAutoresizingMaskIntoConstraints` set to `false`.
/// - parameter rhs: The other property.
///
/// - returns: An `NSLayoutConstraint`.
///
@discardableResult public func >= <P: RelativeCompoundInequality>(lhs: P, rhs: Expression<P>) -> [NSLayoutConstraint] {
    return lhs.context.addConstraint(lhs, coefficients: rhs.coefficients, to: rhs.value, relation: .greaterThanOrEqual)
}
#if os(iOS) || os(tvOS)
    /// Declares a property equal to a layout support.
    ///
    /// - parameter lhs: The affected property. The associated view will have
    ///             `translatesAutoresizingMaskIntoConstraints` set to `false`.
    /// - parameter rhs: The layout support.
    ///
    /// - returns: An `NSLayoutConstraint`.
    ///
    @discardableResult public func == <P: RelativeEquality>(lhs: P, rhs: LayoutSupport) -> NSLayoutConstraint {
        return lhs.context.addConstraint(lhs, to: rhs)
    }
    /// Declares a property equal to the result of a layout support expression.
    ///
    /// - parameter lhs: The affected property. The associated view will have
    ///             `translatesAutoresizingMaskIntoConstraints` set to `false`.
    /// - parameter rhs: The layout support expression.
    ///
    /// - returns: An `NSLayoutConstraint`.
    ///
    @discardableResult public func == <P: RelativeEquality>(lhs: P, rhs: Expression<LayoutSupport>) -> NSLayoutConstraint {
        return lhs.context.addConstraint(lhs, to: rhs.value, coefficients: rhs.coefficients[0])
    }
    /// Declares a property greater than or equal to a layout support.
    ///
    /// - parameter lhs: The affected property. The associated view will have
    ///             `translatesAutoresizingMaskIntoConstraints` set to `false`.
    /// - parameter rhs: The layout support.
    ///
    /// - returns: An `NSLayoutConstraint`.
    ///
    @discardableResult public func >= <P: RelativeEquality>(lhs: P, rhs: LayoutSupport) -> NSLayoutConstraint {
        return lhs.context.addConstraint(lhs, to: rhs, relation: NSLayoutRelation.greaterThanOrEqual)
    }
    /// Declares a property less than or equal to a layout support.
    ///
    /// - parameter lhs: The affected property. The associated view will have
    ///             `translatesAutoresizingMaskIntoConstraints` set to `false`.
    /// - parameter rhs: The layout support.
    ///
    /// - returns: An `NSLayoutConstraint`.
    ///
    @discardableResult public func <= <P: RelativeEquality>(lhs: P, rhs: LayoutSupport) -> NSLayoutConstraint {
        return lhs.context.addConstraint(lhs, to: rhs, relation: NSLayoutRelation.lessThanOrEqual)
    }
    /// Declares a property greater than or equal to the result of a layout support expression.
    ///
    /// - parameter lhs: The affected property. The associated view will have
    ///             `translatesAutoresizingMaskIntoConstraints` set to `false`.
    /// - parameter rhs: The layout support.
    ///
    /// - returns: An `NSLayoutConstraint`.
    ///
    @discardableResult public func >= <P: RelativeEquality>(lhs: P, rhs: Expression<LayoutSupport>) -> NSLayoutConstraint {
        return lhs.context.addConstraint(lhs, to: rhs.value, coefficients: rhs.coefficients[0], relation: NSLayoutRelation.greaterThanOrEqual)
    }
    /// Declares a property less than or equal to the result of a layout support expression.
    ///
    /// - parameter lhs: The affected property. The associated view will have
    ///             `translatesAutoresizingMaskIntoConstraints` set to `false`.
    /// - parameter rhs: The layout support.
    ///
    /// - returns: An `NSLayoutConstraint`.
    ///
    @discardableResult public func <= <P: RelativeEquality>(lhs: P, rhs: Expression<LayoutSupport>) -> NSLayoutConstraint {
        return lhs.context.addConstraint(lhs, to: rhs.value, coefficients: rhs.coefficients[0], relation: NSLayoutRelation.lessThanOrEqual)
    }
#endif
//
//  Coefficients.swift
//  Cartography
//
//  Created by Robert Böhnke on 17/06/14.
//  Copyright (c) 2014 Robert Böhnke. All rights reserved.
//
public struct Coefficients {
    var multiplier: CGFloat = 1
    var constant: CGFloat = 0
    init() { }
    init(_ multiplier: CGFloat, _ constant: CGFloat) {
        self.constant = constant
        self.multiplier = multiplier
    }
}
// MARK: Addition
public func + (c: CGFloat, rhs: Coefficients) -> Coefficients {
    return Coefficients(rhs.multiplier, rhs.constant + c)
}
public func + (lhs: Coefficients, rhs: CGFloat) -> Coefficients {
    return rhs + lhs
}
// MARK: Subtraction
public func - (c: CGFloat, rhs: Coefficients) -> Coefficients {
    return Coefficients(rhs.multiplier, rhs.constant - c)
}
public func - (lhs: Coefficients, rhs: CGFloat) -> Coefficients {
    return rhs - lhs
}
// MARK: Multiplication
public func * (m: CGFloat, rhs: Coefficients) -> Coefficients {
    return Coefficients(rhs.multiplier * m, rhs.constant * m)
}
public func * (lhs: Coefficients, rhs: CGFloat) -> Coefficients {
    return rhs * lhs
}
// MARK: Division
public func / (m: CGFloat, rhs: Coefficients) -> Coefficients {
    return Coefficients(rhs.multiplier / m, rhs.constant / m)
}
public func / (lhs: Coefficients, rhs: CGFloat) -> Coefficients {
    return rhs / lhs
}
internal func closestCommonAncestor(_ a: View, b: View) -> View? {
    let (aSuper, bSuper) = (a.superview, b.superview)
    if a === b { return a }
    if a === bSuper { return a }
    if b === aSuper { return b }
    if aSuper === bSuper { return aSuper }
    let ancestorsOfA = Set(ancestors(a))
    for ancestor in ancestors(b) {
        if ancestorsOfA.contains(ancestor) {
            return ancestor
        }
    }
    return .none
}
private func ancestors(_ v: View) -> AnySequence<View> {
    return AnySequence { () -> AnyIterator<View> in
        var view: View? = v
        return AnyIterator {
            let current = view
            view = view?.superview
            return current
        }
    }
}
public typealias View = UIView
extension View {
    public var car_translatesAutoresizingMaskIntoConstraints: Bool {
        get { return translatesAutoresizingMaskIntoConstraints }
        set { translatesAutoresizingMaskIntoConstraints = newValue }
    }
}

public struct Size : Compound, RelativeCompoundEquality, RelativeCompoundInequality {
    public let context: Context
    public let properties: [Property]
    internal init(_ context: Context, _ properties: [Property]) {
        self.context = context
        self.properties = properties
    }
}
// MARK: Multiplication
public func * (m: CGFloat, rhs: Expression<Size>) -> Expression<Size> {
    return Expression(rhs.value, rhs.coefficients.map { $0 * m })
}
public func * (lhs: Expression<Size>, rhs: CGFloat) -> Expression<Size> {
    return rhs * lhs
}
public func * (m: CGFloat, rhs: Size) -> Expression<Size> {
    return Expression(rhs, [ Coefficients(m, 0), Coefficients(m, 0) ])
}
public func * (lhs: Size, rhs: CGFloat) -> Expression<Size> {
    return rhs * lhs
}
// MARK: Division
public func / (lhs: Expression<Size>, rhs: CGFloat) -> Expression<Size> {
    return lhs * (1 / rhs)
}
public func / (lhs: Size, rhs: CGFloat) -> Expression<Size> {
    return lhs * (1 / rhs)
}
//
//  Property.swift
//  Cartography
//
//  Created by Robert Böhnke on 17/06/14.
//  Copyright (c) 2014 Robert Böhnke. All rights reserved.
//
import UIKit
public typealias LayoutAttribute = NSLayoutAttribute
public protocol Property {
    var attribute: LayoutAttribute { get }
    var context: Context { get }
    var view: View { get }
    var needsSafeArea: Bool { get }
}
// MARK: Equality
/// Properties conforming to this protocol can use the `==` operator with
/// numerical constants.
public protocol NumericalEquality : Property { }
/// Declares a property equal to a numerical constant.
///
/// - parameter lhs: The affected property. The associated view will have
///             `translatesAutoresizingMaskIntoConstraints` set to `false`.
/// - parameter rhs: The numerical constant.
///
/// - returns: An `NSLayoutConstraint`.
///
@discardableResult public func == (lhs: NumericalEquality, rhs: CGFloat) -> NSLayoutConstraint {
    return lhs.context.addConstraint(lhs, coefficients: Coefficients(1, rhs))
}
/// Properties conforming to this protocol can use the `==` operator with other
/// properties of the same type.
public protocol RelativeEquality : Property { }
/// Declares a property equal to a the result of an expression.
///
/// - parameter lhs: The affected property. The associated view will have
///             `translatesAutoresizingMaskIntoConstraints` set to `false`.
/// - parameter rhs: The expression.
///
/// - returns: An `NSLayoutConstraint`.
///
@discardableResult public func == <P: RelativeEquality>(lhs: P, rhs: Expression<P>) -> NSLayoutConstraint {
    return lhs.context.addConstraint(lhs, to: rhs.value, coefficients: rhs.coefficients[0])
}
/// Declares a property equal to another property.
///
/// - parameter lhs: The affected property. The associated view will have
///             `translatesAutoresizingMaskIntoConstraints` set to `false`.
/// - parameter rhs: The other property.
///
@discardableResult public func == <P: RelativeEquality>(lhs: P, rhs: P) -> NSLayoutConstraint {
    return lhs.context.addConstraint(lhs, to: rhs)
}
// MARK: Inequality
/// Properties conforming to this protocol can use the `<=` and `>=` operators
/// with numerical constants.
public protocol NumericalInequality : Property { }
/// Declares a property less than or equal to a numerical constant.
///
/// - parameter lhs: The affected property. The associated view will have
///             `translatesAutoresizingMaskIntoConstraints` set to `false`.
/// - parameter rhs: The numerical constant.
///
/// - returns: An `NSLayoutConstraint`.
///
@discardableResult public func <= (lhs: NumericalInequality, rhs: CGFloat) -> NSLayoutConstraint {
    return lhs.context.addConstraint(lhs, coefficients: Coefficients(1, rhs), relation: .lessThanOrEqual)
}
/// Declares a property greater than or equal to a numerical constant.
///
/// - parameter lhs: The affected property. The associated view will have
///             `translatesAutoresizingMaskIntoConstraints` set to `false`.
/// - parameter rhs: The numerical constant.
///
/// - returns: An `NSLayoutConstraint`.
///
@discardableResult public func >= (lhs: NumericalInequality, rhs: CGFloat) -> NSLayoutConstraint {
    return lhs.context.addConstraint(lhs, coefficients: Coefficients(1, rhs), relation: .greaterThanOrEqual)
}
/// Properties conforming to this protocol can use the `<=` and `>=` operators
/// with other properties of the same type.
public protocol RelativeInequality : Property { }
/// Declares a property less than or equal to another property.
///
/// - parameter lhs: The affected property. The associated view will have
///             `translatesAutoresizingMaskIntoConstraints` set to `false`.
/// - parameter rhs: The other property.
///
/// - returns: An `NSLayoutConstraint`.
///
@discardableResult public func <= <P: RelativeInequality>(lhs: P, rhs: P) -> NSLayoutConstraint {
    return lhs.context.addConstraint(lhs, to: rhs, relation: .lessThanOrEqual)
}
/// Declares a property greater than or equal to another property.
///
/// - parameter lhs: The affected property. The associated view will have
///             `translatesAutoresizingMaskIntoConstraints` set to `false`.
/// - parameter rhs: The other property.
///
/// - returns: An `NSLayoutConstraint`.
///
@discardableResult public func >= <P: RelativeInequality>(lhs: P, rhs: P) -> NSLayoutConstraint {
    return lhs.context.addConstraint(lhs, to: rhs, relation: .greaterThanOrEqual)
}
/// Declares a property less than or equal to the result of an expression.
///
/// - parameter lhs: The affected property. The associated view will have
///             `translatesAutoresizingMaskIntoConstraints` set to `false`.
/// - parameter rhs: The other property.
///
/// - returns: An `NSLayoutConstraint`.
///
@discardableResult public func <= <P: RelativeInequality>(lhs: P, rhs: Expression<P>) -> NSLayoutConstraint {
    return lhs.context.addConstraint(lhs, to: rhs.value, coefficients: rhs.coefficients[0], relation: .lessThanOrEqual)
}
/// Declares a property greater than or equal to the result of an expression.
///
/// - parameter lhs: The affected property. The associated view will have
///             `translatesAutoresizingMaskIntoConstraints` set to `false`.
/// - parameter rhs: The other property.
///
/// - returns: An `NSLayoutConstraint`.
///
@discardableResult public func >= <P: RelativeInequality>(lhs: P, rhs: Expression<P>) -> NSLayoutConstraint {
    return lhs.context.addConstraint(lhs, to: rhs.value, coefficients: rhs.coefficients[0], relation: .greaterThanOrEqual)
}
// MARK: Addition
public protocol Addition : Property { }
public func + <P: Addition>(c: CGFloat, rhs: P) -> Expression<P> {
    return Expression(rhs, [ Coefficients(1, c) ])
}
public func + <P: Addition>(lhs: P, rhs: CGFloat) -> Expression<P> {
    return rhs + lhs
}
public func + <P: Addition>(c: CGFloat, rhs: Expression<P>) -> Expression<P> {
    return Expression(rhs.value, rhs.coefficients.map { $0 + c })
}
public func + <P: Addition>(lhs: Expression<P>, rhs: CGFloat) -> Expression<P> {
    return rhs + lhs
}
public func - <P: Addition>(c: CGFloat, rhs: P) -> Expression<P> {
    return Expression(rhs, [ Coefficients(1, -c) ])
}
public func - <P: Addition>(lhs: P, rhs: CGFloat) -> Expression<P> {
    return rhs - lhs
}
public func - <P: Addition>(c: CGFloat, rhs: Expression<P>) -> Expression<P> {
    return Expression(rhs.value, rhs.coefficients.map { $0 - c})
}
public func - <P: Addition>(lhs: Expression<P>, rhs: CGFloat) -> Expression<P> {
    return rhs - lhs
}
#if os(iOS) || os(tvOS)
    public func + (lhs: LayoutSupport, c : CGFloat) -> Expression<LayoutSupport> {
        return Expression<LayoutSupport>(lhs, [Coefficients(1, c)])
    }
    public func - (lhs: LayoutSupport, c : CGFloat) -> Expression<LayoutSupport> {
        return lhs + (-c)
    }
#endif
// MARK: Multiplication
public protocol Multiplication : Property { }
public func * <P: Multiplication>(m: CGFloat, rhs: Expression<P>) -> Expression<P> {
    return Expression(rhs.value, rhs.coefficients.map { $0 * m })
}
public func * <P: Multiplication>(lhs: Expression<P>, rhs: CGFloat) -> Expression<P> {
    return rhs * lhs
}
public func * <P: Multiplication>(m: CGFloat, rhs: P) -> Expression<P> {
    return Expression(rhs, [ Coefficients(m, 0) ])
}
public func * <P: Multiplication>(lhs: P, rhs: CGFloat) -> Expression<P> {
    return rhs * lhs
}
public func / <P: Multiplication>(lhs: Expression<P>, rhs: CGFloat) -> Expression<P> {
    return lhs * (1 / rhs)
}
public func / <P: Multiplication>(lhs: P, rhs: CGFloat) -> Expression<P> {
    return lhs * (1 / rhs)
}
public typealias LayoutPriority = UILayoutPriority
precedencegroup CarthographyPriorityPrecedence {
    lowerThan: ComparisonPrecedence
    higherThan: AssignmentPrecedence
}
infix operator  ~: CarthographyPriorityPrecedence
@discardableResult public func ~ (lhs: NSLayoutConstraint, rhs: LayoutPriority) -> NSLayoutConstraint {
    lhs.priority = rhs
    return lhs
}
/// Sets the priority for multiple constraints.
///
/// - parameter lhs: An array of `NSLayoutConstraint` instances.
/// - parameter rhs: The new priority.
///
/// - returns: The same constraints with their priorities updated.
///
@discardableResult public func ~ (lhs: [NSLayoutConstraint], rhs: LayoutPriority) -> [NSLayoutConstraint] {
    return lhs.map {
        $0 ~ rhs
    }
}
public struct Point: Compound, RelativeCompoundEquality, RelativeCompoundInequality {
    public let context: Context
    public let properties: [Property]
    internal init(_ context: Context, _ properties: [Property]) {
        self.context = context
        self.properties = properties
    }
}
public struct LayoutSupport {
    let layoutGuide : UILayoutSupport
    let attribute : NSLayoutAttribute
}
