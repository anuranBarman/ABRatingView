import UIKit

@available(iOS 13.0, *)
public class ABRatingView:UIView {
    
    private var titleLabel:UILabel!
    private var subTitleLabel:UILabel!
    private var skipButtonLabel:UILabel!
    private var submitButton:UIButton!
    private var starHolderView:StarHolder!
    private var gradientLayer:CAGradientLayer!
    private var emojiView:EmojiView!
    private let margin:CGFloat = 30
    private var config:ABRatingViewConfiguration!
    private var onSkip:(()->Void)!
    private var onSubmit:((_ star:Int)->Void)!
    private var givenStar:Int = 5
    
    convenience init(configuration:ABRatingViewConfiguration = ABRatingViewConfiguration(),onSkip:@escaping ()->Void,onSubmit:@escaping (_ star:Int)->Void) {
        self.init()
        self.config = configuration
        self.onSkip = onSkip
        self.onSubmit = onSubmit
        self.initView()
    }
    
    private func initView(){
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints=false
        titleLabel.text = self.config.title
        titleLabel.textColor = self.config.titleFont.textColor
        titleLabel.font = self.config.titleFont.font
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        
        self.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: margin * 2).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: margin).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -margin).isActive = true
        
        subTitleLabel = UILabel()
        subTitleLabel.translatesAutoresizingMaskIntoConstraints=false
        subTitleLabel.text = self.config.subTitle
        subTitleLabel.textColor = self.config.subtitleFont.textColor
        subTitleLabel.font = self.config.subtitleFont.font
        subTitleLabel.numberOfLines = 0
        subTitleLabel.lineBreakMode = .byWordWrapping
        
        self.addSubview(subTitleLabel)
        subTitleLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 20).isActive = true
        subTitleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: margin).isActive = true
        subTitleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -margin).isActive = true
        
        skipButtonLabel = UILabel()
        skipButtonLabel.translatesAutoresizingMaskIntoConstraints=false
        skipButtonLabel.attributedText = getUnderlinedText()
        skipButtonLabel.font = self.config.skipButtonFont.font
        skipButtonLabel.textColor = self.config.skipButtonFont.textColor
        skipButtonLabel.isUserInteractionEnabled = true
        
        let tapGestureSkip = UITapGestureRecognizer(target: self, action: #selector(skipTapped(_:)))
        skipButtonLabel.addGestureRecognizer(tapGestureSkip)
        
        self.addSubview(skipButtonLabel)
        skipButtonLabel.leftAnchor.constraint(equalTo: self.subTitleLabel.leftAnchor, constant: 0).isActive = true
        skipButtonLabel.topAnchor.constraint(equalTo: self.subTitleLabel.bottomAnchor, constant: 20).isActive = true
        skipButtonLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        submitButton = UIButton()
        submitButton.translatesAutoresizingMaskIntoConstraints=false
        submitButton.layer.cornerRadius = 25
        submitButton.layer.borderWidth = 1.5
        submitButton.layer.borderColor = self.config.submitButtonFont.textColor.cgColor
        submitButton.setTitle(self.config.submitButtonTitle, for: .normal)
        submitButton.titleLabel?.font = self.config.submitButtonFont.font
        submitButton.setTitleColor(self.config.submitButtonFont.textColor, for: .normal)
        submitButton.addTarget(self, action: #selector(submitTapped(_:)), for: .touchUpInside)
        
        self.addSubview(submitButton)
        submitButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -margin).isActive = true
        submitButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: margin).isActive = true
        submitButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -margin).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        starHolderView = StarHolder(width:UIScreen.main.bounds.width - (margin * 2),height: 50, onTap: { index in
            self.submitButton.backgroundColor = self.config.submitButtonFont.textColor
            self.submitButton.setTitleColor(.black, for: .normal)
            self.submitButton.layer.borderWidth = 0
            self.changeGradientColor(index: index)
            self.givenStar = index + 1
            self.handleEmoji()
        })
        starHolderView.translatesAutoresizingMaskIntoConstraints=false
        
        self.addSubview(starHolderView)
        starHolderView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - (margin * 2)).isActive = true
        starHolderView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        starHolderView.bottomAnchor.constraint(equalTo: self.submitButton.topAnchor, constant: -margin).isActive = true
        starHolderView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        emojiView = EmojiView(eyeSize: 50,width: UIScreen.main.bounds.width - (margin * 2))
        emojiView.translatesAutoresizingMaskIntoConstraints=false
        
        self.addSubview(emojiView)
        emojiView.topAnchor.constraint(equalTo: self.skipButtonLabel.bottomAnchor, constant: 20).isActive = true
        emojiView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - (margin * 2)).isActive = true
        emojiView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        emojiView.bottomAnchor.constraint(equalTo: self.starHolderView.topAnchor, constant: -20).isActive = true
    }
    
    private func getUnderlinedText()->NSAttributedString {
        let attrs = [
            NSAttributedString.Key.foregroundColor : self.config.skipButtonFont.textColor,
            NSAttributedString.Key.font : self.config.skipButtonFont.font,
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.underlineColor : self.config.skipButtonFont.textColor
        ] as! [NSAttributedString.Key:Any]
        let string = NSMutableAttributedString(string: self.config.skipButtonTitle, attributes: attrs)
        return string
    }
    
    @objc private func skipTapped(_ sender:UITapGestureRecognizer){
        self.onSkip()
    }
    
    @objc private func submitTapped(_ sender:UIButton){
        self.onSubmit(self.givenStar)
    }
    
    private func changeGradientColor(index:Int){
        UIView.animate(withDuration: 0.2) {
            self.gradientLayer.colors = self.config.colors[index].map({ color in
                return color.cgColor
            })
        }
    }
    
    private func addGradient(){
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(hex: 0xF8A031),UIColor(hex: 0xF46c22)].map({ color in
            return color.cgColor
        })
        gradient.locations = [0.0,1.0]
        gradient.frame = self.bounds
        
        if let gradientLayer = self.layer.sublayers?[0] as? CAGradientLayer {
            gradientLayer.removeFromSuperlayer()
        }
        self.layer.insertSublayer(gradient, at: 0)
        self.gradientLayer = gradient
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.addGradient()
    }
    
    private func handleEmoji(){
        self.emojiView.changeEmoji(star: self.givenStar)
    }
    
}


fileprivate class EmojiView:UIView {
    
    private var leftEye:UIView!
    private var rightEye:UIView!
    private var eyeGap:CGFloat = 40
    private var mouthView:MouthView!
    
    func changeEmoji(star:Int){
        self.mouthView.star = star
    }
    
    convenience init(eyeSize:CGFloat,width:CGFloat) {
        self.init()
        
        eyeGap = width / 4
        
        leftEye = UIView()
        leftEye.translatesAutoresizingMaskIntoConstraints=false
        leftEye.layer.cornerRadius = eyeSize / 2
        leftEye.backgroundColor = .black
        
        self.addSubview(leftEye)
        leftEye.widthAnchor.constraint(equalToConstant: eyeSize).isActive = true
        leftEye.heightAnchor.constraint(equalToConstant: eyeSize).isActive = true
        leftEye.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        leftEye.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -(eyeSize + eyeGap)).isActive = true
        
        
        rightEye = UIView()
        rightEye.translatesAutoresizingMaskIntoConstraints=false
        rightEye.layer.cornerRadius = eyeSize / 2
        rightEye.backgroundColor = .black
        
        self.addSubview(rightEye)
        rightEye.widthAnchor.constraint(equalToConstant: eyeSize).isActive = true
        rightEye.heightAnchor.constraint(equalToConstant: eyeSize).isActive = true
        rightEye.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        rightEye.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: (eyeSize + eyeGap)).isActive = true
        
        
        mouthView = MouthView()
        mouthView.translatesAutoresizingMaskIntoConstraints=false
        
        self.addSubview(mouthView)
        mouthView.topAnchor.constraint(equalTo: self.leftEye.bottomAnchor, constant: 10).isActive = true
        mouthView.widthAnchor.constraint(equalToConstant: width).isActive = true
        mouthView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        mouthView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        
        
        
    }
    
    
}

fileprivate class MouthView:UIView {
    
    private var mouthWidth:CGFloat = 50
    private var shapeLayer:CAShapeLayer!
    private var path:UIBezierPath!
    private var oldStar:Int = 3
    
    var star:Int = 3 {
        didSet {
            self.setNeedsDisplay()
        }
        willSet {
            oldStar = star
        }
    }
    
    override func draw(_ rect: CGRect) {
        //self.layer.sublayers?.removeAll()
        switch star {
        case 1:
            self.drawVerySadMouth()
            break
        case 2:
            self.drawSadMouth()
            break
        case 3:
            self.drawMehMouth()
            break
        case 4:
            self.drawHappyMouth()
            break
        case 5:
            self.drawVeryHappyMouth()
            break
        default:
            break
        }
    }
    
    private func drawMehMouth(){
        if self.shapeLayer == nil {
            path = UIBezierPath()
            path.move(to: CGPoint(x: self.frame.width / 2 - (mouthWidth * 1.2), y: self.frame.height / 2))
            path.addLine(to: CGPoint(x: self.frame.width / 2 + (mouthWidth * 1.2), y: self.frame.height / 2 - (mouthWidth - 20)))
            
            
            shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.lineWidth = 25
            shapeLayer.strokeColor = UIColor.black.cgColor
            shapeLayer.strokeEnd = 0
            shapeLayer.fillColor = UIColor.clear.cgColor
            
            
            self.layer.addSublayer(shapeLayer)
            
            let anim1 = CABasicAnimation(keyPath: "strokeEnd")
            anim1.fromValue = 0
            anim1.toValue           = 1
            anim1.duration          = 0.1
            anim1.repeatCount       = 0
            anim1.autoreverses      = false
            anim1.isRemovedOnCompletion = false
            anim1.isAdditive = true
            anim1.fillMode = CAMediaTimingFillMode.forwards
            
            
            
            shapeLayer.add(anim1, forKey: nil)
        }else {
            
            let anim1 = CABasicAnimation(keyPath: "path")
            anim1.fromValue = path.cgPath
            
            path = UIBezierPath()
            path.move(to: CGPoint(x: self.frame.width / 2 - (mouthWidth * 1.2), y: self.frame.height / 2))
            path.addLine(to: CGPoint(x: self.frame.width / 2 + (mouthWidth * 1.2), y: self.frame.height / 2 - (mouthWidth - 20)))
            
            
            anim1.toValue           = path.cgPath
            anim1.duration          = 0.1
            anim1.repeatCount       = 0
            anim1.autoreverses      = false
            anim1.isRemovedOnCompletion = false
            anim1.isAdditive = true
            anim1.fillMode = CAMediaTimingFillMode.forwards
            anim1.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
            
            shapeLayer.add(anim1, forKey: nil)
            shapeLayer.fillColor = UIColor.clear.cgColor
        }
        
    }
    
    private func drawSadMouth(){
        
        
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        let anim1 = CABasicAnimation(keyPath: "path")
        anim1.fromValue = path.cgPath
        
        path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2), radius: mouthWidth, startAngle: -CGFloat.pi, endAngle: CGFloat.pi / 128, clockwise: true)
        
        anim1.toValue           = path.cgPath
        anim1.duration          = 0.1
        anim1.repeatCount       = 0
        anim1.autoreverses      = false
        anim1.isRemovedOnCompletion = false
        anim1.isAdditive = true
        anim1.fillMode = CAMediaTimingFillMode.forwards
        
        
        shapeLayer.add(anim1, forKey: nil)
        
        
    }
    
    private func drawVerySadMouth(){
        
        shapeLayer.fillColor = UIColor.black.cgColor
        
        let anim1 = CABasicAnimation(keyPath: "path")
        anim1.fromValue = path.cgPath
        
        path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2), radius: mouthWidth, startAngle: -CGFloat.pi, endAngle: CGFloat.pi / 128, clockwise: true)
        
        anim1.toValue           = path.cgPath
        anim1.duration          = 0.1
        anim1.repeatCount       = 0
        anim1.autoreverses      = false
        anim1.isRemovedOnCompletion = false
        anim1.isAdditive = true
        anim1.fillMode = CAMediaTimingFillMode.forwards
        
        
        shapeLayer.add(anim1, forKey: nil)
    }
    
    private func drawHappyMouth(){
        
        
        self.shapeLayer.fillColor = UIColor.clear.cgColor
        
        let anim1 = CABasicAnimation(keyPath: "path")
        anim1.fromValue = path.cgPath
        
        path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - (mouthWidth / 2)), radius: mouthWidth, startAngle: CGFloat.pi / 64, endAngle: CGFloat.pi, clockwise: true)
        
        anim1.toValue           = path.cgPath
        anim1.duration          = 0.1
        anim1.repeatCount       = 0
        anim1.autoreverses      = false
        anim1.isRemovedOnCompletion = false
        anim1.isAdditive = true
        anim1.fillMode = CAMediaTimingFillMode.forwards
        
        
        shapeLayer.add(anim1, forKey: nil)
        
    }
    
    private func drawVeryHappyMouth(){
        
        self.shapeLayer.fillColor = UIColor.black.cgColor
        
        
        let anim1 = CABasicAnimation(keyPath: "path")
        anim1.fromValue = path.cgPath
        
        path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - (mouthWidth / 2)), radius: mouthWidth, startAngle: CGFloat.pi / 128, endAngle: CGFloat.pi, clockwise: true)
        
        anim1.toValue           = path.cgPath
        anim1.duration          = 0.1
        anim1.repeatCount       = 0
        anim1.autoreverses      = false
        anim1.isRemovedOnCompletion = false
        anim1.isAdditive = true
        anim1.fillMode = CAMediaTimingFillMode.forwards
        
        
        shapeLayer.add(anim1, forKey: nil)
    }
    
}


@available(iOS 13.0, *)
fileprivate class StarHolder:UIView {
    
    private var sidePadding:CGFloat = 20
    private let starCount = 5
    private let gap:CGFloat = 10
    private var stars:[UIImageView] = []
    private var onTap:((_ index:Int)->Void)!
    
    convenience init(width:CGFloat,height:CGFloat,onTap:@escaping (_ index:Int)->Void){
        self.init()
        self.onTap = onTap
        self.backgroundColor = .black.withAlphaComponent(0.1)
        self.layer.cornerRadius = height / 2
        
        let availableWidth:CGFloat = width - (sidePadding * 2)
        let starWidth:CGFloat = (availableWidth - (gap * CGFloat(starCount - 1))) / CGFloat(starCount)
        let starHeight:CGFloat = height - sidePadding
        
        for i in 0..<starCount {
            let starView = UIImageView()
            starView.translatesAutoresizingMaskIntoConstraints=false
            starView.contentMode = .scaleAspectFit
            starView.image = UIImage(systemName: "circle.fill")?.withRenderingMode(.alwaysTemplate)
            starView.tintColor = .white
            starView.tag = i
            starView.isUserInteractionEnabled = true
            starView.transform = CGAffineTransform(rotationAngle: -(CGFloat.pi / 2))
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(starTapped(_:)))
            starView.addGestureRecognizer(tapGesture)
            
            self.addSubview(starView)
            
            starView.widthAnchor.constraint(equalToConstant: starWidth).isActive = true
            starView.heightAnchor.constraint(equalToConstant: starHeight).isActive = true
            starView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
            
            if i == 0 {
                starView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: sidePadding).isActive = true
            }else {
                starView.leftAnchor.constraint(equalTo: self.subviews[i-1].rightAnchor, constant: gap).isActive = true
            }
            
            stars.append(starView)
        }
    }
    
    @objc private func starTapped(_ sender:UITapGestureRecognizer){
        let index = sender.view!.tag
        for i in 0..<index + 1 {
            stars[i].image = UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysTemplate)
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut]) {
                self.stars[i].transform = CGAffineTransform.identity
            } completion: { _ in
                
            }

        }
        for i in index+1..<self.stars.count {
            stars[i].image = UIImage(systemName: "circle.fill")?.withRenderingMode(.alwaysTemplate)
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut]) {
                self.stars[i].transform = CGAffineTransform(rotationAngle: -(CGFloat.pi / 2))
            } completion: { _ in
                
            }

        }
        self.onTap(index)
    }
    
}


public struct ABRatingViewConfiguration {
    var title = "Please rate your experience"
    var subTitle = "Do let us know your thoughts, your feedback matters"
    var submitButtonTitle = "SUBMIT"
    var skipButtonTitle = "SKIP"
    var titleFont:ABRatingViewFont = ABRatingViewFont(font: UIFont.boldSystemFont(ofSize: 30))
    var subtitleFont:ABRatingViewFont = ABRatingViewFont(font: UIFont.systemFont(ofSize: 20))
    var skipButtonFont:ABRatingViewFont = ABRatingViewFont(font: .boldSystemFont(ofSize: 18))
    var submitButtonFont:ABRatingViewFont = ABRatingViewFont(font: .boldSystemFont(ofSize: 18))
    var colors:[[UIColor]] = [
        [UIColor(hex: 0xF46c22),UIColor(hex: 0xF46c22)],
        [UIColor(hex: 0xF8A031),UIColor(hex: 0xF46c22)],
        [UIColor(hex: 0xF8A031),UIColor(hex: 0xF46c22)],
        [UIColor(hex: 0xF8A031),UIColor(hex: 0xF8A031)],
        [UIColor(hex: 0xF8A031),UIColor(hex: 0xF8B661)],
    ]
    
    public init(){
        
    }
    
    struct ABRatingViewFont {
        var font:UIFont
        var textColor:UIColor = .white
    }
}


extension UIColor {
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
}
