//

import UIKit

class LaunchViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView! {
            didSet {
                scrollView.delegate = self
                self.scrollView.contentSize.height = 1.0 // disable vertical scroll
                scrollView.isPagingEnabled = true // Enable horizontal paging
                scrollView.showsVerticalScrollIndicator = false // Hide vertical scroll indicator
                scrollView.showsHorizontalScrollIndicator = false // Hide horizontal scroll indicator
            }
        }
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    var slides:[Slide] = [];
    
    override func viewDidLoad() {
           super.viewDidLoad()
           UserDefaults.standard.set(true, forKey: "FirstTimeLogin")
           self.navigationController?.isNavigationBarHidden = true
           slides = createSlides()
           setupSlideScrollView(slides: slides)
           pageControl.numberOfPages = slides.count
           pageControl.currentPage = 0
           view.bringSubviewToFront(pageControl)
       }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    func createSlides() -> [Slide] {

        let slide1:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide1.imageView.image = UIImage(named: "Online Diagnosis iOS Application")
        slide1.continueBtn.isHidden = true
        slide1.labelDesc.text = "Online Diagnosis"
        slide1.labelDesc.textAlignment = .center
        slide1.labelDesc.font = .boldSystemFont(ofSize: 30.0)
        
        let slide2:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide2.imageView.image = UIImage(named: "Doctor")
        slide2.continueBtn.isHidden = true
        slide2.labelDesc.text = "Explore doctors near you with just a tap! Simply click on the 'Find The Doctor' icon to search for healthcare providers in your area on the map."
        
        let slide3:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide3.imageView.image = UIImage(named: "Consultanting")
        slide3.continueBtn.isHidden = false
        slide3.continueBtn.setTitle("Get Started", for: .normal)
        slide3.continueBtn.addTarget(self, action: #selector(LaunchViewController.openHome), for: .touchUpInside)
        slide3.labelDesc.text = "You can also have virtual consultations with doctors through our video chat feature, or send messages to doctors directly through our in-app chat"
        return [slide1, slide2, slide3]
    }
    
    
    func setupSlideScrollView(slides: [Slide]) {
           scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: scrollView.frame.height)

           for i in 0..<slides.count {
               slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: scrollView.frame.height)
               scrollView.addSubview(slides[i])
           }
        self.scrollView.contentSize.height = 1.0 // disable vertical scroll

       }
    /*
     * default function called when view is scolled. In order to enable callback
     * when scrollview is scrolled, the below code needs to be called:
     * slideScrollView.delegate = self or
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        
        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        
        // vertical
        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
        
        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
        
        
        /*
         * below code changes the background color of view on paging the scrollview
         */
//        self.scrollView(scrollView, didScrollToPercentageOffset: percentageHorizontalOffset)
        
    
        /*
         * below code scales the imageview on paging the scrollview
         */
        let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
        
        if(percentOffset.x > 0 && percentOffset.x <= 0.50) {
            
            slides[0].imageView.transform = CGAffineTransform(scaleX: (0.50-percentOffset.x)/0.50, y: (0.50-percentOffset.x)/0.50)
            slides[1].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.50, y: percentOffset.x/0.50)
            
        } else if(percentOffset.x > 0.50 && percentOffset.x <= 1) {
            slides[1].imageView.transform = CGAffineTransform(scaleX: (1-percentOffset.x)/0.50, y: (1-percentOffset.x)/0.50)
            slides[2].imageView.transform = CGAffineTransform(scaleX: percentOffset.x, y: percentOffset.x)
            
        }
    }
    
    
    
    
    func scrollView(_ scrollView: UIScrollView, didScrollToPercentageOffset percentageHorizontalOffset: CGFloat) {
        if(pageControl.currentPage == 0) {
            //Change background color to toRed: 103/255, fromGreen: 58/255, fromBlue: 183/255, fromAlpha: 1
            //Change pageControl selected color to toRed: 103/255, toGreen: 58/255, toBlue: 183/255, fromAlpha: 0.2
            //Change pageControl unselected color to toRed: 255/255, toGreen: 255/255, toBlue: 255/255, fromAlpha: 1
            
            let pageUnselectedColor: UIColor = fade(fromRed: 255/255, fromGreen: 255/255, fromBlue: 255/255, fromAlpha: 1, toRed: 103/255, toGreen: 58/255, toBlue: 183/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
            pageControl.pageIndicatorTintColor = pageUnselectedColor
        
            
            let bgColor: UIColor = fade(fromRed: 103/255, fromGreen: 58/255, fromBlue: 183/255, fromAlpha: 1, toRed: 255/255, toGreen: 255/255, toBlue: 255/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
            slides[pageControl.currentPage].backgroundColor = bgColor
            
            let pageSelectedColor: UIColor = fade(fromRed: 81/255, fromGreen: 36/255, fromBlue: 152/255, fromAlpha: 1, toRed: 103/255, toGreen: 58/255, toBlue: 183/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
            pageControl.currentPageIndicatorTintColor = pageSelectedColor
        }
    }
    
    
    func fade(fromRed: CGFloat,
              fromGreen: CGFloat,
              fromBlue: CGFloat,
              fromAlpha: CGFloat,
              toRed: CGFloat,
              toGreen: CGFloat,
              toBlue: CGFloat,
              toAlpha: CGFloat,
              withPercentage percentage: CGFloat) -> UIColor {
        
        let red: CGFloat = (toRed - fromRed) * percentage + fromRed
        let green: CGFloat = (toGreen - fromGreen) * percentage + fromGreen
        let blue: CGFloat = (toBlue - fromBlue) * percentage + fromBlue
        let alpha: CGFloat = (toAlpha - fromAlpha) * percentage + fromAlpha
        
        // return the fade colour
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
   @objc func openHome(){
        SceneDelegate.shared?.loginCheckOrRestart()
    }
}

