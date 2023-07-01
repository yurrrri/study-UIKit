//
//  BMICalculatorManager.swift
//  ViewTransition_BMIProject
//
//  Created by 이유리 on 2023/07/01.
//

import UIKit

// Model : 뷰와 전혀 무관한 로직 및 데이터 모델 관련

struct BMICalculatorManager {
    private var bmi:BMI?

    // bmi를 얻어오는 로직도 Manager한테 위임함
    func getBMIResult() -> BMI {
        return bmi ?? BMI(value: 0.0, advice: "문제발생", color: .white)
    }
    
    // BMI얻기 메서드
    mutating func getBMI(height: String, weight: String) -> BMI {
        // BMI만들기 메서드 호출
        calculateBMI(height: height, weight: weight)
        // BMI리턴
        return bmi ?? BMI(value: 0.0, advice: "문제발생", color: UIColor.white)
    }
    
    // BMI만들기 메서드(BMI수치 계산해서, BMI구조체 인스턴스 만드는 메서드)
    mutating private func calculateBMI(height: String, weight: String) {
        guard let h = Double(height), let w = Double(weight) else {
            bmi = BMI(value: 0.0, advice: "문제발생", color: UIColor.white)
            return
        }
        
        var bmiNum = w / (h * h) * 10000
        bmiNum = round(bmiNum * 10) / 10
        
        switch bmiNum {
        case ..<18.6:
            let color = UIColor(displayP3Red: 22/255,
                                green: 231/255,
                                blue: 207/255,
                                alpha: 1)
            bmi = BMI(value: bmiNum, advice: "저체중", color: color)
            
        case 18.6..<23.0:
            let color = UIColor(displayP3Red: 212/255,
                                green: 251/255,
                                blue: 121/255,
                                alpha: 1)
            bmi = BMI(value: bmiNum, advice: "표준", color: color)
            
            
        case 23.0..<25.0:
            let color = UIColor(displayP3Red: 218/255,
                                green: 127/255,
                                blue: 163/255,
                                alpha: 1)
            bmi = BMI(value: bmiNum, advice: "과체중", color: color)
        case 25.0..<30.0:
            let color = UIColor(displayP3Red: 255/255,
                                green: 150/255,
                                blue: 141/255,
                                alpha: 1)
            bmi = BMI(value: bmiNum, advice: "중도비만", color: color)
        case 30.0...:
            let color = UIColor(displayP3Red: 255/255,
                                green: 100/255,
                                blue: 78/255,
                                alpha: 1)
            bmi = BMI(value: bmiNum, advice: "고도비만", color: color)
        default:
            bmi = BMI(value: 0.0, advice: "문제발생", color: UIColor.white)
        }
    }
    
    
//    func getBMIValue() -> Double {
//        return bmi?.value ?? 0.0
//    }
//
//    func getAdviceString() -> String {
//        return bmi?.advice ?? "문제발생"
//    }
//
//    func getColor() -> UIColor {
//        return bmi?.matchColor ?? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//    }
}
