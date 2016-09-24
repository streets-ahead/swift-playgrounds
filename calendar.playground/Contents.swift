

import UIKit
import Foundation
import PlaygroundSupport

extension Calendar {
	func date(fromMonth month: Int, year: Int) -> Date? {
		var comps = DateComponents()
		comps.year = year
		comps.month = month
		return self.date(from: comps);
	}
  
  func firstWeekday(in month: Int, year: Int) -> Int? {
    if let date = self.date(fromMonth: month, year: year) {
      return self.component(.weekday, from: date)
    } else {
      return nil
    }
  }
  
  func days(in month: Int, year: Int) -> Range<Int>? {
    if let date = self.date(fromMonth: month, year: year) {
      return self.range(of: .day, in: .month, for: date)
    } else {
      return nil
    }
  }
}

func getLayout(for date: Date) -> [[Int]]? {
	let cal = Calendar.current
	
	let comps = cal.dateComponents([.year, .month], from: date)
	
	guard let startOfMonth = cal.firstWeekday(in: comps.month!, year: comps.year!),
				let daysInCurrent = cal.days(in: comps.month!, year: comps.year!),
				let daysInPrevMonth = cal.days(in: comps.month! - 1, year: comps.year!)?.upperBound
		else { return nil }
	
	var result = [[Int]()]
  
	for i in (daysInPrevMonth - startOfMonth + 1)..<daysInPrevMonth {
		result[0].append(i)
	}

	var row = 0
	for i in CountableRange(daysInCurrent) {
		result[row].append(i)
		if((i + startOfMonth - 1) % 7 == 0) {
			row = row + 1
			result.append([])
		}
	}
  
  for i in 1...(7 - result[result.count-1].count) {
    result[result.count-1].append(i)
  }
	
	return result
}

getLayout(for: Date())

class DayView: UIView {
  init(frame: CGRect, day: String) {
    super.init(frame: frame)
    backgroundColor = .red
    let label = UILabel()
    label.frame = frame
    label.text = day
    label.textAlignment = .center
    addSubview(label)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

let calen = Calendar.current


class CalendarLayout: UICollectionViewFlowLayout, UICollectionViewDataSource {
  let calLayout: [[Int]]
  
  override init() {
    calLayout = getLayout(for: calen.date(fromMonth: 2, year: 2015)!)!
    super.init()
    minimumInteritemSpacing = 0
    minimumLineSpacing = 0
    scrollDirection = .vertical
    
    print("wqerqwerqwer")
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override var itemSize: CGSize {
    set {
      
    }
    get {
      let frame = self.collectionView!.frame
      return CGSize(width: frame.width / 7.0, height: frame.height / 5)
    }
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return calLayout.count * 7
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    cell.contentView.backgroundColor = .blue
    print(indexPath)
    cell.contentView.addSubview(DayView(frame: cell.bounds,
                                day: String(calLayout[Int(indexPath[1] / 7)][indexPath[1] % 7])))
    return cell
  }
  
}


let ds = CalendarLayout()
let colView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 500, height: 500),
                               collectionViewLayout: ds)
colView.dataSource = ds

PlaygroundPage.current.liveView = colView


