enum Kind {
    case ranged
    case melee
    case initiative
    
}

struct Macro {
    let name: String
    let kind: Kind
    let label: String
    
    init(_ name: String, kind: Kind, label: String = "") {
        self.name = name
        self.kind = kind
        self.label = label
    }
    
    var location: String {
        """
        --?? $LOC == 1 OR $LOC == 2 ?? Damage:| [^DAM] in the Right Leg
        --?? $LOC == 3 OR $LOC == 4 ?? Damage:| [^DAM] in the Left Leg
        --?? $LOC == 11 OR $LOC == 12 ?? Damage:| [^DAM] in the Right Arm
        --?? $LOC == 13 OR $LOC == 14 ?? Damage:| [^DAM] in the Left Leg
        --?? $LOC >= 15 AND $LOC <= 19 ?? Damage:| [^DAM] in the Upper Guts
        --?? $LOC >= 5 AND $LOC <= 9 ?? Damage:| [^DAM] in the Lower Guts
        --?? $LOC == 10 ?? Damage:| [^DAM] + [^GIZ] in the Gizzards
        --?? $LOC == 20 ?? Damage:| [^DAM] + [^HEAD] in the Head
        """
    }
    
    var left: String {
        switch kind {
            case .melee: return "Fightin"
            case .ranged: return "Shootin"
            case .initiative: return "@{quilvl}"
        }
    }
    
    var right: String {
        switch kind {
            case .melee: return label
            case .ranged: return label
            case .initiative: return "@{quidtype}"
        }
    }

    var body: String {
        switch kind {
            case .initiative:
                let ranges: [(String,String)] = [
                    ("== 1", "A solitary one."),
                    ("== 2", "An unremarkable two."),
                    ("== 3", "An exiting three."),
                    ("== 4", "An implausible four."),
                    ("> 4", "A truly astonishing five.")
                ]

                var text = ""
                for (test, label) in ranges {
                    text += "--?? $INIT \(test) ?? Cards:| \(label)\n"
                }
                return text
                
            default:
                return ""
        }
    }
    
    var rolls: String {
        switch kind {
            case .melee:
                return "loc: [[ [$LOC] 1d20 + 2 ]] str: [[ [$STR] 3d8!!k1 + ?{Damage Mod|0} ]] + wep: [[ [$WEP] 2d8!! ]] head: [[ [$HEAD] 2d8!! ]] giz: [[ [$GIZ] 1d8!! ]]"

            case .ranged:
                return "loc: [[ [$LOC] 1d20 ]] dam: [[ [$DAM] 4d8!!+2 ]] head: [[ [$HEAD] 2d8!! ]] giz: [[ [$GIZ] 1d8!! ]]"

            case .initiative:
                return "[[ [$INIT] 1 + floor( ( @{quilvl}@{quidtype}!!k1+?{Modifier|0} ) / 5 ) ]]"
        }
    }
    
    var macro: String {
        """
        !power {{
        --name | @{nickname}
        --leftsub | \(left)
        --rightsub | \(right)
        \(body)
        \(location)
        --~~~
        --Rolls: |  \(rolls)
        }}
        """
    }
}

let macros = [
//    Macro("bowie", kind: .melee),
//    Macro("brawlin", kind: .melee),
//    Macro("cutlass", kind: .melee),
    Macro("initiative", kind: .initiative),
//    Macro("winchester", kind: .ranged),
]

for macro in macros {
    print("\n\n\(macro.name).roll20:\n")
    print(macro.macro)
}
