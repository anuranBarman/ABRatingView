# ABRatingView

A simple and customizable rating view for your next iOS app.

UI/UX inspired from Dribbble by <a href="https://dribbble.com/shots/3828382-Feedback">Adip Nayak</a>

<div align="left">
      <a href="https://youtube.com/shorts/1ILFi2LfkO0?feature=share">
         <img src="https://img.youtube.com/vi/1ILFi2LfkO0/0.jpg" style="width:100%;">
      </a>
</div>

### Installation

Available via Swift Package Manager (SPM)

### Usage

```
import UIKit
import ABRatingView

class ViewController: UIViewController {

    var ratingView:ABRatingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ratingView = ABRatingView(configuration: ABRatingViewConfiguration(),onSkip: {
            print("skipped")
        },onSubmit: { star in
            print("given star : \(star)")
        })
        ratingView.frame = self.view.bounds
        
        
        self.view.addSubview(ratingView)
    }


}
```

### Customization

You can customize elements of the UI by using `ABRatingViewConfiguration`.


