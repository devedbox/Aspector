//
//  Aspect.UIKit.swift
//  Aspect
//
//  Created by devedbox on 2018/8/23.
//

#if os(iOS)

import UIKit

// MARK; - UIViewController.Type.

extension MetaAspect where T: UIViewController {
    @available(iOS 5.0, *)
    public func attemptRotationToDeviceOrientation(
        patcher: Patcher)
    {
        dispatch(self, patcher: patcher) {
            obj.attemptRotationToDeviceOrientation()
        }
    }
}

// MARK: - UIViewController.

extension Aspect where T: UIViewController {
    
    public func loadView(aspector: Patcher) {
        dispatch(self, patcher: aspector) { obj.loadView() }
    }
    
    @available(iOS 9.0, *)
    public func loadViewIfNeeded(aspector: Patcher) {
        dispatch(self, patcher: aspector) { obj.loadViewIfNeeded() }
    }
    
    public func viewDidLoad(aspector: Patcher) {
        dispatch(self, patcher: aspector) { obj.viewDidLoad() }
    }
    
    @available(iOS 5.0, *)
    public func performSegue(
        withIdentifier identifier: String,
        sender: Any?,
        aspector: Patcher)
    {
        dispatch(self, patcher: aspector) {
            obj.performSegue(withIdentifier: identifier, sender: sender)
        }
    }
    
    @available(iOS 6.0, *)
    public func shouldPerformSegue(
        withIdentifier identifier: String,
        sender: Any?,
        aspector: Patcher) -> Bool
    {
        return dispatch(self, patcher: aspector) {
            obj.shouldPerformSegue(withIdentifier: identifier, sender: sender)
        }
    }
    
    @available(iOS 5.0, *)
    public func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?,
        aspector: Patcher)
    {
        dispatch(self, patcher: aspector) {
            obj.prepare(for: segue, sender: sender)
        }
    }
    
    @available(iOS 6.0, *)
    public func canPerformUnwindSegueAction(
        _ action: Selector,
        from fromViewController: UIViewController,
        withSender sender: Any,
        aspector: Patcher) -> Bool
    {
        return dispatch(self, patcher: aspector) {
            obj.canPerformUnwindSegueAction(action, from: fromViewController, withSender: sender)
        }
    }
    
    @available(iOS 9.0, *)
    public func allowedChildrenForUnwinding(
        from source: UIStoryboardUnwindSegueSource,
        aspector: Patcher) -> [UIViewController]
    {
        return dispatch(self, patcher: aspector) {
            obj.allowedChildrenForUnwinding(from: source)
        }
    }
    
    @available(iOS 9.0, *)
    public func childContaining(
        _ source: UIStoryboardUnwindSegueSource,
        aspector: Patcher) -> UIViewController?
    {
        return dispatch(self, patcher: aspector) {
            obj.childContaining(source)
        }
    }
    
    @available(iOS, introduced: 6.0, deprecated: 9.0)
    public func forUnwindSegueAction(
        _ action: Selector,
        from fromViewController: UIViewController,
        withSender sender: Any?,
        aspector: Patcher) -> UIViewController?
    {
        return dispatch(self, patcher: aspector) {
            obj.forUnwindSegueAction(action, from: fromViewController, withSender: sender)
        }
    }
    
    @available(iOS 9.0, *)
    public func unwind(
        for unwindSegue: UIStoryboardSegue,
        towards subsequentVC: UIViewController,
        aspector: Patcher)
    {
        dispatch(self, patcher: aspector) {
            obj.unwind(for: unwindSegue, towards: subsequentVC)
        }
    }
    
    @available(iOS, introduced: 6.0, deprecated: 9.0)
    public func segueForUnwinding(
        to toViewController: UIViewController,
        from fromViewController: UIViewController,
        identifier: String?,
        aspector: Patcher) -> UIStoryboardSegue?
    {
        return dispatch(self, patcher: aspector) {
            obj.segueForUnwinding(to: toViewController, from: fromViewController, identifier: identifier)
        }
    }
    
    public func viewWillAppear(
        _ animated: Bool,
        aspector: Patcher)
    {
        dispatch(self, patcher: aspector) { obj.viewWillAppear(animated) }
    }
    
    public func viewDidAppear(
        _ animated: Bool,
        aspector: Patcher)
    {
        dispatch(self, patcher: aspector) { obj.viewDidAppear(animated) }
    }
    
    public func viewWillDisappear(
        _ animated: Bool,
        aspector: Patcher)
    {
        dispatch(self, patcher: aspector) { obj.viewWillDisappear(animated) }
    }
    
    public func viewDidDisappear(
        _ animated: Bool,
        aspector: Patcher)
    {
        dispatch(self, patcher: aspector) { obj.viewDidDisappear(animated) }
    }
    
    @available(iOS 5.0, *)
    public func viewWillLayoutSubviews(aspector: Patcher) {
        dispatch(self, patcher: aspector) { obj.viewWillLayoutSubviews() }
    }
    
    @available(iOS 5.0, *)
    public func viewDidLayoutSubviews(aspector: Patcher) {
        dispatch(self, patcher: aspector) { obj.viewDidLayoutSubviews() }
    }
    public func didReceiveMemoryWarning(aspector: Patcher) {
        dispatch(self, patcher: aspector) { obj.didReceiveMemoryWarning() }
    }
    
    public func parent(aspector: Patcher) -> UIViewController? {
        return dispatch(self, patcher: aspector) { obj.parent }
    }
    
    @available(iOS 5.0, *)
    public func presentedViewController(aspector: Patcher) -> UIViewController? {
        return dispatch(self, patcher: aspector) { obj.presentedViewController }
    }
    
    @available(iOS 5.0, *)
    public func presentingViewController(aspector: Patcher) -> UIViewController? {
        return dispatch(self, patcher: aspector) { obj.presentingViewController }
    }
    
    @available(iOS 5.0, *)
    public func present(
        _ viewControllerToPresent: UIViewController,
        animated flag: Bool,
        completion: (() -> Void)? = nil,
        aspector: Patcher)
    {
        dispatch(self, patcher: aspector) {
            obj.present(viewControllerToPresent,
                        animated: flag,
                        completion: completion)
        }
    }
    
    @available(iOS 5.0, *)
    public func dismiss(
        animated flag: Bool,
        completion: (() -> Void)? = nil,
        aspector: Patcher)
    {
        dispatch(self, patcher: aspector) {
            obj.dismiss(animated: flag,
                        completion: completion)
        }
    }
    
    @available(iOS 7.0, *)
    public func setNeedsStatusBarAppearanceUpdate(aspector: Patcher) {
        dispatch(self, patcher: aspector) { obj.setNeedsStatusBarAppearanceUpdate() }
    }
    
    @available(iOS 8.0, *)
    public func targetViewController(
        forAction action: Selector,
        sender: Any?,
        aspector: Patcher) -> UIViewController?
    {
        return dispatch(self, patcher: aspector) {
            obj.targetViewController(forAction: action,
                                     sender: sender)
        }
    }
    
    @available(iOS 8.0, *)
    public func show(
        _ vc: UIViewController,
        sender: Any?,
        aspector: Patcher)
    {
        dispatch(self, patcher: aspector) { obj.show(vc, sender: sender) }
    }
    
    @available(iOS 8.0, *)
    public func showDetailViewController(
        _ vc: UIViewController,
        sender: Any?,
        aspector: Patcher)
    {
        dispatch(self, patcher: aspector) { obj.showDetailViewController(vc, sender: sender) }
    }
    
    @available(iOS, introduced: 2.0, deprecated: 8.0, message: "Header views are animated along with the rest of the view hierarchy")
    public func rotatingHeaderView(aspector: Patcher) -> UIView? {
        return dispatch(self, patcher: aspector) { obj.rotatingHeaderView() }
    }
    
    @available(iOS, introduced: 2.0, deprecated: 8.0, message: "Footer views are animated along with the rest of the view hierarchy")
    public func rotatingFooterView(aspector: Patcher) -> UIView? {
        return dispatch(self, patcher: aspector) { obj.rotatingFooterView() }
    }
    
    @available(iOS, introduced: 2.0, deprecated: 8.0, message: "Implement viewWillTransitionToSize:withTransitionCoordinator: instead")
    public func willRotate(
        to toInterfaceOrientation: UIInterfaceOrientation,
        duration: TimeInterval,
        aspector: Patcher)
    {
        dispatch(self, patcher: aspector) {
            obj.willRotate(to: toInterfaceOrientation,
                           duration: duration)
        }
    }
    
    @available(iOS, introduced: 2.0, deprecated: 8.0)
    public func didRotate(
        from fromInterfaceOrientation: UIInterfaceOrientation,
        aspector: Patcher)
    {
        dispatch(self, patcher: aspector) {
            obj.didRotate(from: fromInterfaceOrientation)
        }
    }
    
    @available(iOS, introduced: 3.0, deprecated: 8.0, message: "Implement viewWillTransitionToSize:withTransitionCoordinator: instead")
    public func willAnimateRotation(
        to toInterfaceOrientation: UIInterfaceOrientation,
        duration: TimeInterval,
        aspector: Patcher)
    {
        dispatch(self, patcher: aspector) {
            obj.willAnimateRotation(to: toInterfaceOrientation,
                                    duration: duration)
        }
    }
    
    public func setEditing(
        _ editing: Bool,
        animated: Bool,
        aspector: Patcher)
    {
        dispatch(self, patcher: aspector) {
            obj.setEditing(editing,
                           animated: animated)
        }
    }
    
    @available(iOS 5.0, *)
    public func addChild(
        _ childController: UIViewController,
        aspector: Patcher)
    {
        dispatch(self, patcher: aspector) {
            obj.addChild(childController)
        }
    }
    
    @available(iOS 5.0, *)
    public func removeFromParent(aspector: Patcher) {
        dispatch(self, patcher: aspector) { obj.removeFromParent() }
    }
    
    @available(iOS 5.0, *)
    public func transition(
        from fromViewController: UIViewController,
        to toViewController: UIViewController,
        duration: TimeInterval,
        options: UIView.AnimationOptions = [],
        animations: (() -> Void)?,
        completion: ((Bool) -> Void)? = nil,
        aspector: Patcher)
    {
        dispatch(self, patcher: aspector) {
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
        animated: Bool,
        aspector: Patcher)
    {
        dispatch(self, patcher: aspector) {
            obj.beginAppearanceTransition(isAppearing,
                                          animated: animated)
        }
    }
    
    @available(iOS 5.0, *)
    public func endAppearanceTransition(aspector: Patcher) {
        dispatch(self, patcher: aspector) { obj.endAppearanceTransition() }
    }
    
    @available(iOS 8.0, *)
    public func setOverrideTraitCollection(
        _ collection: UITraitCollection?,
        forChild childViewController: UIViewController,
        aspector: Patcher)
    {
        dispatch(self, patcher: aspector) {
            obj.setOverrideTraitCollection(collection,
                                           forChild: childViewController)
        }
    }
    
    @available(iOS 8.0, *)
    public func overrideTraitCollection(
        forChild childViewController: UIViewController,
        aspector: Patcher) -> UITraitCollection?
    {
        return dispatch(self, patcher: aspector) {
            obj.overrideTraitCollection(forChild: childViewController)
        }
    }
    
    @available(iOS, introduced: 6.0, deprecated: 8.0, message: "Manually forward viewWillTransitionToSize:withTransitionCoordinator: if necessary")
    public func shouldAutomaticallyForwardRotationMethods(aspector: Patcher) -> Bool {
        return dispatch(self, patcher: aspector) {
            obj.shouldAutomaticallyForwardRotationMethods()
        }
    }
    
    @available(iOS 5.0, *)
    public func willMove(
        toParent parent: UIViewController?,
        aspector: Patcher)
    {
        dispatch(self, patcher: aspector) {
            obj.willMove(toParent: parent)
        }
    }
    
    @available(iOS 5.0, *)
    public func didMove(
        toParent parent: UIViewController?,
        aspector: Patcher)
    {
        dispatch(self, patcher: aspector) {
            obj.didMove(toParent: parent)
        }
    }
    
    @available(iOS 6.0, *)
    public func encodeRestorableState(
        with coder: NSCoder,
        aspector: Patcher)
    {
        dispatch(self, patcher: aspector) {
            obj.encodeRestorableState(with: coder)
        }
    }
    
    @available(iOS 6.0, *)
    public func decodeRestorableState(
        with coder: NSCoder,
        aspector: Patcher)
    {
        dispatch(self, patcher: aspector) {
            obj.decodeRestorableState(with: coder)
        }
    }
    
    @available(iOS 7.0, *)
    public func applicationFinishedRestoringState(aspector: Patcher) {
        dispatch(self, patcher: aspector) { obj.applicationFinishedRestoringState() }
    }
    
    @available(iOS 6.0, *)
    public func updateViewConstraints(aspector: Patcher) {
        dispatch(self, patcher: aspector) { obj.updateViewConstraints() }
    }
    
    @available(iOS 11.0, *)
    public func viewLayoutMarginsDidChange(aspector: Patcher) {
        dispatch(self, patcher: aspector) { obj.viewLayoutMarginsDidChange() }
    }
    
    @available(iOS 11.0, *)
    public func viewSafeAreaInsetsDidChange(aspector: Patcher) {
        dispatch(self, patcher: aspector) { obj.viewSafeAreaInsetsDidChange() }
    }
    
    @available(iOS 9.0, *)
    public func addKeyCommand(
        _ keyCommand: UIKeyCommand,
        aspector: Patcher)
    {
        dispatch(self, patcher: aspector) {
            obj.addKeyCommand(keyCommand)
        }
    }
    
    @available(iOS 9.0, *)
    public func removeKeyCommand(
        _ keyCommand: UIKeyCommand,
        aspector: Patcher)
    {
        dispatch(self, patcher: aspector) {
            obj.removeKeyCommand(keyCommand)
        }
    }
    
    @available(iOS 9.0, *)
    public func registerForPreviewing(
        with delegate: UIViewControllerPreviewingDelegate,
        sourceView: UIView,
        aspector: Patcher) -> UIViewControllerPreviewing
    {
        return dispatch(self, patcher: aspector) {
            obj.registerForPreviewing(with: delegate,
                                      sourceView: sourceView)
        }
    }
    
    @available(iOS 9.0, *)
    public func unregisterForPreviewing(
        withContext previewing: UIViewControllerPreviewing,
        aspector: Patcher)
    {
        dispatch(self, patcher: aspector) {
            obj.unregisterForPreviewing(withContext: previewing)
        }
    }
    
    @available(iOS 11.0, *)
    public func setNeedsUpdateOfScreenEdgesDeferringSystemGestures(aspector: Patcher) {
        dispatch(self, patcher: aspector) { obj.setNeedsUpdateOfScreenEdgesDeferringSystemGestures() }
    }
    
    @available(iOS 11.0, *)
    public func setNeedsUpdateOfHomeIndicatorAutoHidden(aspector: Patcher) {
        dispatch(self, patcher: aspector) { obj.setNeedsUpdateOfHomeIndicatorAutoHidden() }
    }
}

#endif
