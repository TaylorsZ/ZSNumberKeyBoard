import UIKit
import ZSExtensionSwift

enum InputType : Int {
    case positive // 正数键盘
    case float
}
class NumberKeyBoard: UIView {
    var textInput:UITextField?
    override init(frame: CGRect) {
        super.init(frame: frame);
        setKeyBoardUI();
    }
    func setKeyBoardUI() {
        //,"delete","Done"
        let buttons = ["1","2","3","4","5","6","7","8","9","0", ".","-","icon_delete","icon_down"];
        let buttonW = (UIScreen.main.bounds.size.width / CGFloat(buttons.count)) - 5
        frame = CGRect(x: 0, y: 0, width: 0, height: buttonW + 10)
        for i in 0..<buttons.count {
            let button = UIButton(type: .custom)
            
            button.frame = CGRect(x: CGFloat(i) * buttonW + CGFloat((i + 1) * 5), y: 5, width: buttonW, height: buttonW)
            let title = buttons[i]
            switch i {
            case 12:
                
                button.setImage(imageWithName(title), for: .normal);
                button.setTitleColor(UIColor.black, for: .normal)
                button.setTitleColor(UIColor.white, for: .highlighted)
                button.setBackgroundColor(color: UIColor.red, state: UIControl.State.normal)
                button.setBackgroundColor(color: UIColor.green, state: UIControl.State.highlighted)
                button.tag = 100
                break;
            case 13:
                button.setImage(imageWithName(title), for: .normal);
                button.titleEdgeInsets = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
                button.setBackgroundColor(color: UIColor.blue, state: UIControl.State.normal)
                button.setBackgroundColor(color: UIColor.green, state: UIControl.State.highlighted)
                button.tag = 101
                break;
            default:
                button.setTitle(title, for: .normal)
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 28)
                button.setTitleColor(UIColor.black, for: .normal)
                button.setTitleColor(UIColor.white, for: .highlighted)
                button.setBackgroundColor(color: UIColor.white, state: UIControl.State.normal)
                button.setBackgroundColor(color: UIColor.green, state: UIControl.State.highlighted)
                break;
            }
            
            button.addTarget(self, action: #selector(keyboardViewAction(_:)), for: .touchUpInside)
            addSubview(button)
        }
    }
    @objc func keyboardViewAction(_ sender: UIButton) {
        
        guard let textInput = textInput else {
            return;
        }
        
        switch sender.tag {
        case 100:
            // 删除
            textInput.deleteBackward()
            break;
        case 101:
            if textInput.text?.count == 0 {
                textInput.insertText("0")
            }
            
            textInput.resignFirstResponder()
            break;
        default:
            
            guard let text = sender.currentTitle else {
                return;
            }
            switch text {
            case ".":
                if let oldText = textInput.text ,oldText.count > 0 , oldText.contains(".") == false ,let preText = oldText.last,preText != "-" {
                    textInput.insertText(".")
                }
                break;
            case "-":
                if textInput.text?.count == 0 {
                    textInput.insertText("-")
                }
                break;
            default:
                textInput.insertText(text);
                break;
            }
            break;
        }
    }
    
    private func imageWithName(_ name:String) -> UIImage? {
        
        let mainBundle = Bundle.init(for: NumberKeyBoard.self);
        guard let resourcePath = mainBundle.path(forResource: "ZSKeyBoradUIResources", ofType: "bundle") else {
            return nil;
        }
        let resourceBundle = Bundle(path: resourcePath);
        let image = UIImage(named: name, in: resourceBundle, compatibleWith: nil);
        return image;
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private var customKeyBoardKey = "UITextField_Extension_type"

extension UITextField {
    
    var inputType: InputType? {
        set {
            let boardView = NumberKeyBoard();
            boardView.textInput = self;
            self.inputView = boardView;
            objc_setAssociatedObject(self, &customKeyBoardKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            let rs = objc_getAssociatedObject(self, &customKeyBoardKey) as? InputType
            return rs
        }
    }
}
