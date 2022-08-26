# ABRatingView

A simple and customizable rating view for your next iOS app.

<video controls>
  <source src="Demo.mp4" type="video/mp4">
</video>

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


