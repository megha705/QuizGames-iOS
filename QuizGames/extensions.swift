/*
 *  Copyright 2016 Radoslav Yordanov
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

import UIKit

extension CollectionType {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}


extension NSDate {
    func yearsFrom(date:NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Year, fromDate: date, toDate: self, options: NSCalendarOptions()).year
    }
    func monthsFrom(date:NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Month, fromDate: date, toDate: self, options: NSCalendarOptions()).month
    }
    func weeksFrom(date:NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: date, toDate: self, options: NSCalendarOptions()).weekOfYear
    }
    func daysFrom(date:NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: self, options: NSCalendarOptions()).day
    }
    func hoursFrom(date:NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: NSCalendarOptions()).hour
    }
    func minutesFrom(date:NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: self, options: NSCalendarOptions()).minute
    }
    func secondsFrom(date:NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: self, options: NSCalendarOptions()).second
    }
    var relativeTime: String {
        let now = NSDate()
        let yesterday = NSLocalizedString("yesterday", comment: "")
        let justNow = NSLocalizedString("justNow", comment: "")
        
        if now.yearsFrom(self)   > 0 {
            if now.yearsFrom(self)   > 1 {
                return String(format: NSLocalizedString("years", comment: ""), now.yearsFrom(self).description)
            } else {
                return String(format: NSLocalizedString("year", comment: ""), now.yearsFrom(self).description)
            }
        }
        if now.monthsFrom(self)  > 0 {
            if now.monthsFrom(self)  > 1 {
                return String(format: NSLocalizedString("months", comment: ""), now.monthsFrom(self).description)
            } else {
                return String(format: NSLocalizedString("month", comment: ""), now.monthsFrom(self).description)
            }
        }
        if now.weeksFrom(self)   > 0 {
            if now.weeksFrom(self)   > 1 {
                return String(format: NSLocalizedString("weeks", comment: ""), now.weeksFrom(self).description)
            } else {
                return String(format: NSLocalizedString("week", comment: ""), now.weeksFrom(self).description)
            }
        }
        if now.daysFrom(self)    > 0 {
            if now.daysFrom(self) == 1 { return yesterday }
            return String(format: NSLocalizedString("days", comment: ""), now.daysFrom(self).description)
        }
        if now.hoursFrom(self)   > 0 {
            if now.hoursFrom(self)   > 1 {
                return String(format: NSLocalizedString("hours", comment: ""), now.hoursFrom(self).description)
            } else {
                return String(format: NSLocalizedString("hour", comment: ""), now.hoursFrom(self).description)
            }
        }
        if now.minutesFrom(self) > 0 {
            if now.minutesFrom(self) > 1 {
                return String(format: NSLocalizedString("minutes", comment: ""), now.minutesFrom(self).description)
            } else {
                return String(format: NSLocalizedString("minute", comment: ""), now.minutesFrom(self).description)
            }
        }
        if now.secondsFrom(self) >= 0 {
            if now.secondsFrom(self) < 15 {
                return justNow
            }
            if now.secondsFrom(self) > 1 {
                return String(format: NSLocalizedString("seconds", comment: ""), now.secondsFrom(self).description)
            } else {
                return String(format: NSLocalizedString("second", comment: ""), now.secondsFrom(self).description)
            }
        }
        return ""
    }
    
}

extension UINavigationController {
    public override func shouldAutorotate() -> Bool {
        return visibleViewController!.shouldAutorotate()
    }
    
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return (visibleViewController?.supportedInterfaceOrientations())!
    }
}

extension UIAlertController {
    public override func shouldAutorotate() -> Bool {
        return false
    }
    
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
}
