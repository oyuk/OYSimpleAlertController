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
    
    fileprivate var presenting = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        presenting ? presentTransition(transitionContext) : dismissTransition(transitionContext)
    }
    
    fileprivate func presentTransition(_ transitionContext: UIViewControllerContextTransitioning){
        
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! OYSimpleAlertController
        toVC.contentView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        let containerView = transitionContext.containerView
        containerView.insertSubview(toVC.view, aboveSubview: fromVC.view)
        
        UIView.animate(
            
            withDuration: transitionDuration(using: transitionContext),animations: { () -> Void in
                
            }, completion: { (finished) -> Void in
                
                UIView.animate(withDuration: 0.4,
                    delay: 0,
                    usingSpringWithDamping: 0.5,
                    initialSpringVelocity: 1.0,
                    options: UIViewAnimationOptions.allowAnimatedContent,
                    animations: { () -> Void in
                        toVC.backgroundView.alpha = 1
                        toVC.contentView.alpha = 1.0
                        toVC.contentView.transform = CGAffineTransform.identity
                    }, completion: { (finish) -> Void in
                        transitionContext.completeTransition(true)
                })
        }) 
    }
    
    fileprivate func dismissTransition(_ transitionContext: UIViewControllerContextTransitioning){
        
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! OYSimpleAlertController
        
        UIView.animate(
            
            withDuration: transitionDuration(using: transitionContext),animations: { () -> Void in
                
            }, completion: { (finished) -> Void in
                
                UIView.animate(withDuration: 0.4,
                    delay: 0,
                    usingSpringWithDamping: 0.5,
                    initialSpringVelocity: 1.0,
                    options: UIViewAnimationOptions.allowAnimatedContent,
                    animations: { () -> Void in
                        fromVC.backgroundView.alpha = 0
                        fromVC.contentView.alpha = 0
                        fromVC.contentView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                    }, completion: { (finish) -> Void in
                        transitionContext.completeTransition(true)
                })
        }) 
        
    }
}

extension UIScreen {
    class func screenWidth()->CGFloat {
        return self.main.bounds.width
    }
    
    class func screenHeight()->CGFloat {
        return self.main.bounds.size.height
    }
}

public enum OYActionStyle:Int {
    case `default`,cancel
}

open class OYAlertAction:NSObject {
    fileprivate var title:String!
    fileprivate var actionStyle:OYActionStyle!
    fileprivate var actionHandler:(()->Void)?
    
    convenience public init(title:String,actionStyle:OYActionStyle,actionHandler:(()->Void)?){
        self.init()
        self.title = title
        self.actionStyle = actionStyle
        self.actionHandler = actionHandler
    }
}

open class OYSimpleAlertController: UIViewController,UIViewControllerTransitioningDelegate {
   
    fileprivate class OYAlertTitleLabel:UILabel {
        override func layoutSubviews() {
            super.layoutSubviews()
            
            let maskPath = UIBezierPath(roundedRect: self.bounds,
                byRoundingCorners: [UIRectCorner.topLeft , UIRectCorner.topRight],
                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
            
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = maskPath.cgPath
            
            self.layer.mask = maskLayer
        }
    }
    
    fileprivate class OYAlertTextView:UITextView {
        override var canBecomeFirstResponder : Bool {
            return false
        }
    }
    
    class OYActionButton:UIButton {
        var oyAlertAction:OYAlertAction!
    }

    fileprivate var alertTitle = ""
    fileprivate var message = ""
    
    fileprivate let backgroundView = UIView()
    open var backgroundViewColor:UIColor = UIColor.black.withAlphaComponent(0.3)
    
    fileprivate let contentView = UIView()
    
    fileprivate let alertTitleLabel = OYAlertTitleLabel()
    fileprivate let alertTitleLabelHeight:CGFloat = 40
    open var alertTitleColor:UIColor = UIColor.white
    open var alertTitleFont:UIFont = UIFont.boldSystemFont(ofSize: 23)
    open var alertTitleBackgroundColor = UIColor(red: 46/255.0, green: 204/255.0, blue: 113/255.0, alpha: 1.0)
    
    fileprivate let messageTextView = OYAlertTextView()
    fileprivate let maxMessageTextViewheight:CGFloat = UIScreen.screenHeight() * 0.7
    open var messageColor:UIColor = UIColor.black
    open var messageFont:UIFont = UIFont.systemFont(ofSize: 18)
    
    fileprivate var actionButtons:[OYActionButton] = []
    fileprivate let buttonHeight:CGFloat = 40
    fileprivate let buttonMargin:CGFloat = 5
    open var buttonFont:UIFont = UIFont.boldSystemFont(ofSize: 23)
    open var buttonTextColor:UIColor = UIColor.white
    open var buttonBackgroundColors:[OYActionStyle:UIColor] = [
        .default:UIColor(red: 3/255.0, green: 169/255.0, blue: 244/255.0, alpha: 1.0),
        .cancel :UIColor(red: 231/255.0, green: 76/255.0, blue: 60/255.0 , alpha: 1.0)
    ]
    
    fileprivate let alertWidth:CGFloat = UIScreen.screenWidth() - 50
    fileprivate let maxButtonNum = 2
    
    fileprivate let animater = LunchAnimation()
    
    convenience public init(title:String,message:String) {
        self.init()
        
        self.alertTitle = title
        self.message = message
        
        self.transitioningDelegate = self
        self.definesPresentationContext = true
        self.providesPresentationContextTransitionStyle = true
        self.modalPresentationStyle = .custom
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
    }
    
    fileprivate func setup(){
        setUpBackgroundView()
        setUpContentView()
        setUpTitle()
        setUpMessage()
        setUpButton()
        modifyContentViewSize()
    }
    
    fileprivate func modifyContentViewSize(){
        contentView.frame.size = CGSize(width: alertWidth, height: alertTitleLabelHeight + messageTextView.frame.height + buttonHeight + buttonMargin * 2)
        contentView.center = self.view.center
    }
    
    fileprivate func setUpBackgroundView(){
        backgroundView.frame = self.view.bounds
        backgroundView.backgroundColor = backgroundViewColor
        
        self.view.addSubview(backgroundView)
    }
    
    fileprivate func setUpContentView(){
        contentView.backgroundColor = UIColor.white
        contentView.layer.cornerRadius = cornerRadius

        self.view.addSubview(contentView)
    }
    
    fileprivate func setUpTitle(){
        alertTitleLabel.frame = CGRect(x: 0, y: 0, width: alertWidth, height: alertTitleLabelHeight)
        alertTitleLabel.text = alertTitle
        alertTitleLabel.font = alertTitleFont
        alertTitleLabel.textColor = alertTitleColor
        alertTitleLabel.textAlignment = .center
        alertTitleLabel.backgroundColor = alertTitleBackgroundColor
        alertTitleLabel.layer.cornerRadius = cornerRadius
        
        contentView.addSubview(alertTitleLabel)
    }
    
    fileprivate func setUpMessage(){
        messageTextView.frame = CGRect(x: 0, y: alertTitleLabelHeight, width: alertWidth, height: 0)
        messageTextView.text = message
        messageTextView.font = messageFont
        messageTextView.textColor = messageColor
        messageTextView.isEditable = false

        contentView.addSubview(messageTextView)
        
        messageTextView.sizeToFit()
        if messageTextView.frame.height > maxMessageTextViewheight {
            messageTextView.frame.size = CGSize(width: alertWidth,height: maxMessageTextViewheight)
        }
    }
    
    fileprivate func setUpButton(){
        let buttonOriginY = alertTitleLabelHeight + messageTextView.frame.height + buttonMargin
        let buttonWidth = actionButtons.count == 2 ? (alertWidth - buttonMargin * 3)/2 : alertWidth - buttonMargin * 2

        for button in actionButtons {
            button.frame = CGRect(
                x: CGFloat(button.tag) * (buttonWidth + buttonMargin) + buttonMargin,
                y: buttonOriginY,
                width: buttonWidth,
                height: buttonHeight)
            button.setTitle(button.oyAlertAction.title, for: UIControlState())
            button.backgroundColor = buttonBackgroundColors[button.oyAlertAction.actionStyle]
            button.addTarget(self, action: #selector(OYSimpleAlertController.action(_:)), for: .touchUpInside)
            button.setTitleColor(buttonTextColor, for: UIControlState())
            button.titleLabel?.font = buttonFont
            button.layer.cornerRadius = cornerRadius
            
            contentView.addSubview(button)
        }
    }
    
    open func addAction(_ action:OYAlertAction) {
        assert(actionButtons.count < maxButtonNum, "OYAlertAction must be \(maxButtonNum) or less")
        
        let button = OYActionButton()
        button.oyAlertAction = action
        button.tag = actionButtons.count
        
        actionButtons.append(button)
    }
    
    func action(_ sender: OYActionButton){
        let button = sender as OYActionButton
        if let action = button.oyAlertAction.actionHandler {
            action()
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    open func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animater.presenting = true
        return animater
    }
    
    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animater.presenting = false
        return animater
    }
    
}
