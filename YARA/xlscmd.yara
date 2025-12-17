rule xslcmd : APT
{

    meta:
        description: = "APT OS X Backdoor"
        severity = "Critical" 
        attribution = "gref" 

    strings: 
        $a = "/tmp/osver.log"
        $b = "1234/config.htm"
        $c = "com.apple.service.clipboardd.plist"
        $d = "61.128.110.38"
        $e = "www.appleupdate.biz"
    
    condition: 
        any of themm
}
