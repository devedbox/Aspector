//
//  Aspect.UIKit.swift
//  Aspect
//
//  Created by devedbox on 2018/8/23.
//

import UIKit

// MARK: - UIViewController.

extension Aspect where T: UIViewController {
    public typealias Action = () -> Void
    
    public func loadView() { dispatch { obj.loadView() } }
    
    @available(iOS 9.0, *)
    public func loadViewIfNeeded() { dispatch { obj.loadViewIfNeeded() } }
    
    public func viewDidLoad() { dispatch { obj.viewDidLoad() } }
    
    @available(iOS 5.0, *)
    public func performSegue(
        withIdentifier identifier: String,
        sender: Any?)
    {
        dispatch {
            obj.performSegue(withIdentifier: identifier, sender: sender)
        }
    }
    
    @available(iOS 6.0, *)
    public func shouldPerformSegue(
        withIdentifier identifier: String,
        sender: Any?) -> Bool
    {
        return dispatch {
            obj.shouldPerformSegue(withIdentifier: identifier, sender: sender)
        }
    }
    
    @available(iOS 5.0, *)
    public func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?)
    {
        dispatch {
            obj.prepare(for: segue, sender: sender)
        }
    }
    
    @available(iOS 6.0, *)
    public func canPerformUnwindSegueAction(
        _ action: Selector,
        from fromViewController: UIViewController,
        withSender sender: Any) -> Bool
    {
        return dispatch {
            obj.canPerformUnwindSegueAction(action, from: fromViewController, withSender: sender)
        }
    }
    
    @available(iOS 9.0, *)
    public func allowedChildrenForUnwinding(
        from source: UIStoryboardUnwindSegueSource)
        -> [UIViewController]
    {
        return dispatch {
            obj.allowedChildrenForUnwinding(from: source)
        }
    }
    
    @available(iOS 9.0, *)
    public func childContaining(
        _ source: UIStoryboardUnwindSegueSource) -> UIViewController?
    {
        return dispatch {
            obj.childContaining(source)
        }
    }
    
    @available(iOS, introduced: 6.0, deprecated: 9.0)
    public func forUnwindSegueAction(
        _ action: Selector,
        from fromViewController: UIViewController,
        withSender sender: Any?) -> UIViewController?
    {
        return dispatch {
            obj.forUnwindSegueAction(action, from: fromViewController, withSender: sender)
        }
    }
    
    @available(iOS 9.0, *)
    public func unwind(
        for unwindSegue: UIStoryboardSegue,
        towards subsequentVC: UIViewController)
    {
        dispatch {
            obj.unwind(for: unwindSegue, towards: subsequentVC)
        }
    }
    
    @available(iOS, introduced: 6.0, deprecated: 9.0)
    public func segueForUnwinding(
        to toViewController: UIViewController,
        from fromViewController: UIViewController,
        identifier: String?) -> UIStoryboardSegue?
    {
        return dispatch {
            obj.segueForUnwinding(to: toViewController, from: fromViewController, identifier: identifier)
        }
    }
    
    public func viewWillAppear(_ animated: Bool) { dispatch { obj.viewWillAppear(animated) } }
    
    public func viewDidAppear(_ animated: Bool) { dispatch { obj.viewDidAppear(animated) } }
    
    public func viewWillDisappear(_ animated: Bool) { dispatch { obj.viewWillDisappear(animated) } }
    
    public func viewDidDisappear(_ animated: Bool) { dispatch { obj.viewDidDisappear(animated) } }
    
    @available(iOS 5.0, *)
    public func viewWillLayoutSubviews() { dispatch { obj.viewWillLayoutSubviews() } }
    
    @available(iOS 5.0, *)
    public func viewDidLayoutSubviews() { dispatch { obj.viewDidLayoutSubviews() } }
    public func didReceiveMemoryWarning() { dispatch { obj.didReceiveMemoryWarning() } }
    
    public var parent: UIViewController? { return dispatch { obj.parent } }
    
    @available(iOS 5.0, *)
    public var presentedViewController: UIViewController? { return dispatch { obj.presentedViewController } }
    
    @available(iOS 5.0, *)
    public var presentingViewController: UIViewController? { return dispatch { obj.presentingViewController } }
    
    @available(iOS 5.0, *)
    public func present(
        _ viewControllerToPresent: UIViewController,
        animated flag: Bool,
        completion: (() -> Void)? = nil)
    {
        dispatch {
            obj.present(viewControllerToPresent,
                        animated: flag,
                        completion: completion)
        }
    }
    
    @available(iOS 5.0, *)
    public func dismiss(
        animated flag: Bool,
        completion: (() -> Void)? = nil)
    {
        dispatch {
            obj.dismiss(animated: flag,
                        completion: completion)
        }
    }
    
    @available(iOS 7.0, *)
    public func setNeedsStatusBarAppearanceUpdate() { dispatch { obj.setNeedsStatusBarAppearanceUpdate() } }
    
    @available(iOS 8.0, *)
    public func targetViewController(
        forAction action: Selector,
        sender: Any?) -> UIViewController?
    {
        return dispatch {
            obj.targetViewController(forAction: action,
                                     sender: sender)
        }
    }
    
    @available(iOS 8.0, *)
    public func show(
        _ vc: UIViewController,
        sender: Any?)
    {
        dispatch { obj.show(vc, sender: sender) }
    }
    
    @available(iOS 8.0, *)
    public func showDetailViewController(
        _ vc: UIViewController,
        sender: Any?)
    {
        dispatch { obj.showDetailViewController(vc, sender: sender) }
    }
    
    @available(iOS 5.0, *)
    public static func attemptRotationToDeviceOrientation(_ action: Action) {
        #warning ("attemptRotationToDeviceOrientation")
    }
    
    @available(iOS, introduced: 2.0, deprecated: 8.0, message: "Header views are animated along with the rest of the view hierarchy")
    public func rotatingHeaderView() -> UIView? { return dispatch { obj.rotatingHeaderView() } }
    
    @available(iOS, introduced: 2.0, deprecated: 8.0, message: "Footer views are animated along with the rest of the view hierarchy")
    public func rotatingFooterView() -> UIView? { return dispatch { obj.rotatingFooterView() } }
    
    @available(iOS, introduced: 2.0, deprecated: 8.0, message: "Implement viewWillTransitionToSize:withTransitionCoordinator: instead")
    public func willRotate(
        to toInterfaceOrientation: UIInterfaceOrientation,
        duration: TimeInterval)
    {
        dispatch {
            obj.willRotate(to: toInterfaceOrientation,
                           duration: duration)
        }
    }
    
    @available(iOS, introduced: 2.0, deprecated: 8.0)
    public func didRotate(
        from fromInterfaceOrientation: UIInterfaceOrientation)
    {
        dispatch {
            obj.didRotate(from: fromInterfaceOrientation)
        }
    }
    
    @available(iOS, introduced: 3.0, deprecated: 8.0, message: "Implement viewWillTransitionToSize:withTransitionCoordinator: instead")
    public func willAnimateRotation(
        to toInterfaceOrientation: UIInterfaceOrientation,
        duration: TimeInterval)
    {
        dispatch {
            obj.willAnimateRotation(to: toInterfaceOrientation,
                                    duration: duration)
        }
    }
    
    public func setEditing(
        _ editing: Bool,
        animated: Bool)
    {
        dispatch {
            obj.setEditing(editing,
                           animated: animated)
        }
    }
    
    @available(iOS 5.0, *)
    public func addChild(
        _ childController: UIViewController)
    {
        dispatch {
            obj.addChild(childController)
        }
    }
    
    @available(iOS 5.0, *)
    public func removeFromParent() { dispatch { obj.removeFromParent() } }
    
    @available(iOS 5.0, *)
    public func transition(
        from fromViewController: UIViewController,
        to toViewController: UIViewController,
        duration: TimeInterval,
        options: UIView.AnimationOptions = [],
        animations: (() -> Void)?,
        completion: ((Bool) -> Void)? = nil)
    {
        dispatch {
            obj.transition(from: fromViewController,
                           to: toViewController,
                           duration: duration,
                           options: options,
                           animations: animations,
                           completion: completion)
        }
    }
    
    @available(iOS 5.0, *)
    public func beginAppearanceTransition(
        _ isAppearing: Bool,
        animated: Bool)
    {
        dispatch {
            obj.beginAppearanceTransition(isAppearing,
                                          animated: animated)
        }
    }
    
    @available(iOS 5.0, *)
    public func endAppearanceTransition() { dispatch { obj.endAppearanceTransition() } }
    
    @available(iOS 8.0, *)
    public func setOverrideTraitCollection(
        _ collection: UITraitCollection?,
        forChild childViewController: UIViewController)
    {
        dispatch {
            obj.setOverrideTraitCollection(collection,
                                           forChild: childViewController)
        }
    }
    
    @available(iOS 8.0, *)
    public func overrideTraitCollection(
        forChild childViewController: UIViewController) -> UITraitCollection?
    {
        return dispatch {
            obj.overrideTraitCollection(forChild: childViewController)
        }
    }
    
    @available(iOS, introduced: 6.0, deprecated: 8.0, message: "Manually forward viewWillTransitionToSize:withTransitionCoordinator: if necessary")
    public func shouldAutomaticallyForwardRotationMethods() -> Bool {
        return dispatch {
            obj.shouldAutomaticallyForwardRotationMethods()
        }
    }
    
    @available(iOS 5.0, *)
    public func willMove(toParent parent: UIViewController?) {
        dispatch {
            obj.willMove(toParent: parent)
        }
    }
    
    @available(iOS 5.0, *)
    public func didMove(toParent parent: UIViewController?) {
        dispatch {
            obj.didMove(toParent: parent)
        }
    }
    
    @available(iOS 6.0, *)
    public func encodeRestorableState(with coder: NSCoder) {
        dispatch {
            obj.encodeRestorableState(with: coder)
        }
    }
    
    @available(iOS 6.0, *)
    public func decodeRestorableState(with coder: NSCoder) {
        dispatch {
            obj.decodeRestorableState(with: coder)
        }
    }
    
    @available(iOS 7.0, *)
    public func applicationFinishedRestoringState() { dispatch { obj.applicationFinishedRestoringState() } }
    
    @available(iOS 6.0, *)
    public func updateViewConstraints() { dispatch { obj.updateViewConstraints() } }
    
    @available(iOS 11.0, *)
    public func viewLayoutMarginsDidChange() { dispatch { obj.viewLayoutMarginsDidChange() } }
    
    @available(iOS 11.0, *)
    public func viewSafeAreaInsetsDidChange() { dispatch { obj.viewSafeAreaInsetsDidChange() } }
    
    @available(iOS 9.0, *)
    public func addKeyCommand(
        _ keyCommand: UIKeyCommand)
    {
        dispatch {
            obj.addKeyCommand(keyCommand)
        }
    }
    
    @available(iOS 9.0, *)
    public func removeKeyCommand(
        _ keyCommand: UIKeyCommand)
    {
        dispatch {
            obj.removeKeyCommand(keyCommand)
        }
    }
    
    @available(iOS 9.0, *)
    public func registerForPreviewing(
        with delegate: UIViewControllerPreviewingDelegate,
        sourceView: UIView) -> UIViewControllerPreviewing
    {
        return dispatch {
            obj.registerForPreviewing(with: delegate,
                                      sourceView: sourceView)
        }
    }
    
    @available(iOS 9.0, *)
    public func unregisterForPreviewing(
        withContext previewing: UIViewControllerPreviewing)
    {
        dispatch {
            obj.unregisterForPreviewing(withContext: previewing)
        }
    }
    
    @available(iOS 11.0, *)
    public func setNeedsUpdateOfScreenEdgesDeferringSystemGestures() {
        dispatch { obj.setNeedsUpdateOfScreenEdgesDeferringSystemGestures() }
    }
    
    @available(iOS 11.0, *)
    public func setNeedsUpdateOfHomeIndicatorAutoHidden() {
        dispatch { obj.setNeedsUpdateOfHomeIndicatorAutoHidden() }
    }
}
