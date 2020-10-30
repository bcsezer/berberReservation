//
//  hakkimizdaViewController.swift
//  berber
//
//  Created by Cem Sezeroglu on 23.10.2020.
//

import UIKit

class hakkimizdaViewController: UIViewController {

    @IBOutlet weak var bilgi: UITextView!
    @IBOutlet weak var misyonText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        misyonText.text = "Kaliteli hizmet anlayışımızla müşterilerimize maksimum hizmeti sağlayabilmek için By Makas Erkek Kuaförü çalışanları olarak şunları benimsedik; \n - Müşterilerimizi güler yüzle karşılamak \n -Müşterilerimizle doğru iletişim kurmak \n -Müşteri ihtiyaçlarını kusursuz bir şekilde sağlamak \n -Çalışanlarımızı gerek kişisel gerekse mesleki açıdan daha iyi yerlere ulaştırmak.\n - Gelişen ve  sürekli yenilenen sektördeki çalışmaları yakından takip ederek, gelişmelerin paralelinde By Makas Erkek Kuaförü Salonunu yenilemek, aynı zamanda bu alanda yapılan Ar-Ge çalışmalarına katkıda bulunmak öncelikli hedeflerimizdir."
        
        bilgi.text = "Uzman kadromuz ile müşterilerimize her zaman en iyi hizmeti sunan,sürekli gelişmeleri, yenilikleri takip ederek sizlere ulaştıran, değerli görüşlerinizi her zaman dikkate alan saygın ve gelişmelere açık bir kuruluş olmak,her zaman en iyiyi kaliteliyi sizlere ulaştırmaya çalışmak temel vizyonumuzdur.erkek kuaförü ünitemizde size özel saç tasarımlarının yanı sıra saçınıza dair her türlü bakım , kesim ve en güzel günlerinizde sizi herkesten farklı ve özel kılacak saç modelleriyle hizmetinizdeyiz.Değişmeyen profesyonel kadro hızlı ve kaliteli iş prensibi ile erkek kuaför ünitemizde ayrıca kaş dizaynı profesyonel makyaj uygulaması, manikür, pedikür, gibi işlemlerinizi de evinizde hizmet almışcanıza rahat ve mutlu bir şekilde yaptırabilirsiniz"
    }

    

}
