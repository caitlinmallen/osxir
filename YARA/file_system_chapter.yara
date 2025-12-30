rule december_intrusion_malware : file_system_chapter
{
    meta: 
        description = "Malware seen in intrusion on mikes-macbook-pro"
        severity = "Critical"
        attribution = "unknown"
    strings: 
        $a = "/Resources/kd"
        $b = "/Resources/abc"
        $c = "security_update.app"
        $d = "security_update.zip"
        $e = "osx_patch"
    condition:
        any of them
}
