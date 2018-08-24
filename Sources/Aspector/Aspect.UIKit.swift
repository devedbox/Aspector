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
        patcher: Patcher<Void>) rethrows
    {
        try _dispatch(self, patcher: patcher) { _ in
            obj.attemptRotationToDeviceOrientation()
        }
    }
}

// MARK: - UIViewController.

extension Aspect where T: UIViewController {
    
    public func loadView(patcher: Patcher<Void>) rethrows {
        try _dispatch(self, patcher: patcher) { _ in obj.loadView() }
    }
    
    @available(iOS 9.0, *)
    public func loadViewIfNeeded(patcher: Patcher<Void>) rethrows {
        try _dispatch(self, patcher: patcher) { _ in obj.loadViewIfNeeded() }
    }
    
    public func viewDidLoad(patcher: Patcher<Void>) rethrows {
        try _dispatch(self, patcher: patcher) { _ in obj.viewDidLoad() }
    }
    
    @available(iOS 5.0, *)
    public func performSegue(
        withIdentifier identifier: String,
        sender: Any?,
        patcher: Patcher<(String, Any?)>) rethrows
    {
        try _dispatch(self, patcher: patcher) {
            obj.performSegue(withIdentifier: $0?.0 ?? identifier,
                             sender: $0?.1 ?? sender)
        }
    }
    
    @available(iOS 6.0, *)
    public func shouldPerformSegue(
        withIdentifier identifier: String,
        sender: Any?,
        patcher: Patcher<(String, Any?)>) rethrows -> Bool
    {
        return try _dispatch(self, patcher: patcher) {
            obj.shouldPerformSegue(withIdentifier: $0?.0 ?? identifier,
                                   sender: $0?.1 ?? sender)
        }
    }
    
    @available(iOS 5.0, *)
    public func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?,
        patcher: Patcher<(UIStoryboardSegue, Any?)>) rethrows
    {
        try _dispatch(self, patcher: patcher) {
            obj.prepare(for: $0?.0 ?? segue,
                        sender: $0?.1 ?? sender)
        }
    }
    
    @available(iOS 6.0, *)
    public func canPerformUnwindSegueAction(
        _ action: Selector,
        from fromViewController: UIViewController,
        withSender sender: Any,
        patcher: Patcher<(Selector, UIViewController, Any)>) rethrows -> Bool
    {
        return try _dispatch(self, patcher: patcher) {
            obj.canPerformUnwindSegueAction($0?.0 ?? action,
                                            from: $0?.1 ?? fromViewController,
                                            withSender: $0?.2 ?? sender)
        }
    }
    
    @available(iOS 9.0, *)
    public func allowedChildrenForUnwinding(
        from source: UIStoryboardUnwindSegueSource,
        patcher: Patcher<UIStoryboardUnwindSegueSource>) rethrows -> [UIViewController]
    {
        return try _dispatch(self, patcher: patcher) {
            obj.allowedChildrenForUnwinding(from: $0 ?? source)
        }
    }
    
    @available(iOS 9.0, *)
    public func childContaining(
        _ source: UIStoryboardUnwindSegueSource,
        patcher: Patcher<UIStoryboardUnwindSegueSource>) rethrows -> UIViewController?
    {
        return try _dispatch(self, patcher: patcher) {
            obj.childContaining($0 ?? source)
        }
    }
    
    @available(iOS, introduced: 6.0, deprecated: 9.0)
    public func forUnwindSegueAction(
        _ action: Selector,
        from fromViewController: UIViewController,
        withSender sender: Any?,
        patcher: Patcher<(Selector, UIViewController, Any?)>) rethrows -> UIViewController?
    {
        return try _dispatch(self, patcher: patcher) {
            obj.forUnwindSegueAction($0?.0 ?? action,
                                     from: $0?.1 ?? fromViewController,
                                     withSender: $0?.2 ?? sender)
        }
    }
    
    @available(iOS 9.0, *)
    public func unwind(
        for unwindSegue: UIStoryboardSegue,
        towards subsequentVC: UIViewController,
        patcher: Patcher<(UIStoryboardSegue, UIViewController)>) rethrows
    {
        try _dispatch(self, patcher: patcher) {
            obj.unwind(for: $0?.0 ?? unwindSegue,
                       towards: $0?.1 ?? subsequentVC)
        }
    }
    
    @available(iOS, introduced: 6.0, deprecated: 9.0)
    public func segueForUnwinding(
        to toViewController: UIViewController,
        from fromViewController: UIViewController,
        identifier: String?,
        patcher: Patcher<(UIViewController, UIViewController, String?)>) rethrows -> UIStoryboardSegue?
    {
        return try _dispatch(self, patcher: patcher) {
            obj.segueForUnwinding(to: $0?.0 ?? toViewController,
                                  from: $0?.1 ?? fromViewController,
                                  identifier: $0?.2 ?? identifier)
        }
    }
    
    public func viewWillAppear(
        _ animated: Bool,
        patcher: Patcher<Bool>) rethrows
    {
        try _dispatch(self, patcher: patcher) { obj.viewWillAppear($0 ?? animated) }
    }
    
    public func viewDidAppear(
        _ animated: Bool,
        patcher: Patcher<Bool>) rethrows
    {
        try _dispatch(self, patcher: patcher) { obj.viewDidAppear($0 ?? animated) }
    }
    
    public func viewWillDisappear(
        _ animated: Bool,
        patcher: Patcher<Bool>) rethrows
    {
        try _dispatch(self, patcher: patcher) { obj.viewWillDisappear($0 ?? animated) }
    }
    
    public func viewDidDisappear(
        _ animated: Bool,
        patcher: Patcher<Bool>) rethrows
    {
        try _dispatch(self, patcher: patcher) { obj.viewDidDisappear($0 ?? animated) }
    }
    
    @available(iOS 5.0, *)
    public func viewWillLayoutSubviews(patcher: Patcher<Void>) rethrows {
        try _dispatch(self, patcher: patcher) { _ in obj.viewWillLayoutSubviews() }
    }
    
    @available(iOS 5.0, *)
    public func viewDidLayoutSubviews(patcher: Patcher<Void>) rethrows {
        try _dispatch(self, patcher: patcher) { _ in obj.viewDidLayoutSubviews() }
    }
    public func didReceiveMemoryWarning(patcher: Patcher<Void>) rethrows {
        try _dispatch(self, patcher: patcher) { _ in obj.didReceiveMemoryWarning() }
    }
    
    public func parent(patcher: Patcher<Void>) rethrows -> UIViewController? {
        return try _dispatch(self, patcher: patcher) { _ in obj.parent }
    }
    
    @available(iOS 5.0, *)
    public func presentedViewController(patcher: Patcher<Void>) rethrows -> UIViewController? {
        return try _dispatch(self, patcher: patcher) { _ in obj.presentedViewController }
    }
    
    @available(iOS 5.0, *)
    public func presentingViewController(patcher: Patcher<Void>) rethrows -> UIViewController? {
        return try _dispatch(self, patcher: patcher) { _ in obj.presentingViewController }
    }
    
    @available(iOS 5.0, *)
    public func present(
        _ viewControllerToPresent: UIViewController,
        animated flag: Bool,
        completion: (() -> Void)? = nil,
        patcher: Patcher<(UIViewController, Bool, (() -> Void)?)>) rethrows
    {
        try _dispatch(self, patcher: patcher) {
            obj.present($0?.0 ?? viewControllerToPresent,
                        animated: $0?.1 ?? flag,
                        completion: $0?.2 ?? completion)
        }
    }
    
    @available(iOS 5.0, *)
    public func dismiss(
        animated flag: Bool,
        completion: (() -> Void)? = nil,
        patcher: Patcher<(Bool, (() -> Void)?)>) rethrows
    {
        try _dispatch(self, patcher: patcher) {
            obj.dismiss(animated: $0?.0 ?? flag,
                        completion: $0?.1 ?? completion)
        }
    }
    
    @available(iOS 7.0, *)
    public func setNeedsStatusBarAppearanceUpdate(patcher: Patcher<Void>) rethrows {
        try _dispatch(self, patcher: patcher) { _ in obj.setNeedsStatusBarAppearanceUpdate() }
    }
    
    @available(iOS 8.0, *)
    public func targetViewController(
        forAction action: Selector,
        sender: Any?,
        patcher: Patcher<(Selector, Any?)>) rethrows -> UIViewController?
    {
        return try _dispatch(self, patcher: patcher) {
            obj.targetViewController(forAction: $0?.0 ?? action,
                                     sender: $0?.1 ?? sender)
        }
    }
    
    @available(iOS 8.0, *)
    public func show(
        _ vc: UIViewController,
        sender: Any?,
        patcher: Patcher<(UIViewController, Any?)>) rethrows
    {
        try _dispatch(self, patcher: patcher) {
            obj.show($0?.0 ?? vc,
                     sender: $0?.1 ?? sender)
        }
    }
    
    @available(iOS 8.0, *)
    public func showDetailViewController(
        _ vc: UIViewController,
        sender: Any?,
        patcher: Patcher<(UIViewController, Any?)>) rethrows
    {
        try _dispatch(self, patcher: patcher) {
            obj.showDetailViewController($0?.0 ?? vc,
                                         sender: $0?.1 ?? sender)
        }
    }
    
    @available(iOS, introduced: 2.0, deprecated: 8.0, message: "Header views are animated along with the rest of the view hierarchy")
    public func rotatingHeaderView(patcher: Patcher<Void>) rethrows -> UIView? {
        return try _dispatch(self, patcher: patcher) { _ in obj.rotatingHeaderView() }
    }
    
    @available(iOS, introduced: 2.0, deprecated: 8.0, message: "Footer views are animated along with the rest of the view hierarchy")
    public func rotatingFooterView(patcher: Patcher<Void>) rethrows -> UIView? {
        return try _dispatch(self, patcher: patcher) { _ in obj.rotatingFooterView() }
    }
    
    @available(iOS, introduced: 2.0, deprecated: 8.0, message: "Implement viewWillTransitionToSize:withTransitionCoordinator: instead")
    public func willRotate(
        to toInterfaceOrientation: UIInterfaceOrientation,
        duration: TimeInterval,
        patcher: Patcher<(UIInterfaceOrientation, TimeInterval)>) rethrows
    {
        try _dispatch(self, patcher: patcher) {
            obj.willRotate(to: $0?.0 ?? toInterfaceOrientation,
                           duration: $0?.1 ?? duration)
        }
    }
    
    @available(iOS, introduced: 2.0, deprecated: 8.0)
    public func didRotate(
        from fromInterfaceOrientation: UIInterfaceOrientation,
        patcher: Patcher<UIInterfaceOrientation>) rethrows
    {
        try _dispatch(self, patcher: patcher) {
            obj.didRotate(from: $0 ?? fromInterfaceOrientation)
        }
    }
    
    @available(iOS, introduced: 3.0, deprecated: 8.0, message: "Implement viewWillTransitionToSize:withTransitionCoordinator: instead")
    public func willAnimateRotation(
        to toInterfaceOrientation: UIInterfaceOrientation,
        duration: TimeInterval,
        patcher: Patcher<(UIInterfaceOrientation, TimeInterval)>) rethrows
    {
        try _dispatch(self, patcher: patcher) {
            obj.willAnimateRotation(to: $0?.0 ?? toInterfaceOrientation,
                                    duration: $0?.1 ?? duration)
        }
    }
    
    public func setEditing(
        _ editing: Bool,
        animated: Bool,
        patcher: Patcher<(Bool, Bool)>) rethrows
    {
        try _dispatch(self, patcher: patcher) {
            obj.setEditing($0?.0 ?? editing,
                           animated: $0?.1 ?? animated)
        }
    }
    
    @available(iOS 5.0, *)
    public func addChild(
        _ childController: UIViewController,
        patcher: Patcher<UIViewController>) rethrows
    {
        try _dispatch(self, patcher: patcher) {
            obj.addChild($0 ?? childController)
        }
    }
    
    @available(iOS 5.0, *)
    public func removeFromParent(patcher: Patcher<Void>) rethrows {
        try _dispatch(self, patcher: patcher) { _ in obj.removeFromParent() }
    }
    
    @available(iOS 5.0, *)
    public func transition(
        from fromViewController: UIViewController,
        to toViewController: UIViewController,
        duration: TimeInterval,
        options: UIView.AnimationOptions = [],
        animations: (() -> Void)?,
        completion: ((Bool) -> Void)? = nil,
        patcher: Patcher<(UIViewController, UIViewController, TimeInterval, UIView.AnimationOptions, (() -> Void)?, ((Bool) -> Void)?)>) rethrows
    {
        try _dispatch(self, patcher: patcher) {
            obj.transition(from: $0?.0 ?? fromViewController,
                           to: $0?.1 ?? toViewController,
                           duration: $0?.2 ?? duration,
                           options: $0?.3 ?? options,
                           animations: $0?.4 ?? animations,
                           completion: $0?.5 ?? completion)
        }
    }
    
    @available(iOS 5.0, *)
    public func beginAppearanceTransition(
        _ isAppearing: Bool,
        animated: Bool,
        patcher: Patcher<(Bool, Bool)>) rethrows
    {
        try _dispatch(self, patcher: patcher) {
            obj.beginAppearanceTransition($0?.0 ?? isAppearing,
                                          animated: $0?.1 ?? animated)
        }
    }
    
    @available(iOS 5.0, *)
    public func endAppearanceTransition(patcher: Patcher<Void>) rethrows {
        try _dispatch(self, patcher: patcher) { _ in obj.endAppearanceTransition() }
    }
    
    @available(iOS 8.0, *)
    public func setOverrideTraitCollection(
        _ collection: UITraitCollection?,
        forChild childViewController: UIViewController,
        patcher: Patcher<(UITraitCollection?, UIViewController)>) rethrows
    {
        try _dispatch(self, patcher: patcher) {
            obj.setOverrideTraitCollection($0?.0 ?? collection,
                                           forChild: $0?.1 ?? childViewController)
        }
    }
    
    @available(iOS 8.0, *)
    public func overrideTraitCollection(
        forChild childViewController: UIViewController,
        patcher: Patcher<UIViewController>) rethrows -> UITraitCollection?
    {
        return try _dispatch(self, patcher: patcher) {
            obj.overrideTraitCollection(forChild: $0 ?? childViewController)
        }
    }
    
    @available(iOS, introduced: 6.0, deprecated: 8.0, message: "Manually forward viewWillTransitionToSize:withTransitionCoordinator: if necessary")
    public func shouldAutomaticallyForwardRotationMethods(patcher: Patcher<Void>) rethrows -> Bool {
        return try _dispatch(self, patcher: patcher) { _ in
            obj.shouldAutomaticallyForwardRotationMethods()
        }
    }
    
    @available(iOS 5.0, *)
    public func willMove(
        toParent parent: UIViewController?,
        patcher: Patcher<UIViewController?>) rethrows
    {
        try _dispatch(self, patcher: patcher) {
            obj.willMove(toParent: $0 ?? parent)
        }
    }
    
    @available(iOS 5.0, *)
    public func didMove(
        toParent parent: UIViewController?,
        patcher: Patcher<UIViewController?>) rethrows
    {
        try _dispatch(self, patcher: patcher) {
            obj.didMove(toParent: $0 ?? parent)
        }
    }
    
    @available(iOS 6.0, *)
    public func encodeRestorableState(
        with coder: NSCoder,
        patcher: Patcher<NSCoder>) rethrows
    {
        try _dispatch(self, patcher: patcher) {
            obj.encodeRestorableState(with: $0 ?? coder)
        }
    }
    
    @available(iOS 6.0, *)
    public func decodeRestorableState(
        with coder: NSCoder,
        patcher: Patcher<NSCoder>) rethrows
    {
        try _dispatch(self, patcher: patcher) {
            obj.decodeRestorableState(with: $0 ?? coder)
        }
    }
    
    @available(iOS 7.0, *)
    public func applicationFinishedRestoringState(patcher: Patcher<Void>) rethrows {
        try _dispatch(self, patcher: patcher) { _ in obj.applicationFinishedRestoringState() }
    }
    
    @available(iOS 6.0, *)
    public func updateViewConstraints(patcher: Patcher<Void>) rethrows {
        try _dispatch(self, patcher: patcher) { _ in obj.updateViewConstraints() }
    }
    
    @available(iOS 11.0, *)
    public func viewLayoutMarginsDidChange(patcher: Patcher<Void>) rethrows {
        try _dispatch(self, patcher: patcher) { _ in obj.viewLayoutMarginsDidChange() }
    }
    
    @available(iOS 11.0, *)
    public func viewSafeAreaInsetsDidChange(patcher: Patcher<Void>) rethrows {
        try _dispatch(self, patcher: patcher) { _ in obj.viewSafeAreaInsetsDidChange() }
    }
    
    @available(iOS 9.0, *)
    public func addKeyCommand(
        _ keyCommand: UIKeyCommand,
        patcher: Patcher<UIKeyCommand>) rethrows
    {
        try _dispatch(self, patcher: patcher) {
            obj.addKeyCommand($0 ?? keyCommand)
        }
    }
    
    @available(iOS 9.0, *)
    public func removeKeyCommand(
        _ keyCommand: UIKeyCommand,
        patcher: Patcher<UIKeyCommand>) rethrows
    {
        try _dispatch(self, patcher: patcher) {
            obj.removeKeyCommand($0 ?? keyCommand)
        }
    }
    
    @available(iOS 9.0, *)
    public func registerForPreviewing(
        with delegate: UIViewControllerPreviewingDelegate,
        sourceView: UIView,
        patcher: Patcher<(UIViewControllerPreviewingDelegate, UIView)>) rethrows -> UIViewControllerPreviewing
    {
        return try _dispatch(self, patcher: patcher) {
            obj.registerForPreviewing(with: $0?.0 ?? delegate,
                                      sourceView: $0?.1 ?? sourceView)
        }
    }
    
    @available(iOS 9.0, *)
    public func unregisterForPreviewing(
        withContext previewing: UIViewControllerPreviewing,
        patcher: Patcher<UIViewControllerPreviewing>) rethrows
    {
        try _dispatch(self, patcher: patcher) {
            obj.unregisterForPreviewing(withContext: $0 ?? previewing)
        }
    }
    
    @available(iOS 11.0, *)
    public func setNeedsUpdateOfScreenEdgesDeferringSystemGestures(patcher: Patcher<Void>) rethrows {
        try _dispatch(self, patcher: patcher) { _ in obj.setNeedsUpdateOfScreenEdgesDeferringSystemGestures() }
    }
    
    @available(iOS 11.0, *)
    public func setNeedsUpdateOfHomeIndicatorAutoHidden(patcher: Patcher<Void>) rethrows {
        try _dispatch(self, patcher: patcher) { _ in obj.setNeedsUpdateOfHomeIndicatorAutoHidden() }
    }
}

#endif
