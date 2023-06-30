//
//  ViewController.swift
//  SliderAndTimer
//
//  Created by 이유리 on 2023/06/29.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var mainLabel: UILabel!
    
    weak var timer: Timer? // 왜 weak으로 했을까? -> timer안에서 클로저를 호출하기때문에 강한 참조 사이클이 발생할 수 있음
    
    var number = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    // UI를 세팅하는 함수
    func setupUI() {
        mainLabel.text = "초를 선택하세요"
        slider.value = 0.5
    }
    
    @IBAction func sliderChanged(_ sender: Any) {
        let seconds = Int(slider.value * 60)
        mainLabel.text = "\(seconds)초"
        number = seconds  // number도 같이 세팅 필요
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] _ in
            if number > 0 {
                number -= 1
                slider.value = Float(number) / Float(60)
                mainLabel.text = "\(number)초"
            } else {
                number = 0
                mainLabel.text = "초를 선택하세요"
                timer?.invalidate() // 끝나면 timer invalidate
                
                //소리나게 하기
                AudioServicesPlayAlertSound(SystemSoundID(1322))
                
            }
        }
    }

    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        mainLabel.text = "초를 선택하세요"
        slider.value = 0.5
    }
    
    @objc func doSomethingAfterSecond() {
        if number > 0 {
            number -= 1
            slider.value = Float(number) / Float(60)
            mainLabel.text = "\(number)초"
        } else {
            number = 0
            mainLabel.text = "초를 선택하세요"
            timer?.invalidate() // 끝나면 timer invalidate
            
            //소리나게 하기
            AudioServicesPlayAlertSound(SystemSoundID(1322))
            
        }
    }
    
}

