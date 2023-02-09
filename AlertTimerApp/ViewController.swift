//
//  ViewController.swift
//  AlertTimerApp
//
//  Created by 하연주 on 2023/02/08.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    let totalCount : Float = 60.0
    weak var timer : Timer?
    var timerNumber : Int = 0
    
    @IBOutlet weak var mainLabel: UILabel!
    //reset, start 버튼을 눌렀을 때 slider의 value값에 영향을 끼쳐야하므로 oulet도 있어야한다.
    @IBOutlet weak var slider: UISlider!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI () {
        mainLabel.text = "초를 선택하세요"
        //슬라이더를 가운데로 위치시키기 위해
        slider.setValue(0.5, animated: true) //slider.value = 0.5
        //timerNumber도 중간값으로 맞춰주기?
        //timerNumber = 30

    }


    @IBAction func sliderChanged(_ sender: UISlider) {
        //슬라이드 설정한 값으로 mainLabel 세팅
        let secondsInt : Int = Int(round(sender.value * totalCount)) //round 안해주고 그냥 Int로 감싸면 소수점 아래 버림
        mainLabel.text = "\(secondsInt) 초"
        self.timerNumber = secondsInt
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        
        //반복 타이머를 중지하는 방법 -> 이전에 실행되던 타이머 있으면 중지되고 다시 시작
        //이렇게 해주지 않으면 이전에 실행되던 타이머 있으면 그것과 함께 실행되어서 1초에 1씩 줄어드는게 아니라 1초에 2씩 줄어듦
        timer?.invalidate()
        
        //⭐️방법1
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){ [weak self] _ in
            guard let self = self else {return }


            if self.timerNumber > 0 {
                //반복하고싶은 코드
                self.timerNumber -= 1
                //1초 지날 때마다 슬라이더 내려가고
                self.slider.setValue(Float(self.timerNumber)/Float(60), animated: true)
                //mainLabel 초 내려가게
                self.mainLabel.text = "\(self.timerNumber) 초"
            } else {
                self.configureUI()
                //반복 타이머를 중지하는 방법 -> 0까지 실행되고 타이머를 중지시켜줘야한다
                //그렇지 않으면 0으로 된 이후에 다시 슬라이더 이동하면 start 누르지도 않았는데 자동 카운트다운된다
                self.timer?.invalidate()

                //0이 됐을 때 소리 나도록
                let systemSoundID: SystemSoundID = 1016
                AudioServicesPlaySystemSound(systemSoundID)
            }


        }
        
        //⭐️ 방법2
        //selector 활용해서 타이머 설정해주는 방법
//        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(doSomethingAfterOneSecond), userInfo: nil, repeats: true)

    }
    
    /*
    @objc func doSomethingAfterOneSecond () {
        if self.timerNumber > 0 {
            //반복하고싶은 코드
            self.timerNumber -= 1
            //1초 지날 때마다 슬라이더 내려가고
            self.slider.setValue(Float(self.timerNumber)/Float(60), animated: true)
            //mainLabel 초 내려가게
            self.mainLabel.text = "\(self.timerNumber) 초"
        } else {
            self.configureUI()
            //반복 타이머를 중지하는 방법 -> 0까지 실행되고 타이머를 중지시켜줘야한다
            //그렇지 않으면 0으로 된 이후에 다시 슬라이더 이동하면 start 누르지도 않았는데 자동 카운트다운된다
            self.timer?.invalidate()

            //0이 됐을 때 소리 나도록
            let systemSoundID: SystemSoundID = 1016
            AudioServicesPlaySystemSound(systemSoundID)
        }
    }
     */
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        configureUI()
        //타이머 시간 가는거 멈추기 : 해주지 않으면 configureUI실행되었다가 다시 타이머 실행된다
        timer?.invalidate()
    }
    
}

