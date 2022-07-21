//
//  LNGLimitTextView.swift
//  HanYuanSchool
//
//  Created by sun on 2022/7/20.
//  Copyright © 2022 hanyuan. All rights reserved.
//

import UIKit

protocol LNGLimitTextViewDelegate: NSObjectProtocol {
    func lngLimitTextViewText(textString:String)
}

class LNGLimitTextView: UIView {
    lazy var textView: UITextView = {
        let textView = UITextView.init(frame: CGRect.zero)
        textView.backgroundColor = .white
        textView.font = UIFont.systemFont(ofSize: 12)
        textView.delegate = self
        return textView
    }()
    lazy var placeLabel: UILabel = {
        let placeLabel = UILabel.init(frame: CGRect.zero)
        placeLabel.font = UIFont.systemFont(ofSize: 12)
        placeLabel.text = placeholder
        placeLabel.textColor = .black
        return placeLabel
    }()
    lazy var numberTipLabel: UILabel = {
        let numberTipLabel = UILabel.init(frame: CGRect.zero)
        numberTipLabel.font = UIFont.systemFont(ofSize: 10)
        let string = "0/\(limitNumber)"
        let attributedString = NSMutableAttributedString.init(string: string)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(red: 204, green: 204, blue: 204) ?? UIColor.lightGray, range: NSRange.init(location: 0, length: string.count))
        numberTipLabel.attributedText = attributedString
        numberTipLabel.textAlignment = .right
        return numberTipLabel
    }()
    lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: screenWidth(), height: 40))
        toolBar.barStyle = .default
        let flexible:UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton:UIBarButtonItem = UIBarButtonItem.init(title: "完成", style: .done, target: self, action: #selector(didClickDoneButton))
        let buttonArray = [flexible,doneButton]
        toolBar.setItems(buttonArray, animated: false)
        toolBar.setShadowImage(UIImage(), forToolbarPosition: .any)
        return toolBar
    }()
    
    weak var delegate: LNGLimitTextViewDelegate?
    var limitNumber:Int = 100
    var placeholder:String = ""
    var isHiddenNumberTip:Bool = false
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame:CGRect,placeholder: String? = "",limitNumber:Int? = 100,isShowToolbar:Bool? = false, isHiddenNumberTip:Bool? = false) {
        if let p = placeholder {
            self.placeholder = p
        }
        if let l = limitNumber {
            self.limitNumber = l
        }
        if let i = isHiddenNumberTip, i == true {
            self.isHiddenNumberTip = i
        } else {
            self.isHiddenNumberTip = false
        }
        super.init(frame: frame)
        if let i = isShowToolbar, i == true {
            textView.inputAccessoryView = toolBar
        }
        setupViews()
    }
    
    func setupViews() {
        addSubview(textView)
        addSubview(placeLabel)
        addSubview(numberTipLabel)
        remakeConstraints()
    }
    
    func remakeConstraints() {
        let textViewBottomMargin = isHiddenNumberTip ? 2 : 16
        textView.snp.remakeConstraints { (make) in
            make.leading.equalTo(self.snp.leading).offset(5)
            make.top.equalTo(self.snp.top).offset(2)
            make.trailing.equalTo(self.snp.trailing).offset(5)
            make.bottom.equalTo(self.snp.bottom).offset(-textViewBottomMargin)
        }
        placeLabel.snp.remakeConstraints { (make) in
            make.leading.equalTo(self.snp.leading).offset(12)
            make.top.equalTo(self.snp.top).offset(10)
            make.trailing.equalTo(self.snp.trailing).offset(-12)
            make.height.equalTo(17)
        }
        let numberTipLabelHeight = isHiddenNumberTip ? 0 : 14
        numberTipLabel.snp.remakeConstraints { (make) in
            make.trailing.equalTo(self.snp.trailing).offset(-5)
            make.bottom.equalTo(self.snp.bottom).offset(-2)
            make.width.equalTo(100)
            make.height.equalTo(numberTipLabelHeight)
        }
    }
    
    @objc func didClickDoneButton() {
        textView.resignFirstResponder()
    }
    
}

extension LNGLimitTextView:UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.count == 0 {
            placeLabel.isHidden = false
        } else {
            placeLabel.isHidden = true
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let replacementText = "将要输入的字符串\(text)"
        print(replacementText)
        let str:NSString = ((textView.text ?? "") + text) as NSString
        if str.length > limitNumber {
            let rangeIndex:NSRange = str.rangeOfComposedCharacterSequence(at: limitNumber)
            if rangeIndex.length == 1 {
                //字数超限
                textView.text = str.substring(to: limitNumber)
                //这里重新统计下字数，字数超限，我发现就不走textViewDidChange方法了，你若不统计字数，忽略这行
                let string = "\(textView.text.count)/\(limitNumber)"
                let suffix = "\(limitNumber)"
                let attributedString = NSMutableAttributedString.init(string: string)
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(red: 255, green: 65, blue: 51) ?? UIColor.red, range: NSRange.init(location: 0, length: string.count - suffix.count))
                numberTipLabel.attributedText = attributedString
            } else {
                let rangeRange = str.rangeOfComposedCharacterSequences(for: NSRange.init(location: 0, length: limitNumber))
                textView.text = str.substring(with: rangeRange)
            }
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let string = "\(textView.text.count)/\(limitNumber)"
        let attributedString = NSMutableAttributedString.init(string: string)
        if textView.text.count == 0 {
            placeLabel.isHidden = false
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(red: 204, green: 204, blue: 204) ?? UIColor.lightGray, range: NSRange.init(location: 0, length: string.count))
        } else {
            placeLabel.isHidden = true
            let suffix = "/\(limitNumber)"
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(red: 255, green: 65, blue: 51) ?? UIColor.red, range: NSRange.init(location: 0, length: (string.count - suffix.count)))
        }
        numberTipLabel.attributedText = attributedString
        let textString = textView.text ?? ""
        delegate?.lngLimitTextViewText(textString: textString)
    }
}
