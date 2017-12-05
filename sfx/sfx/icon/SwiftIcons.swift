import UIKit

public extension UIImage {
    
    /**
     This init function sets the icon to UIImage
     
     - Parameter icon: The icon for the UIImage
     - Parameter size: CGSize for the icon
     - Parameter textColor: Color for the icon
     - Parameter backgroundColor: Background color for the icon
     
     - Since: 1.0.0
    */
    public convenience init(icon: FontType, size: CGSize, textColor: UIColor = .black, backgroundColor: UIColor = .clear) {
        FontLoader.loadFontIfNeeded(fontType: icon)
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        let fontAspectRatio: CGFloat = 1.28571429
        let fontSize = min(size.width / fontAspectRatio, size.height)
        let font = UIFont(name: icon.fontName(), size: fontSize)
        assert(font != nil, icon.errorAnnounce())
        let attributes = [NSAttributedStringKey.font: font!, NSAttributedStringKey.foregroundColor: textColor, NSAttributedStringKey.backgroundColor: backgroundColor, NSAttributedStringKey.paragraphStyle: paragraph]
        
        let attributedString = NSAttributedString(string: icon.text!, attributes: attributes)
        UIGraphicsBeginImageContextWithOptions(size, false , 0.0)
        attributedString.draw(in: CGRect(x: 0, y: (size.height - fontSize) * 0.5, width: size.width, height: fontSize))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let image = image {
            self.init(cgImage: image.cgImage!, scale: image.scale, orientation: image.imageOrientation)
        } else {
            self.init()
        }
    }
    
    
    /**
     This init function adds support for stacked icons. For details check [Stacked Icons](http://fontawesome.io/examples/#stacked)
     
     - Parameter bgIcon: Background icon of the stacked icons
     - Parameter bgTextColor: Color for the background icon
     - Parameter bgBackgroundColor: Background color for the background icon
     - Parameter topIcon: Top icon of the stacked icons
     - Parameter topTextColor: Color for the top icon
     - Parameter bgLarge: Set if the background icon should be bigger
     - Parameter size: CGSize for the UIImage
     
     - Since: 1.0.0
     */
    public convenience init(bgIcon: FontType, bgTextColor: UIColor = .black, bgBackgroundColor: UIColor = .clear, topIcon: FontType, topTextColor: UIColor = .black, bgLarge: Bool? = true, size: CGSize? = nil) {
        
        FontLoader.loadFontIfNeeded(fontType: bgIcon)
        FontLoader.loadFontIfNeeded(fontType: topIcon)
        
        let bgSize: CGSize!
        let topSize: CGSize!
        let bgRect: CGRect!
        let topRect: CGRect!
        
        if bgLarge! {
            topSize = size ?? CGSize(width: 30, height: 30)
            bgSize = CGSize(width: 2 * topSize.width, height: 2 * topSize.height)
            
        } else {
            
            bgSize = size ?? CGSize(width: 30, height: 30)
            topSize = CGSize(width: 2 * bgSize.width, height: 2 * bgSize.height)
        }
        
        let bgImage = UIImage.init(icon: bgIcon, size: bgSize, textColor: bgTextColor)
        let topImage = UIImage.init(icon: topIcon, size: topSize, textColor: topTextColor)
        
        if bgLarge! {
            bgRect = CGRect(x: 0, y: 0, width: bgSize.width, height: bgSize.height)
            topRect = CGRect(x: topSize.width/2, y: topSize.height/2, width: topSize.width, height: topSize.height)
            UIGraphicsBeginImageContextWithOptions(bgImage.size, false, 0.0)
            
        } else {
            topRect = CGRect(x: 0, y: 0, width: topSize.width, height: topSize.height)
            bgRect = CGRect(x: bgSize.width/2, y: bgSize.height/2, width: bgSize.width, height: bgSize.height)
            UIGraphicsBeginImageContextWithOptions(topImage.size, false, 0.0)
            
        }
        
        bgImage.draw(in: bgRect)
        topImage.draw(in: topRect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let image = image {
            self.init(cgImage: image.cgImage!, scale: image.scale, orientation: image.imageOrientation)
        } else {
            self.init()
        }
    }
}


private class FontLoader {
    
    /**
     This utility function helps loading the font if not loaded already
     
     - Parameter fontType: The type of the font
     
     */
    static func loadFontIfNeeded(fontType : FontType) {
        let familyName = fontType.familyName()
        let fileName = fontType.fileName()
        
        if UIFont.fontNames(forFamilyName: familyName).count == 0 {
            let bundle = Bundle(for: FontLoader.self)
            var fontURL: URL!
            let identifier = bundle.bundleIdentifier
            
            if (identifier?.hasPrefix("org.cocoapods"))! {
                fontURL = bundle.url(forResource: fileName, withExtension: "ttf", subdirectory: "SwiftIcons.bundle")
            } else {
                fontURL = bundle.url(forResource: fileName, withExtension: "ttf")!
            }
            
            let data = try! Data(contentsOf: fontURL)
            let provider = CGDataProvider(data: data as CFData)
            let font = CGFont(provider!)
            
            var error: Unmanaged<CFError>?
            if !CTFontManagerRegisterGraphicsFont(font!, &error) {
                let errorDescription: CFString = CFErrorCopyDescription(error!.takeUnretainedValue())
                let nsError = error!.takeUnretainedValue() as AnyObject as! NSError
                NSException(name: NSExceptionName.internalInconsistencyException, reason: errorDescription as String, userInfo: [NSUnderlyingErrorKey: nsError]).raise()
            }
        }
    }
}

protocol FontProtocol {
    func errorAnnounce() -> String
    func familyName() -> String
    func fileName() -> String
    func fontName() -> String
}


/**
 FontType Enum

 ````
 case dripicon
 case emoji()
 case fontAwesome()
 case googleMaterialDesign()
 case icofont()
 case ionicons()
 case linearIcons()
 case mapicons()
 case openIconic()
 case state()
 case weather()
 ````
*/
public enum FontType: FontProtocol {
    case emoji(EmojiType)
    func fontName() -> String {
        var fontName: String
        switch self {
        case .emoji(_):
            fontName = "emoji"
            break
        }
        return fontName
    }
    
    /**
     This function returns the file name from Source folder using font type
     */
    func fileName() -> String {
        var fileName: String
        switch self {
        case .emoji(_):
            fileName = "Emoji"
            break
        }
        return fileName
    }
    
    /**
     This function returns the font family name using font type
     */
    func familyName() -> String {
        var familyName: String
        switch self {
        case .emoji(_):
            familyName = "emoji"
            break
        }
        return familyName
    }
    
    /**
     This function returns the error for a font type
     */
    func errorAnnounce() -> String {
        let message = " FONT - not associated with Info.plist when manual installation was performed";
        let fontName = self.fontName().uppercased()
        let errorAnnounce = fontName.appending(message)
        return errorAnnounce
    }
    
    /**
     This function returns the text for the icon
     */
    public var text: String? {
        var text: String
        
        switch self {
        case let .emoji(icon):
            text = icon.text!
            break
        }
        
        return text
    }
}
/**
 List of all icons in emoji
 
 - Author - [John Slegers](http://www.johnslegers.com/)
 
 ## Important Notes ##
 For icons, please visit [emoji](http://jslegers.github.io/emoji-icon-font/)
 */
public enum EmojiType: Int {
    static var count: Int {
        return emojiIcons.count
    }
    
    public var text: String? {
        return emojiIcons[rawValue]
    }
    
    case aceOfClubs, aceOfDiamonds, aceOfHearts, aceOfSpades, addressbook, airplane, alarm, aleph, alien, ampersand, anchor, animalAnt, animalBactrianCamel, animalBug, animalCat, animalCow, animalDolphin, animalDromedaryCamel, animalGoat, animalHorse, animalPig, animalRabbit, animalRooster, animalSnail, ankh, apple, arrowDown, arrowDownLeft, arrowDownRight, arrowForward, arrowLeft, arrowLeftRight, arrowRedo, arrowReply, arrowRight, arrowUndo, arrowUp, arrowUpDown, arrowUpLeft, arrowUpRight, asclepius, asteriskFive, asteriskSix, at, atSymbol, atom, baby, babyBottle, backward, balloon, bank, banknote, baseball, battery, beach, bell, bicycle, bicyclist, billiards, biohazard, blackFlorette, bolt, bomb, book, bookOpen, bookmark, books, bouquet, bowling, braceLeft, braceRight, bread, brightness, browserChrome, browserFirefox, browserIe, browserOpera, browserSafari, building, bullhorn, bullseye, bus, busFront, cabinet, cactus, caduceus, cake, calculator, calendarDay, calendarMonth, cameraMovie, cancel, candle, candy, car, carFront, caretDown, caretLeft, caretRight, caretUp, castle, celticCross, chair, chart, chartDown, chartLine, chartUp, check, checkboxChecked, checkboxPartial, checkboxUnchecked, chessBlackBishop, chessBlackKing, chessBlackKnight, chessBlackPawn, chessBlackQueen, chessBlackRook, chessWhiteBishop, chessWhiteKing, chessWhiteKnight, chessWhitePawn, chessWhiteQueen, chessWhiteRook, chessboard, chiRho, chickenLeg, christmasTree, church, cinema, circle, circleArrowDown, circleArrowLeft, circleArrowRight, circleArrowUp, circleOpen, circus, clipboard, clock, close, cloud, clubs, coffin, comet, command, computerNetwork, constructionWorker, contrast, convenienceStore, cooking, copy, copyright, creditcard, crossOfJerusalem, crossOfLorraine, crossOrthodox, crossPommee, crossedSwords, crosshairs, crown, currencyDollar, currencyEuro, currencyExchange, currencyPound, dagger, dancing, database, death, diamond, diamonds, die, digg, digitEight, digitFive, digitFour, digitNine, digitOne, digitSeven, digitSix, digitThree, digitTwo, digitZero, disk, divide, dna, donut, drinkBeer, drinkCocktail, drinkCoffee, drinkTropical, drinkWine, droplet, ear, eject, electricCord, enter, envelope, envelopeStamped, exclamationMark, explosion, eye, eyeglasses, faceBaby, faceBear, faceBoy, faceCallcenter, faceChihuahua, faceGirl, faceHamster, faceKitty, faceMan, faceManWithTurban, faceMonkey, faceOldChineseMan, facePrincess, faceSantaClaus, faceWoman, factory, family, farsi, ferrisWheel, file, fileImage, fileText, film, filmReel, fire, fireworks, first, flag, flagCheckered, flagOpen, flashlight, fleurDeLis, floppy, florette, flower, folder, folderOpen, fontSize, foodChicken, foodHamburger, foodIceCream, foodPizza, foodRice, foodSpaghetti, footballAmerican, footballSoccer, footprints, forbidden, forkKnife, forkKnifePlate, forward, fountain, fourCorners, fourLeafClover, fries, fuelPump, gClef, garbageCan, gear, gearNoHub, genderFemale, genderFemaleFemale, genderMale, genderMaleFemale, genderMaleMale, genderNonBinary, genderTransgender, ghost, gift, gingerbread, globe2, globeMeridians, graduation, grapes, guardIcon, guitar, hammer, hammerAndPick, hammerSickle, hammerWrench, hand, handFist, handbag, hardDisk, headphone, headstone, heart, heartBeating, heartBroken, heartOpen, heartRibbon, heartTilted, heartWithArrow, hearts, helm, herb, hexagon, highHeeledShoes, home, hotel, hourglass, iceSkater, imp, inbox, infinity, jackOLantern, joystick, key, keyAlt, keyboard, keyboardWireless, khanda, kiss, knife, label, laptop, last, lastfm, latinCross, latinCrossOutline, leaf, leftLuggage, lemon, letterA, letterB, letterC, letterD, letterE, letterF, letterG, letterH, letterI, letterJ, letterK, letterL, letterM, letterN, letterO, letterP, letterQ, letterR, letterS, letterT, letterU, letterV, letterW, letterX, letterY, letterZ, lightbulb, link, linux, lipstick, lock, lockOpen, lollipop, loop, loopAlt, malteseCross, manAndMan, manAndWoman, mapleLeaf, maximizeWindow, medalMilitary, medalSports, menu, microphone, microscope, minimize, minus, moneyBag, monitor, moonFirstQuarter, moonFull, moonLastQuarter, moonNew, moonWaningCrescent, moonWaningGibbous, moonWaxingCrescent, moonWaxingGibbous, motorbike, mouse, movie, multiply, mushroom, musicEighthNote, musicEigthNotes, musicPlayer, musicQuarterNote, musicSixteenthNotes, musicTrumpet, musicViolin, newspaper, nextPage, noEntry, notebook, notepad, number, nutAndBolt, om, omega, osAndroid, osApple, osWindows, outbox, outfitBikini, outfitDress, outfitNecktie, outfitShirt, pager, palette, panda, paperclip, parenthesisLeft, parenthesisRight, passportControl, pause, pawPrints, pcDesktop, pcOld, peace, peaceDove, pear, pedestrian, pen, pencil, pentagon, pentagram, pentagramInverted, percent, performingArts, permanentPaper, perthousand, phone, phoneLocation, phoneMobile, phoneReceiver, photoCamera, photoCameraFlash, piano, pick, picture, pieChart, pieChartReverse, pill, pistol, play, plus, pointDown, pointLeft, pointRight, pointUp, potFood, previousPage, printScreen, printer, projector, purse, pushpin, questionMark, radiation, radio, radioChecked, rainbow, record, recycle, registered, restroom, retrograde, riceBall, ring, rocket, rollercoaster, rotateCcw, rotateCcwSide, rotateCw, rotateCwSide, ruler, ruler2, running, sandals, satelliteDisk, saxophone, scales, school, scissors, searchLeft, searchRight, shamrock, shield, shieldWithCross, shuffle, skier, skull, skullAndBones, slotMachine, smiley, smileyCool, smileyEvil, smileyGrin, smileyHappy, smileySad, smoking, smokingForbidden, snake, snowboarding, snowflake, snowman, spades, speechBubble, spider, spider7Web, spy, square, squareBracketLeft, squareBracketRight, squareMinus, squarePlus, stackWindow, star, starAndCrescent, starCircled, starEightPoints, starOfDavid, starOpen, starShooting, steamingBowl, stop, stopwatch, suitcase, sun, sunglasses, sushi, swastikaLeft, swastikaRight, swimming, syringe, tao, tape, target, telescope, television, temple, tennis, tent, thumbsDown, thumbsUp, ticket, tomato3, tophat, trafficLight, tree, treePalm, treePine, trophy, truck, umbrella, user, users, videoCamera, videogame, vk, volume, volumeHigh, volumeLow, volumeMute, warning, watch, waterWave, webBehance, webBlogger, webCircles, webDelicious, webDeviantart, webDribbble, webDropbox, webDrupal, webEvernote, webFacebook, webFlattr, webFlickr, webForrst, webFoursquare, webGit, webGithub, webGoogleDrive, webGoogleplus, webInstagram, webJoomla, webLastfm, webLinkedin, webMixi, webPaypal, webPicasa, webPicassa, webPinterest, webQq, webRdio, webReddit, webRenren, webSinaWeibo, webSkype, webSmashing, webSoundcloud, webSpotify, webStackoverflow, webSteam, webStumbleupon, webTumblr, webTwitter, webVimeo, webVine, webVk, webWordpress, webYelp, weighlifting, wheelOfDharma, wheelchair, womanAndWoman, worldMap, wrench, yen, youtube
}

private let emojiIcons = ["\u{1f0d1}", "\u{1f0c1}", "\u{1f0b1}", "\u{1f0a1}", "\u{1f4d2}", "\u{2708}", "\u{23f0}", "\u{2135}", "\u{1f47d}", "\u{ff06}", "\u{2693}", "\u{1f41c}", "\u{1f42b}", "\u{1f41b}", "\u{1f408}", "\u{1f404}", "\u{1f42c}", "\u{1f42a}", "\u{1f410}", "\u{1f40e}", "\u{1f416}", "\u{1f407}", "\u{1f413}", "\u{1f40c}", "\u{2625}", "\u{1f34e}", "\u{2b07}", "\u{2b0b}", "\u{2b0a}", "\u{2ba9}", "\u{2b05}", "\u{2b0c}", "\u{2bab}", "\u{2ba8}", "\u{27a1}", "\u{2baa}", "\u{2b06}", "\u{2b0d}", "\u{2b09}", "\u{2b08}", "\u{2695}", "\u{ff0a}", "\u{2731}", "\u{ff3c}", "\u{ff20}", "\u{269b}", "\u{1f6bc}", "\u{1f37c}", "\u{23ea}", "\u{1f388}", "\u{1f3e6}", "\u{1f4b5}", "\u{26be}", "\u{1f50b}", "\u{26f1}", "\u{1f514}", "\u{1f6b2}", "\u{1f6b4}", "\u{1f3b1}", "\u{2623}", "\u{273f}", "\u{26a1}", "\u{1f4a3}", "\u{1f4d5}", "\u{1f4d6}", "\u{1f516}", "\u{1f4da}", "\u{1f490}", "\u{1f3b3}", "\u{ff5b}", "\u{fe5c}", "\u{1f35e}", "\u{1f506}", "\u{e62a}", "\u{e62b}", "\u{e62c}", "\u{e62d}", "\u{e62e}", "\u{1f3e2}", "\u{1f56b}", "\u{25ce}", "\u{1f68c}", "\u{1f68d}", "\u{1f5c4}", "\u{1f335}", "\u{2624}", "\u{1f382}", "\u{1f5a9}", "\u{1f4c6}", "\u{1f4c5}", "\u{1f3a5}", "\u{1f5d9}", "\u{1f56f}", "\u{1f36c}", "\u{1f697}", "\u{1f698}", "\u{23f7}", "\u{23f4}", "\u{23f5}", "\u{23f6}", "\u{1f3f0}", "\u{1f548}", "\u{1f4ba}", "\u{1f4ca}", "\u{1f4c9}", "\u{1f5e0}", "\u{1f4c8}", "\u{2714}", "\u{2611}", "\u{25a3}", "\u{2610}", "\u{265d}", "\u{265a}", "\u{265e}", "\u{265f}", "\u{265b}", "\u{265c}", "\u{2657}", "\u{2654}", "\u{2658}", "\u{2659}", "\u{2655}", "\u{2656}", "\u{2593}", "\u{2627}", "\u{1f357}", "\u{1f384}", "\u{26ea}", "\u{1f3a6}", "\u{23fa}", "\u{2b8b}", "\u{2b88}", "\u{2b8a}", "\u{2b89}", "\u{25cb}", "\u{1f3aa}", "\u{1f4cb}", "\u{1f553}", "\u{2297}", "\u{2601}", "\u{2663}", "\u{26b0}", "\u{2604}", "\u{2318}", "\u{1f5a7}", "\u{1f477}", "\u{25d1}", "\u{1f3ea}", "\u{1f373}", "\u{1f5d0}", "\u{a9}", "\u{1f4b3}", "\u{2629}", "\u{2628}", "\u{2626}", "\u{1f542}", "\u{2694}", "\u{2316}", "\u{1f451}", "\u{ff04}", "\u{20ac}", "\u{1f4b1}", "\u{ffe1}", "\u{1f5e1}", "\u{1f483}", "\u{26c3}", "\u{1f571}", "\u{1f48e}", "\u{2666}", "\u{1f3b2}", "\u{f1a6}", "\u{ff18}", "\u{ff15}", "\u{ff14}", "\u{ff19}", "\u{ff11}", "\u{ff17}", "\u{ff16}", "\u{ff13}", "\u{ff12}", "\u{ff10}", "\u{1f4bf}", "\u{2797}", "\u{26d3}", "\u{1f369}", "\u{1f37a}", "\u{1f378}", "\u{2615}", "\u{1f379}", "\u{1f377}", "\u{1f4a7}", "\u{1f442}", "\u{23cf}", "\u{1f50c}", "\u{2386}", "\u{2709}", "\u{1f583}", "\u{ff01}", "\u{1f4a5}", "\u{1f441}", "\u{1f453}", "\u{1f476}", "\u{1f43b}", "\u{1f466}", "\u{1f481}", "\u{1f436}", "\u{1f467}", "\u{1f439}", "\u{1f431}", "\u{1f468}", "\u{1f473}", "\u{1f435}", "\u{1f474}", "\u{1f478}", "\u{1f385}", "\u{1f469}", "\u{1f3ed}", "\u{1f46a}", "\u{262b}", "\u{1f3a1}", "\u{1f5cb}", "\u{1f5bb}", "\u{1f5b9}", "\u{1f39e}", "\u{2707}", "\u{1f525}", "\u{1f386}", "\u{23ee}", "\u{2691}", "\u{1f3c1}", "\u{2690}", "\u{1f526}", "\u{269c}", "\u{1f4be}", "\u{2740}", "\u{2698}", "\u{1f5c0}", "\u{1f5c1}", "\u{1f5db}", "\u{1f414}", "\u{1f354}", "\u{1f368}", "\u{1f355}", "\u{1f35a}", "\u{1f35d}", "\u{1f3c8}", "\u{26bd}", "\u{1f463}", "\u{1f6ab}", "\u{1f374}", "\u{1f37d}", "\u{23e9}", "\u{26f2}", "\u{26f6}", "\u{1f340}", "\u{1f35f}", "\u{26fd}", "\u{1d11e}", "\u{1f5d1}", "\u{2699}", "\u{26ed}", "\u{2640}", "\u{26a2}", "\u{2642}", "\u{26a4}", "\u{26a3}", "\u{26a7}", "\u{26a6}", "\u{1f47b}", "\u{1f381}", "\u{1f36a}", "\u{1f30d}", "\u{1f310}", "\u{1f393}", "\u{1f347}", "\u{1f482}", "\u{1f3b8}", "\u{1f528}", "\u{2692}", "\u{262d}", "\u{1f6e0}", "\u{270b}", "\u{270a}", "\u{1f45c}", "\u{1f5b4}", "\u{1f3a7}", "\u{26fc}", "\u{2665}", "\u{1f493}", "\u{1f494}", "\u{2661}", "\u{1f49d}", "\u{2765}", "\u{1f498}", "\u{1f495}", "\u{2388}", "\u{1f33f}", "\u{2b23}", "\u{1f460}", "\u{1f3e0}", "\u{1f3e8}", "\u{23f3}", "\u{26f8}", "\u{1f47f}", "\u{1f4e5}", "\u{221e}", "\u{1f383}", "\u{1f579}", "\u{1f511}", "\u{1f5dd}", "\u{1f5ae}", "\u{2328}", "\u{262c}", "\u{1f48b}", "\u{1f52a}", "\u{1f3f7}", "\u{1f4bb}", "\u{23ed}", "\u{e632}", "\u{271d}", "\u{271f}", "\u{1f342}", "\u{1f6c5}", "\u{1f34b}", "\u{ff21}", "\u{ff22}", "\u{ff23}", "\u{ff24}", "\u{ff25}", "\u{ff26}", "\u{ff27}", "\u{ff28}", "\u{ff29}", "\u{ff2a}", "\u{ff2b}", "\u{ff2c}", "\u{ff2d}", "\u{ff2e}", "\u{ff2f}", "\u{ff30}", "\u{ff31}", "\u{ff32}", "\u{ff34}", "\u{ff35}", "\u{ff36}", "\u{ff37}", "\u{ff38}", "\u{ff39}", "\u{59}", "\u{ff3a}", "\u{1f4a1}", "\u{1f517}", "\u{1f427}", "\u{1f484}", "\u{1f50f}", "\u{1f513}", "\u{1f36d}", "\u{1f501}", "\u{1f503}", "\u{2720}", "\u{1f46c}", "\u{1f46b}", "\u{1f341}", "\u{1f5d6}", "\u{1f396}", "\u{1f3c5}", "\u{2630}", "\u{1f3a4}", "\u{1f52c}", "\u{1f5d5}", "\u{2796}", "\u{1f4b0}", "\u{1f5b5}", "\u{1f313}", "\u{1f315}", "\u{1f317}", "\u{1f311}", "\u{1f318}", "\u{1f316}", "\u{1f312}", "\u{1f314}", "\u{1f3cd}", "\u{1f5b1}", "\u{1f3ac}", "\u{2716}", "\u{1f344}", "\u{266a}", "\u{266b}", "\u{1f4fe}", "\u{2669}", "\u{266c}", "\u{1f3ba}", "\u{1f3bb}", "\u{1f4f0}", "\u{2398}", "\u{26d4}", "\u{1f4d3}", "\u{1f5ca}", "\u{ff03}", "\u{1f529}", "\u{1f549}", "\u{2126}", "\u{e618}", "\u{f8ff}", "\u{e61f}", "\u{1f4e4}", "\u{1f459}", "\u{1f457}", "\u{1f454}", "\u{1f455}", "\u{1f4df}", "\u{1f3a8}", "\u{1f43c}", "\u{1f4ce}", "\u{ff08}", "\u{ff09}", "\u{1f6c2}", "\u{23f8}", "\u{1f43e}", "\u{1f5a5}", "\u{1f5b3}", "\u{262e}", "\u{1f54a}", "\u{1f350}", "\u{1f6b6}", "\u{1f58a}", "\u{270f}", "\u{2b1f}", "\u{26e4}", "\u{26e7}", "\u{ff05}", "\u{1f3ad}", "\u{267e}", "\u{2030}", "\u{260e}", "\u{2706}", "\u{1f4f1}", "\u{1f4de}", "\u{1f4f7}", "\u{1f4f8}", "\u{1f3b9}", "\u{26cf}", "\u{1f5bc}", "\u{25d5}", "\u{25d4}", "\u{1f48a}", "\u{1f52b}", "\u{25b6}", "\u{271a}", "\u{261f}", "\u{261c}", "\u{261e}", "\u{261d}", "\u{1f372}", "\u{2397}", "\u{2399}", "\u{1f5b6}", "\u{1f4fd}", "\u{1f45b}", "\u{1f4cc}", "\u{ff1f}", "\u{2622}", "\u{1f4fb}", "\u{1f518}", "\u{1f308}", "\u{2609}", "\u{267b}", "\u{ae}", "\u{1f6bb}", "\u{211e}", "\u{1f359}", "\u{1f48d}", "\u{1f680}", "\u{1f3a2}", "\u{21ba}", "\u{27f3}", "\u{21bb}", "\u{27f2}", "\u{1f4d0}", "\u{1f4cf}", "\u{1f3c3}", "\u{1f461}", "\u{1f4e1}", "\u{1f3b7}", "\u{2696}", "\u{1f3eb}", "\u{2702}", "\u{1f50d}", "\u{1f50e}", "\u{2618}", "\u{1f6e1}", "\u{26e8}", "\u{1f500}", "\u{26f7}", "\u{1f480}", "\u{2620}", "\u{1f3b0}", "\u{263a}", "\u{1f60e}", "\u{1f608}", "\u{1f604}", "\u{1f603}", "\u{2639}", "\u{1f6ac}", "\u{1f6ad}", "\u{1f40d}", "\u{1f3c2}", "\u{2744}", "\u{2603}", "\u{2660}", "\u{1f4ac}", "\u{1f577}", "\u{1f578}", "\u{1f575}", "\u{25a0}", "\u{ff3b}", "\u{ff3d}", "\u{229f}", "\u{229e}", "\u{ff33}", "\u{2605}", "\u{262a}", "\u{272a}", "\u{2734}", "\u{2721}", "\u{2606}", "\u{1f320}", "\u{1f35c}", "\u{23f9}", "\u{23f1}", "\u{1f4bc}", "\u{2600}", "\u{1f576}", "\u{1f363}", "\u{534d}", "\u{5350}", "\u{1f3ca}", "\u{1f489}", "\u{262f}", "\u{1f5ad}", "\u{1f3af}", "\u{1f52d}", "\u{1f4fa}", "\u{26e9}", "\u{1f3be}", "\u{26fa}", "\u{1f44e}", "\u{1f44d}", "\u{1f39f}", "\u{1f345}", "\u{1f3a9}", "\u{1f6a6}", "\u{1f333}", "\u{1f334}", "\u{1f332}", "\u{1f3c6}", "\u{1f69a}", "\u{2602}", "\u{1f464}", "\u{1f465}", "\u{1f4f9}", "\u{1f3ae}", "\u{f189}", "\u{1f508}", "\u{1f50a}", "\u{1f509}", "\u{1f3e1}", "\u{26a0}", "\u{231a}", "\u{1f30a}", "\u{e61a}", "\u{e626}", "\u{e61b}", "\u{e629}", "\u{e622}", "\u{e600}", "\u{e610}", "\u{e635}", "\u{e611}", "\u{e604}", "\u{e612}", "\u{e620}", "\u{e61e}", "\u{e633}", "\u{e625}", "\u{e624}", "\u{e62f}", "\u{e605}", "\u{e60f}", "\u{e631}", "\u{e60b}", "\u{e608}", "\u{e619}", "\u{e616}", "\u{e617}", "\u{e621}", "\u{e606}", "\u{e60e}", "\u{e60c}", "\u{e628}", "\u{e614}", "\u{e615}", "\u{e613}", "\u{e61d}", "\u{e627}", "\u{e60d}", "\u{e601}", "\u{e623}", "\u{e60a}", "\u{e607}", "\u{e603}", "\u{e602}", "\u{f1ca}", "\u{e61c}", "\u{e630}", "\u{e634}", "\u{1f3cb}", "\u{2638}", "\u{267f}", "\u{1f46d}", "\u{1f5fa}", "\u{1f527}", "\u{ffe5}", "\u{e636}"]

