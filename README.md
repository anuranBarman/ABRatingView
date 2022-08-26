# ABRatingView

A simple and customizable rating view for your next iOS app.

<video controls>
  <source src="https://youtube.com/shorts/1ILFi2LfkO0?feature=share" type="video/mp4">
</video>

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


