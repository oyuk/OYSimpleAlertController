//
//  OYSimpleAlertController.swift
//  OYSimpleAlertController
//
//  Created by oyuk on 2015/09/09.
//  Copyright (c) 2015年 oyuk. All rights reserved.
//

import UIKit

let cornerRadius:CGFloat = 10

class LunchAnimation:NSObject,UIViewControllerAnimatedTransitioning {
    
    private var presenting = false
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        presenting ? presentTransition(transitionContext) : dismissTransition(transitionContext)
    }
    
    private func presentTransition(transitionContext: UIViewControllerContextTransitioning){
        
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! OYSimpleAlertController
        toVC.contentView.transform = CGAffineTransformMakeScale(0.8, 0.8)
        
        let containerView = transitionContext.containerView()
        containerView!.insertSubview(toVC.view, aboveSubview: fromVC.view)
        
        UIView.animateWithDuration(
            
            transitionDuration(transitionContext),animations: { () -> Void in
                
            }) { (finished) -> Void in
                
                UIView.animateWithDuration(0.4,
                    delay: 0,
                    usingSpringWithDamping: 0.5,
                    initialSpringVelocity: 1.0,
                    options: UIViewAnimationOptions.AllowAnimatedContent,
                    animations: { () -> Void in
                        toVC.backgroundView.alpha = 1
                        toVC.contentView.alpha = 1.0
                        toVC.contentView.transform = CGAffineTransformIdentity
                    }, completion: { (finish) -> Void in
                        transitionContext.completeTransition(true)
                })
        }
    }
    
    private func dismissTransition(transitionContext: UIViewControllerContextTransitioning){
        
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! OYSimpleAlertController
        
        UIView.animateWithDuration(
            
            transitionDuration(transitionContext),animations: { () -> Void in
                
            }) { (finished) -> Void in
                
                UIView.animateWithDuration(0.4,
                    delay: 0,
                    usingSpringWithDamping: 0.5,
                    initialSpringVelocity: 1.0,
                    options: UIViewAnimationOptions.AllowAnimatedContent,
                    animations: { () -> Void in
                        fromVC.backgroundView.alpha = 0
                        fromVC.contentView.alpha = 0
                        fromVC.contentView.transform = CGAffineTransformMakeScale(0.8, 0.8)
                    }, completion: { (finish) -> Void in
                        transitionContext.completeTransition(true)
                })
        }
        
    }
}

extension UIScreen {
    class func screenWidth()->CGFloat {
        return self.mainScreen().bounds.width
    }
    
    class func screenHeight()->CGFloat {
        return self.mainScreen().bounds.size.height
    }
}

public enum OYActionStyle:Int {
    case Default,Cancel
}

public class OYAlertAction:NSObject {
    private var title:String!
    private var actionStyle:OYActionStyle!
    private var actionHandler:(()->Void)?
    
    convenience public init(title:String,actionStyle:OYActionStyle,actionHandler:(()->Void)?){
        self.init()
        self.title = title
        self.actionStyle = actionStyle
        self.actionHandler = actionHandler
    }
}

public class OYSimpleAlertController: UIViewController,UIViewControllerTransitioningDelegate {
   
    private class OYAlertTitleLabel:UILabel {
        override func layoutSubviews() {
            super.layoutSubviews()
            
            let maskPath = UIBezierPath(roundedRect: self.bounds,
                byRoundingCorners: [UIRectCorner.TopLeft , UIRectCorner.TopRight],
                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
            
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = maskPath.CGPath
            
            self.layer.mask = maskLayer
        }
    }
    
    private class OYAlertTextView:UITextView {
        override func canBecomeFirstResponder() -> Bool {
            return false
        }
    }
    
    class OYActionButton:UIButton {
        var oyAlertAction:OYAlertAction!
    }

    private var alertTitle = ""
    private var message = ""
    
    private let backgroundView = UIView()
    public var backgroundViewColor:UIColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
    
    private let contentView = UIView()
    
    private let alertTitleLabel = OYAlertTitleLabel()
    private let alertTitleLabelHeight:CGFloat = 40
    public var alertTitleColor:UIColor = UIColor.whiteColor()
    public var alertTitleFont:UIFont = UIFont.boldSystemFontOfSize(23)
    public var alertTitleBackgroundColor = UIColor(red: 46/255.0, green: 204/255.0, blue: 113/255.0, alpha: 1.0)
    
    private let messageTextView = OYAlertTextView()
    private let maxMessageTextViewheight:CGFloat = UIScreen.screenHeight() * 0.7
    public var messageColor:UIColor = UIColor.blackColor()
    public var messageFont:UIFont = UIFont.systemFontOfSize(18)
    
    private var actionButtons:[OYActionButton] = []
    private let buttonHeight:CGFloat = 40
    private let buttonMargin:CGFloat = 5
    public var buttonFont:UIFont = UIFont.boldSystemFontOfSize(23)
    public var buttonTextColor:UIColor = UIColor.whiteColor()
    public var buttonBackgroundColors:[OYActionStyle:UIColor] = [
        .Default:UIColor(red: 3/255.0, green: 169/255.0, blue: 244/255.0, alpha: 1.0),
        .Cancel :UIColor(red: 231/255.0, green: 76/255.0, blue: 60/255.0 , alpha: 1.0)
    ]
    
    private let alertWidth:CGFloat = UIScreen.screenWidth() - 50
    private let maxButtonNum = 2
    
    private let animater = LunchAnimation()
    
    convenience public init(title:String,message:String) {
        self.init()
        
        self.alertTitle = title
        self.message = message
        
        self.transitioningDelegate = self
        self.definesPresentationContext = true
        self.providesPresentationContextTransitionStyle = true
        self.modalPresentationStyle = .Custom
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setup()
    }
    
    private func setup(){
        setUpBackgroundView()
        setUpContentView()
        setUpTitle()
        setUpMessage()
        setUpButton()
        modifyContentViewSize()
    }
    
    private func modifyContentViewSize(){
        contentView.frame.size = CGSizeMake(alertWidth, alertTitleLabelHeight + messageTextView.frame.height + buttonHeight + buttonMargin * 2)
        contentView.center = self.view.center
    }
    
    private func setUpBackgroundView(){
        backgroundView.frame = self.view.bounds
        backgroundView.backgroundColor = backgroundViewColor
        
        self.view.addSubview(backgroundView)
    }
    
    private func setUpContentView(){
        contentView.backgroundColor = UIColor.whiteColor()
        contentView.layer.cornerRadius = cornerRadius

        self.view.addSubview(contentView)
    }
    
    private func setUpTitle(){
        alertTitleLabel.frame = CGRectMake(0, 0, alertWidth, alertTitleLabelHeight)
        alertTitleLabel.text = alertTitle
        alertTitleLabel.font = alertTitleFont
        alertTitleLabel.textColor = alertTitleColor
        alertTitleLabel.textAlignment = .Center
        alertTitleLabel.backgroundColor = alertTitleBackgroundColor
        alertTitleLabel.layer.cornerRadius = cornerRadius
        
        contentView.addSubview(alertTitleLabel)
    }
    
    private func setUpMessage(){
        messageTextView.frame = CGRectMake(0, alertTitleLabelHeight, alertWidth, 0)
        messageTextView.text = message
        messageTextView.font = messageFont
        messageTextView.textColor = messageColor
        messageTextView.editable = false

        contentView.addSubview(messageTextView)
        
        messageTextView.sizeToFit()
        if messageTextView.frame.height > maxMessageTextViewheight {
            messageTextView.frame.size = CGSizeMake(alertWidth,maxMessageTextViewheight)
        }
    }
    
    private func setUpButton(){
        let buttonOriginY = alertTitleLabelHeight + messageTextView.frame.height + buttonMargin
        let buttonWidth = actionButtons.count == 2 ? (alertWidth - buttonMargin * 3)/2 : alertWidth - buttonMargin * 2

        for button in actionButtons {
            button.frame = CGRectMake(
                CGFloat(button.tag) * (buttonWidth + buttonMargin) + buttonMargin,
                buttonOriginY,
                buttonWidth,
                buttonHeight)
            button.setTitle(button.oyAlertAction.title, forState: .Normal)
            button.backgroundColor = buttonBackgroundColors[button.oyAlertAction.actionStyle]
            button.addTarget(self, action: "action:", forControlEvents: .TouchUpInside)
            button.setTitleColor(buttonTextColor, forState: .Normal)
            button.titleLabel?.font = buttonFont
            button.layer.cornerRadius = cornerRadius
            
            contentView.addSubview(button)
        }
    }
    
    public func addAction(action:OYAlertAction) {
        assert(actionButtons.count < maxButtonNum, "OYAlertAction must be \(maxButtonNum) or less")
        
        let button = OYActionButton()
        button.oyAlertAction = action
        button.tag = actionButtons.count
        
        actionButtons.append(button)
    }
    
    func action(sender: OYActionButton){
        let button = sender as OYActionButton
        if let action = button.oyAlertAction.actionHandler {
            action()
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animater.presenting = true
        return animater
    }
    
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animater.presenting = false
        return animater
    }
    
}
