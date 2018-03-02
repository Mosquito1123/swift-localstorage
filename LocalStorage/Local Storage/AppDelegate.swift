//
//  AppDelegate.swift
//  localstorage
//
//  Created by Günther Eberl on 01.01.18.
//  Copyright © 2018 Günther Eberl. All rights reserved.
//

import UIKit
import os.log


// Logger configuration.
let logGeneral = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "general")
let logTabOverview = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "tab-overview")
let logTabTypes = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "tab-types")
let logTabTypeDetail = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "tab-type-details")
let logUi = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "ui")
let logSettings = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "settings")


// Global type look up table.
struct TypesLookup {
    static var audio:     [String] = ["public.audio",
                                      "public.mp3",
                                      "public.mpeg-4-audio",
                                      "com.apple.protected-​mpeg-4-audio",
                                      "public.ulaw-audio",
                                      "public.aifc-audio",
                                      "public.aiff-audio",
                                      "com.apple.coreaudio-​format",
                                      "com.microsoft.waveform-​audio",
                                      "com.real.realaudio",
                                      "org.xiph.flac",
                                      "public.m3u-playlist",
                                      "com.apple.m4a-audio",
                                      "com.apple.protected-mpeg-4-audio"]
    static var videos:    [String] = ["public.movie",
                                      "public.video",
                                      "com.apple.quicktime-movie",
                                      "public.avi",
                                      "public.mpeg",
                                      "public.mpeg-4",
                                      "public.3gpp",
                                      "public.3gpp2",
                                      "com.microsoft.advanced-​systems-format",
                                      "com.real.realmedia",
                                      "org.matroska.mkv",
                                      "org.videolan.sub"]
    static var documents: [String] = ["public.message",
                                      "public.presentation",
                                      "public.contact",
                                      "com.apple.ical.ics",
                                      "public.calendar-event",
                                      "public.plain-text",
                                      "public.rtf",
                                      "public.vcard",
                                      "com.apple.rtfd",
                                      "com.apple.flat-rtfd",
                                      "com.adobe.pdf",
                                      "com.adobe.postscript",
                                      "com.adobe.encapsulated-​postscript",
                                      "com.microsoft.word.doc",
                                      "com.microsoft.excel.xls",
                                      "com.microsoft.powerpoint.​ppt",
                                      "com.apple.keynote.key",
                                      "com.apple.keynote.kth",
                                      "net.daringfireball.markdown",
                                      "public.log",
                                      "org.openxmlformats.presentationml.presentation",
                                      "org.openxmlformats.spreadsheetml.sheet.macroenabled",
                                      "org.openxmlformats.spreadsheetml.sheet",
                                      "org.openxmlformats.wordprocessingml.document",
                                      "org.idpf.epub-container"]
    static var images:    [String] = ["public.image",
                                      "public.fax",
                                      "public.jpeg",
                                      "public.jpeg-2000",
                                      "public.tiff",
                                      "public.camera-raw-image",
                                      "com.apple.pict",
                                      "com.apple.macpaint-image",
                                      "public.png",
                                      "public.xbitmap-image",
                                      "com.apple.quicktime-image",
                                      "com.apple.icns",
                                      "com.adobe.photoshop-image",
                                      "com.adobe.illustrator.ai-​image",
                                      "com.compuserve.gif",
                                      "com.microsoft.bmp",
                                      "com.microsoft.ico",
                                      "com.truevision.tga-image",
                                      "com.ilm.openexr-image",
                                      "com.kodak.flashpix.image",
                                      "com.bohemiancoding.sketch.drawing",
                                      "public.svg-image"]
    static var code:      [String] = ["public.html",
                                      "public.css",
                                      "public.xml",
                                      "public.json",
                                      "public.comma-separated-values-text",
                                      "com.textasticapp.textastic.batch-file",
                                      "public.source-code",
                                      "public.script",
                                      "com.netscape.javascript-​source",
                                      "public.shell-script",
                                      "public.perl-script",
                                      "public.python-script",
                                      "public.ruby-script",
                                      "public.php-script",
                                      "com.apple.applescript.text",
                                      "com.apple.applescript.script",
                                      "public.c-header",
                                      "public.c-source",
                                      "public.objective-c-source",
                                      "public.swift-source",
                                      "com.apple.xcode.project",
                                      "com.apple.property-list",
                                      "com.apple.framework",
                                      "com.apple.dt.document.workspace",
                                      "com.apple.interfacebuilder.document.cocoa",
                                      "com.apple.dt.interfacebuilder.document.storyboard",
                                      "com.netscape.javascript-source"]
    static var archives:  [String] = ["public.archive",
                                      "org.gnu.gnu-tar-archive",
                                      "public.tar-archive",
                                      "org.gnu.gnu-zip-archive",
                                      "org.gnu.gnu-zip-tar-archive",
                                      "com.apple.binhex-archive",
                                      "com.apple.macbinary-​archive",
                                      "com.pkware.zip-archive",
                                      "com.allume.stuffit-archive",
                                      "org.7-zip.7-zip-archive",
                                      "public.zip-archive",
                                      "public.bzip2-archive",
                                      "public.iso-image",
                                      "public.disk-image",
                                      "com.apple.disk-image"]
    static var other:     [String] = ["public.folder",
                                      "public.data",
                                      "public.executable",
                                      "com.microsoft.windows-executable",
                                      "com.microsoft.windows-​dynamic-link-library",
                                      "public.url",
                                      "com.apple.web-internet-location",
                                      "com.microsoft.internet-shortcut",
                                      "com.apple.application",
                                      "public.font",
                                      "public.opentype-font",
                                      "public.truetype-ttf-font"]
}


// Global application state object.
struct AppState {
    static var localFilesNumber: Int64 = 0
    static var localFoldersNumber: Int64 = 0
    static var localSizeBytes: Int64 = 0
    static var localSizeDiskBytes: Int64 = 0
    
    static var trashFilesNumber: Int64 = 0
    static var trashFoldersNumber: Int64 = 0
    static var trashSizeBytes: Int64 = 0
    static var trashSizeDiskBytes: Int64 = 0
    
    static var types: [TypeInfo] = [TypeInfo(name: "Audio", color: UIColor(named: "ColorTypeAudio")!, size: 0, number: 0, paths: [], sizes: []),
                                    TypeInfo(name: "Videos", color: UIColor(named: "ColorTypeVideos")!, size: 0, number: 0, paths: [], sizes: []),
                                    TypeInfo(name: "Documents", color: UIColor(named: "ColorTypeDocuments")!, size: 0, number: 0, paths: [], sizes: []),
                                    TypeInfo(name: "Images", color: UIColor(named: "ColorTypeImages")!, size: 0, number: 0, paths: [], sizes: []),
                                    TypeInfo(name: "Code", color: UIColor(named: "ColorTypeCode")!, size: 0, number: 0, paths: [], sizes: []),
                                    TypeInfo(name: "Archives", color: UIColor(named: "ColorTypeArchives")!, size: 0, number: 0, paths: [], sizes: []),
                                    TypeInfo(name: "Other", color: UIColor(named: "ColorTypeOther")!, size: 0, number: 0, paths: [], sizes: [])]
    
    static var documentsPath: String = ""
    static var updateInProgress: Bool = false
    static var demoContent: Bool = false  // NEVER set this to <true> when doing a release!
    
    static var openUrlQuery: String! = ""
    static var openUrlScheme: String! = ""
}


struct TypeInfo {
    var name: String
    var color: UIColor
    var size: Int64
    var number: Int
    var paths: [String]
    var sizes: [Int64]
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let userDefaults = UserDefaults.standard

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Note concerning images and custom fonts on LaunchScreen:
        // These things might not show up correctly when newly added. They are somehow cached in the device between runs even though a new build is triggered and/or the app is uninstalled/reinstalled. The only thing that helps is rebooting or running a (fresh) emulator.
        
        os_log("didFinishLaunchingWithOptions", log: logGeneral, type: .debug)
        
        ensureUserDefaults()
        AppState.documentsPath = FileManager.documentsDir()
        getStats()
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        // This is needed to allow for "deep linking" from the zip/unzip action extensions.
        // http://blog.originate.com/blog/2014/04/22/deeplinking-in-ios/
        
        // Nothing else may be called in here. Otherwise the app closes again right away.
        
        AppState.openUrlQuery = url.query
        AppState.openUrlScheme = url.scheme
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        os_log("applicationWillResignActive", log: logGeneral, type: .debug)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        // Example: Home button pressed.
        os_log("applicationDidEnterBackground", log: logGeneral, type: .debug)
        resetStats()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        // This will however not execute on initial launch.
        // Example: Re-launched from home screen after just previously hidden by pressing home button.
        os_log("applicationWillEnterForeground", log: logGeneral, type: .debug)
        getStats()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        os_log("applicationDidBecomeActive", log: logGeneral, type: .debug)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        os_log("applicationWillTerminate", log: logGeneral, type: .debug)
    }

}

