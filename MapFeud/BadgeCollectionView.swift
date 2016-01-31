//
//  BadgeView.swift
//  UsaFeud
//
//  Created by knut on 10/01/16.
//  Copyright © 2016 knut. All rights reserved.
//


import Foundation
import UIKit

protocol BadgeCollectionProtocol
{
    func playBadgeChallengeAction()
    func resultMapAction()
}

class BadgeCollectionView: UIView, BadgeChallengeProtocol {
    
    
    //var hintsLeftText:UILabel!
    
    // row 1
    var mapBadge:UIImageView!
    
    var countriesBadge1:BadgeView!
    var countriesBadge2:BadgeView!
    var countriesBadge3:BadgeView!
    var countriesBadge4:BadgeView!
    var countriesBadge5:BadgeView!
    var countriesBadge6:BadgeView!
    var countriesBadge7:BadgeView!
    
    var capitalsBadge1:BadgeView!
    var capitalsBadge2:BadgeView!
    var capitalsBadge3:BadgeView!
    var capitalsBadge4:BadgeView!
    
    // row 2
    var famousPlacesBadge1:BadgeView!
    var famousPlacesBadge2:BadgeView!
    
    var flagsBadge1:BadgeView!
    var flagsBadge2:BadgeView!
    var flagsBadge3:BadgeView!
    var flagsBadge4:BadgeView!
    var flagsBadge5:BadgeView!
    var flagsBadge6:BadgeView!
    var flagsBadge7:BadgeView!
    
    var islandsBadge1:BadgeView!
    var islandsBadge2:BadgeView!
    
    var waterBadge1:BadgeView!
    var waterBadge2:BadgeView!
    
    var delegate:BadgeCollectionProtocol?
    
    let datactrl = (UIApplication.sharedApplication().delegate as! AppDelegate).datactrl
    
    var currentBadgeChallenge:BadgeChallenge?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        
        //let badgesOnOneRow:CGFloat = 4
        let badgesOnColumn:CGFloat = 3
        let marginBetweenBadges:CGFloat = 5
        let marginTopBottom:CGFloat = 6
        
        let orgHeigth:CGFloat = 429
        let orgWidth:CGFloat = 370
        
        let badgeHeight = (self.bounds.height * 0.36) - (marginBetweenBadges * (badgesOnColumn - 1)) - (marginTopBottom * 2)
        let heightToWidthRatio = orgHeigth / badgeHeight
        let badgeWidth = orgWidth / heightToWidthRatio
        //let badgeWidth = (self.bounds.width * 0.22) - (marginBetweenBadges * (badgesOnOneRow - 1)) - (marginTopBottom * 2)
        
        

        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "mapAction:")
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.enabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        
        mapBadge = UIImageView(frame: CGRectMake(marginTopBottom, marginTopBottom, badgeWidth, badgeHeight))
        mapBadge.image = UIImage(named: "map.png")
        mapBadge.userInteractionEnabled = true
        self.addSubview(mapBadge)
        mapBadge.addGestureRecognizer(singleTapGestureRecognizer)


        let onTopMargin:CGFloat = badgeWidth * 0.3


        capitalsBadge1 = BadgeView(frame: CGRectMake(mapBadge.frame.maxX + marginTopBottom, marginTopBottom, badgeWidth, badgeHeight), title: "Capitals baby class", image: "capitalsBadge1.png",questions: ["Warsaw","Rome","Paris","Madrid","London","Berlin","Athens","Amsterdam","Tokyo","Shanghai","Seoul","Moscow","Canberra","Beijing","Bangkok","Washington DC"])
        capitalsBadge1.delegate = self
        self.addSubview(capitalsBadge1)
        
        capitalsBadge2 = BadgeView(frame: CGRectMake(capitalsBadge1.frame.maxX - onTopMargin, marginTopBottom, badgeWidth, badgeHeight), title: "Capitals first class", image: "capitalsBadge2.png",questions: ["Baghdad","Abu Dhabi","Buenos Aires","Brasilia","Pretoria","Nairobi","Cairo","Cape Town","Ottawa","New Delhi","Kabul","Jakarta","Islamabad"])
        capitalsBadge2.delegate = self
        if capitalsBadge1.complete
        {
            self.addSubview(capitalsBadge2)
        }
        
        capitalsBadge3 = BadgeView(frame: CGRectMake(capitalsBadge2.frame.maxX - onTopMargin, marginTopBottom, badgeWidth, badgeHeight), title: "Capitals second class", image: "capitalsBadge3.png",questions: ["Tehran","Muscat","Damascus","Sofia","Vienna","Stockholm","Kiev","Belfast","Ankara","Quito","Havana","Bogota","Mogadishu","Dakar","Abuja"],hints:3)
        capitalsBadge3.delegate = self
        if capitalsBadge2.complete
        {
            self.addSubview(capitalsBadge3)
        }
        
        capitalsBadge4 = BadgeView(frame: CGRectMake(capitalsBadge3.frame.maxX - onTopMargin, marginTopBottom, badgeWidth, badgeHeight), title: "Capitals Sergeant class", image: "capitalsBadge4.png",questions: ["Sarajevo","Oslo","Lisbon","Budapest","Brussels","Bern","Ulan Bator","Pyongyang","Hanoi","Bishkek","Lima","Caracas","Manila","Kuala Lumpur","Kathmandu","Karachi","Colombo"],hints:4)
        capitalsBadge4.delegate = self
        if capitalsBadge3.complete
        {
            self.addSubview(capitalsBadge4)
        }
        /*
        capitalsBadge1 = BadgeView(frame: CGRectMake(mapBadge.frame.maxX + marginTopBottom, marginTopBottom, badgeWidth, badgeHeight), title: "Capitals baby class", image: "capitalsBadge1.png",questions: ["Warsaw","Rome","Paris","Madrid","London","Berlin","Athens","Amsterdam","Tokyo","Shanghai","Seoul","Moscow","Canberra","Beijing","Bangkok","Buenos Aires","Brasilia","Pretoria","Nairobi","Cairo","Cape Town","Ottawa","Washington DC"])
        capitalsBadge1.delegate = self
        self.addSubview(capitalsBadge1)
        
        capitalsBadge2 = BadgeView(frame: CGRectMake(capitalsBadge1.frame.maxX - onTopMargin, marginTopBottom, badgeWidth, badgeHeight), title: "Capitals first class", image: "capitalsBadge2.png",questions: ["Baghdad","Abu Dhabi","Vienna","Stockholm","Kiev","Belfast","Ankara","New Delhi","Kabul","Jakarta","Islamabad","Santiago","Quito","Havana","Bogota","Rabat","Mogadishu","Kinshasa","Dodoma","Dakar","Abuja"])
        capitalsBadge2.delegate = self
        if capitalsBadge1.complete
        {
            self.addSubview(capitalsBadge2)
        }
        
        capitalsBadge3 = BadgeView(frame: CGRectMake(capitalsBadge2.frame.maxX - onTopMargin, marginTopBottom, badgeWidth, badgeHeight), title: "Capitals second class", image: "capitalsBadge3.png",questions: ["Tehran","Muscat","Damascus","Sofia","Sarajevo","Oslo","Lisbon","Budapest","Brussels","Bern","Ulan Bator","Pyongyang","Hanoi","Bishkek","Lima","Caracas","Asuncion","Khartoum","Harare","Brazzaville","Addis Ababa"],hints:3)
        capitalsBadge3.delegate = self
        if capitalsBadge2.complete
        {
            self.addSubview(capitalsBadge3)
        }
        
        capitalsBadge4 = BadgeView(frame: CGRectMake(capitalsBadge3.frame.maxX - onTopMargin, marginTopBottom, badgeWidth, badgeHeight), title: "Capitals Sergeant class", image: "capitalsBadge4.png",questions: ["Doha","Valletta","Minsk","Helsinki","Copenhagen","Cardiff","Bucharest","Belgrade","Wellington","Taipei","Manila","Kuala Lumpur","Kathmandu","Karachi","Colombo","Astana","Montevideo","La Paz","N'Djamena","Maputo","Kampala","Asmara"],hints:4)
        capitalsBadge4.delegate = self
        if capitalsBadge3.complete
        {
            self.addSubview(capitalsBadge4)
        }
        */
        waterBadge1 = BadgeView(frame: CGRectMake(capitalsBadge4.frame.maxX + marginTopBottom, marginTopBottom, badgeWidth, badgeHeight),title: "Water first class", image: "waterBadge1.png",questions: ["Aral Sea","Black Sea","Caspian Sea","Red Sea","Adriatic Sea","Bay of Bengal","Bay of Biscay","Caribbean Sea","Great barrier reef","Great Bear lake","Great Slave lake","Mediterranean Sea","Persian Gulf","Lake Baikal","Lake Superior","Lake Victoria"])
        waterBadge1.delegate = self
        if capitalsBadge2.complete
        {
            self.addSubview(waterBadge1)
        }
        
        waterBadge2 = BadgeView(frame: CGRectMake(waterBadge1.frame.maxX - onTopMargin, marginTopBottom, badgeWidth, badgeHeight),title: "Water second class", image: "waterBadge1.png",questions: ["Gulf of Aden","Hudson Bay","Lake Balkhash","Lake Chad","Adaman Sea","Arafura Sea","Baffin Bay","Barents Sea","Beaufort Sea","Chukchi Sea","Coral Sea","Davis Strait","Lake Erie","Lake Titicaca","lake michigan"])
        waterBadge2.delegate = self
        if waterBadge1.complete
        {
            self.addSubview(waterBadge2)
        }
        /*
        waterBadge1 = BadgeView(frame: CGRectMake(capitalsBadge4.frame.maxX + marginTopBottom, marginTopBottom, badgeWidth, badgeHeight),title: "Water first class", image: "waterBadge1.png",questions: ["Aral Sea","Black Sea","Caspian Sea","Red Sea","Adriatic Sea","Bay of Bengal","Bay of Biscay","Caribbean Sea","Great barrier reef","Great Bear lake","Great Slave lake","Gulf of Aden","Hudson Bay","Lake Balkhash","Lake Chad","Mediterranean Sea","Persian Gulf","Lake Baikal","Lake Superior","Lake Victoria"])
        waterBadge1.delegate = self
        if capitalsBadge2.complete
        {
            self.addSubview(waterBadge1)
        }
        
        waterBadge2 = BadgeView(frame: CGRectMake(waterBadge1.frame.maxX - onTopMargin, marginTopBottom, badgeWidth, badgeHeight),title: "Water second class", image: "waterBadge1.png",questions: ["Adaman Sea","Arafura Sea","Baffin Bay","Barents Sea","Beaufort Sea","Chukchi Sea","Coral Sea","Davis Strait","Gulf of Bothnia","Gulf of Carpentaria","Gulf of Guinea","Gulf of Tonki","Lake Maracaibo","Laptev Sea","Luzon Strait","Lake Erie","Lake Titicaca","lake michigan"])
        waterBadge2.delegate = self
        if waterBadge1.complete
        {
            self.addSubview(waterBadge2)
        }
        */
        //-------------------row 2 -------------------------------
        var nextRowY = capitalsBadge1.frame.maxY + marginBetweenBadges
        
        countriesBadge1 = BadgeView(frame: CGRectMake(marginTopBottom, nextRowY, badgeWidth, badgeHeight), title: "Countries infantile class", image: "countriesBadge1.png",questions: ["England","France","Germany","Greece","Italy","Spain","Sweden","United Kingdom","Iraq","Canada","Usa","Australia","Brazil","Afghanistan","China","India","Japan","Russia","Turkey","South Africa","Egypt","Algeria"])
        countriesBadge1.delegate = self
        self.addSubview(countriesBadge1)
        
        countriesBadge2 = BadgeView(frame: CGRectMake(countriesBadge1.frame.maxX - onTopMargin, nextRowY, badgeWidth, badgeHeight), title: "Countries baby class", image: "countriesBadge2.png",questions: ["Hungary","Ireland","Netherlands","Poland","Ukraine","Iran","Syria","Bolivia","Chile","Colombia","Mexico","Peru","Indonesia","Vietnam","Azerbaijan","South Korea","Thailand","Morocco","Nigeria","Tanzania","New Zealand","Argentina","Libya","Kenya"])
        countriesBadge2.delegate = self
        if countriesBadge1.complete
        {
            self.addSubview(countriesBadge2)
        }
        
        countriesBadge3 = BadgeView(frame: CGRectMake(countriesBadge2.frame.maxX - onTopMargin, nextRowY, badgeWidth, badgeHeight), title: "Countries first class", image: "countriesBadge3.png",questions: ["Denmark","Finland","Belgium","Portugal","Scotland","Israel","Saudi Arabia","Belarus","Romania","Switzerland","Ecuador","Paraguay","Uruguay","Venezuela","Mongolia","Pakistan","Turkmenistan","Mozambique","Somalia","Angola"],hints:3)
        countriesBadge3.delegate = self
        if countriesBadge2.complete
        {
            self.addSubview(countriesBadge3)
        }
        
        countriesBadge4 = BadgeView(frame: CGRectMake(countriesBadge3.frame.maxX - onTopMargin, nextRowY, badgeWidth, badgeHeight), title: "Countries second class", image: "countriesBadge4.png",questions: ["United Arab Emirates","Yemen","Qatar","Costa Rica","El Salvador","Guatemala","Panama","Puerto Rico","Suriname","Georgia","Tunisia","Ivory Coast","Northern Ireland","Bulgaria","Croatia","Czech Republic","Norway","Cameroon"],hints:3)
        countriesBadge4.delegate = self
        if countriesBadge3.complete
        {
            self.addSubview(countriesBadge4)
        }
        
        countriesBadge5 = BadgeView(frame: CGRectMake(countriesBadge4.frame.maxX - onTopMargin, nextRowY, badgeWidth, badgeHeight), title: "Countries third class", image: "countriesBadge5.png",questions: ["Austria","Oman","Latvia","Kosovo","Rwanda","Sierra Leone","Zimbabwe","Ethiopia","Kazakhstan","North Korea","Tajikistan","Uzbekistan","Malawi","Senegal","Ghana","Chad"],hints:4)
        countriesBadge5.delegate = self
        if countriesBadge4.complete
        {
            self.addSubview(countriesBadge5)
        }
        
        
        countriesBadge6 = BadgeView(frame: CGRectMake(countriesBadge5.frame.maxX - onTopMargin, nextRowY, badgeWidth, badgeHeight), title: "Countries Sergeant class", image: "countriesBadge6.png" ,questions: ["Albania","Lithuania","Slovakia","Slovenia","Jordan","Kuwait","Brunei","Malaysia","Bangladesh","Bhutan","Kyrgyzstan","Myanmar","Guyana","Liberia","Eritrea","Uganda","Zambia"],hints:4)
        countriesBadge6.delegate = self
        if countriesBadge5.complete
        {
            self.addSubview(countriesBadge6)
        }
        
        countriesBadge7 = BadgeView(frame: CGRectMake(countriesBadge6.frame.maxX - onTopMargin, nextRowY, badgeWidth, badgeHeight), title: "Countries General class", image: "countriesBadge7.png",questions: ["Denmark","Finland","Hungary","Ireland","Netherlands","Northern Ireland","Poland","Ukraine","Iran","Syria","Bolivia","Chile","Colombia","Peru","Indonesia","Azerbaijan","South Korea","Thailand","Morocco","Nigeria","Tanzania","Congo","Cameroon"],border:0,hints:5)
        countriesBadge7.delegate = self
        if countriesBadge6.complete
        {
            self.addSubview(countriesBadge7)
        }
        
        islandsBadge1 = BadgeView(frame: CGRectMake(countriesBadge7.frame.maxX + marginTopBottom, nextRowY, badgeWidth, badgeHeight),title: "Islands first class", image: "islandsBadge1.png",questions: ["Cyprus","Greenland","Iceland","Malta","Tasmania","Cuba","Galapagos","Haiti","Jamaica","New Guinea","Sri Lanka","Madagascar","Borneo","Corsica","Newfoundland Island","Philippines","Taiwan"])
        islandsBadge1.delegate = self
        if countriesBadge3.complete
        {
            self.addSubview(islandsBadge1)
        }
        
        islandsBadge2 = BadgeView(frame: CGRectMake(islandsBadge1.frame.maxX - onTopMargin, nextRowY, badgeWidth, badgeHeight),title: "Islands second class", image: "islandsBadge2.png",questions: ["Azores","Faroe Islands","Isle of Man","Shetland","Svalbard","Hawaii","Bahamas","Barbados","Madeira","Mauritius","Seyshelles","Cape Verde","Sardinia","Sicily","Socotra","Zanzibar","Falkland islands"])
        islandsBadge2.delegate = self
        if islandsBadge1.complete
        {
            self.addSubview(islandsBadge2)
        }
        
        /*
        islandsBadge1 = BadgeView(frame: CGRectMake(countriesBadge7.frame.maxX + marginTopBottom, nextRowY, badgeWidth, badgeHeight),title: "Islands first class", image: "islandsBadge1.png",questions: ["Cyprus","Greenland","Iceland","Malta","Tasmania","Cuba","Galapagos","Haiti","Jamaica","New Guinea","Sri Lanka","Madagascar","Falkland islands","Borneo","Corsica","Newfoundland Island","Philippines","Taiwan"])
        islandsBadge1.delegate = self
        if countriesBadge3.complete
        {
            self.addSubview(islandsBadge1)
        }
        
        islandsBadge2 = BadgeView(frame: CGRectMake(islandsBadge1.frame.maxX - onTopMargin, nextRowY, badgeWidth, badgeHeight),title: "Islands second class", image: "islandsBadge2.png",questions: ["Azores","Bornholm","Faroe Islands","Isle of Man","Shetland","Svalbard","Socotra and Abd al Kuri","Hawaii","Bahamas","Barbados","Madeira","Mauritius","Seyshelles","Cape Verde","Sardinia","Sicily","Socotra","Zanzibar"])
        islandsBadge2.delegate = self
        if islandsBadge1.complete
        {
            self.addSubview(islandsBadge2)
        }
        */
        
        //-------------------row 3-------------------------------------
        nextRowY = countriesBadge1.frame.maxY + marginBetweenBadges
        
        flagsBadge1 = BadgeView(frame: CGRectMake(marginTopBottom, nextRowY, badgeWidth, badgeHeight),title: "Flags first class", image: "flagsBadge1.png",questions: ["coaEngland","coaFrance","coaGermany","coaGreece","coaItaly","coaSpain","coaSweden","coaUnitedKingdom","coaIraq","coaCanada","coaUsa","coaChina","coaIndia","coaJapan","coaRussia"])
        flagsBadge1.delegate = self
        if countriesBadge4.complete
        {
            self.addSubview(flagsBadge1)
        }
        
        flagsBadge2 = BadgeView(frame: CGRectMake(flagsBadge1.frame.maxX - onTopMargin, nextRowY, badgeWidth, badgeHeight),title: "Flags second class", image: "flagsBadge2.png",questions: ["coaAfghanistan","coaDenmark","coaHungary","coaIreland","coaNetherlands","coaPoland","coaUkraine","coaIran","coaColombia","coaMexico","coaVietnam","coaNewZealand","coaAustralia","coaArgentina","coaBrazil"],hints:3)
        flagsBadge2.delegate = self
        if flagsBadge1.complete
        {
            self.addSubview(flagsBadge2)
        }
            
        flagsBadge3 = BadgeView(frame: CGRectMake(flagsBadge2.frame.maxX - onTopMargin, nextRowY, badgeWidth, badgeHeight),title: "Flags third class", image: "flagsBadge3.png",questions: ["coaVenezuela","coaTurkmenistan","coaMozambique","coaIndonesia","coaChile","coaNorthernIreland","coaSouthKorea","coaMorocco","coaNigeria","coaPortugal","coaPakistan","coaTurkey","coaSouthAfrica","coaKenya","coaEgypt","coaIsrael"],hints:4)
        flagsBadge3.delegate = self
        if flagsBadge2.complete
        {
            self.addSubview(flagsBadge3)
        }
            
        flagsBadge4 = BadgeView(frame: CGRectMake(flagsBadge3.frame.maxX - onTopMargin, nextRowY, badgeWidth, badgeHeight),title: "Flags Sergeant class", image: "flagsBadge4.png",questions: ["coaAlgeria","coaFinland","coaBolivia","coaPeru","coaAzerbaijan","coaBelgium","coaBulgaria","coaCroatia","coaCzechRepublic","coaNorway","coaScotland","coaSwitzerland","coaEcuador","coaParaguay","coaUruguay"],hints:5)
        flagsBadge4.delegate = self
        if flagsBadge3.complete
        {
            self.addSubview(flagsBadge4)
        }
        
        flagsBadge5 = BadgeView(frame: CGRectMake(flagsBadge3.frame.maxX - onTopMargin, nextRowY, badgeWidth, badgeHeight),title: "Flags General class", image: "flagsBadge4.png",questions: ["coaAustria","coaYemen","coaQatar","coaElSalvador","coaGuatemala","coaPanama","Georgia","coaNorthKorea","coaSenegal","coaIvoryCoast","coaGhana","coaEritrea","coaChad","coaSomalia","coaAngola","coaTanzania","coaCameroon","coaThailand","coaBelarus","coaSaudiArabia","coaRomania","coaCongo","coaSyria"],hints:5)
        flagsBadge5.delegate = self
        if flagsBadge4.complete
        {
            self.addSubview(flagsBadge5)
        }

        

        famousPlacesBadge1 = BadgeView(frame: CGRectMake(flagsBadge5.frame.maxX + marginTopBottom, nextRowY, badgeWidth, badgeHeight),title: "Places first class",image: "famousPlacesBadge1.png",questions: ["Cape Canaveral","Cape Horn","Mecca","Barcelona","Hamburg","Istanbul","Munich","Palermo","Venice","Bangalore","Lahore","Melbourne","Kolkata(Calcutta)","Saint Petersburg","Sydney"])
        famousPlacesBadge1.delegate = self
        if countriesBadge4.complete
        {
            self.addSubview(famousPlacesBadge1)
        }
        
        famousPlacesBadge2 = BadgeView(frame: CGRectMake(famousPlacesBadge1.frame.maxX - onTopMargin, nextRowY, badgeWidth, badgeHeight),title: "Places first class",image: "famousPlacesBadge2.png",questions: ["Cape Agulhas","Cape of good hope","Dar es Salaam","Medina","Donetsk","Glasgow","Krakow","Turin(Torino)","Lhasa","Perth","Mumbai","Auckland","Gothenburg"])
        famousPlacesBadge2.delegate = self
        if famousPlacesBadge1.complete
        {
            self.addSubview(famousPlacesBadge2)
        }
    }
    
    func mapAction(gesture:UITapGestureRecognizer)
    {
        delegate?.resultMapAction()
    }
    
    func setBadgeChallenge(badgeChallenge:BadgeChallenge)
    {
        currentBadgeChallenge = badgeChallenge
        delegate?.playBadgeChallengeAction()
        
    }
    
}