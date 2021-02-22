# Winchester 76e

!power {{
 --name | @{nickname}
 --leftsub | Shootin The Varmin
 --rightsub | Fancified Winchester 76
 --Attack: | [[ [$ATK] @{shootinlvl}@{quidtype}!!k1 +  1 + ?{Modifier|0} ]] vs 5
 --?? $ATK.ones >= 3 ?? Warning: |  Possible botch!
--?? $ATK < 5 ?? !Alert:| ~C ~~~***Missed. Want to use a chip?***~~~ ~C
 --Damage: |  [[ 4d8!!+2 ]] 
 --?? $ATK.total > 30 ?? Raises:| Five 
 --?? $ATK.total > 24 AND $ATK.total < 30 ??  Raises:| Four 
 --?? $ATK.total > 19 AND $ATK.total < 25 ??  Raises:| Three
 --?? $ATK.total > 14 AND $ATK.total < 20 ??  Raises:| Two
 --?? $ATK.total > 9 AND $ATK.total < 15 ??  Raises:| One
--~~~
-- Location: |  [[ [$LOC] 1d20 ]]
--?? $LOC == 1 OR $LOC == 2 ?? In The:| Right Leg
--?? $LOC == 3 OR $LOC == 4 ?? In The:| Left Leg
--?? $LOC == 11 OR $LOC == 12 ?? In The:| Right Arm
--?? $LOC == 13 OR $LOC == 14 ?? In The:| Left Leg
--?? $LOC >= 15 AND $LOC <= 19 ?? In The:| Upper Guts
--?? $LOC >= 5 AND $LOC <= 9 ?? In The:| Lower Guts
--?? $LOC == 10 ?? In The:| Gizzard
--?? $LOC == 20 ?? In The:| Head
 -- Head Damage: | [[2d8!!]]
 -- Gizzard Damage: | [[1d8!!]]
 --?? $ATK <= 4 ?? Misses: | [[1d6]] [[1d6]] [[1d6]] [[1d6]]
}}

# Initiative

!power {{
 --name | @{charname} Initiative
--leftsub | @{quilvl} 
--rightsub | @{quidtype}	
--Roll| [[ [$INIT] @{quilvl}@{quidtype}!!k1+?{Modifier|0} ]]
--?? $INIT.total > 19 ?? Cards:| Five 
--?? $INIT.total > 14 AND $INIT.total < 20 ??  Cards:| Four 
--?? $INIT.total > 9 AND $INIT.total < 15 ??  Cards:| Three
--?? $INIT.total > 4 AND $INIT.total < 10 ??  Cards:| Two
--?? $INIT.total > 1 AND $INIT.total < 5 ??  Cards:| One

--?? $INIT.ones >= 3 ?? Warning: | Possible  botch!
}}

# Cutlass

(line 1)

!power {{
 --name | @{nickname}
 --leftsub | Fightin
 --rightsub | Cutlass
 --attack: | [[ [$ATK] @{repeating_fightin_$1_fightinlvl}@{nimdtype}!!k1 + 0 + ?{Hit Modifier|0} ]] vs ?{Level|5}

 --?? $ATK.ones >= 3 ?? Warning: |  Possible botch!
 --?? $ATK < ?{Level} ?? !Alert:| ~C ~~~***Missed. Want to use a chip?***~~~ ~C
 --Str Damage: |   [[ 3d8!!k1 + ?{Damage Mod|0} ]]  
 --Weapon Damage: |   [[ 2d8!! ]]  
 --?? $ATK.total > 30 ?? Raises:| Five 
 --?? $ATK.total > 24 AND $ATK.total < 30 ??  Raises:| Four 
 --?? $ATK.total > 19 AND $ATK.total < 25 ??  Raises:| Three
 --?? $ATK.total > 14 AND $ATK.total < 20 ??  Raises:| Two
 --?? $ATK.total > 9 AND $ATK.total < 15 ??  Raises:| One
 --~~~
-- Location: |  [[ [$LOC] 1d20 ]]
--?? $LOC == 1 OR $LOC == 2 ?? In The:| Right Leg
--?? $LOC == 3 OR $LOC == 4 ?? In The:| Left Leg
--?? $LOC == 11 OR $LOC == 12 ?? In The:| Right Arm
--?? $LOC == 13 OR $LOC == 14 ?? In The:| Left Leg
--?? $LOC >= 15 AND $LOC <= 19 ?? In The:| Upper Guts
--?? $LOC >= 5 AND $LOC <= 9 ?? In The:| Lower Guts
--?? $LOC == 10 ?? In The:| Gizzard
--?? $LOC == 20 ?? In The:| Head
 -- Head Damage: | [[2d8!!]]
 -- Gizzard Damage: | [[1d8!!]]
}}

# Brawlin

(line 2)

!power {{
 --name | @{nickname}
 --leftsub | Brawlin
 --attack: | [[ [$ATK] 5d12!!k1 + ?{Modifier|0} ]] vs 5
--?? $ATK.ones >= 3 ?? Warning: |  Possible botch!
 --?? $ATK >= 5 ?? Damage: |  [[ 3d8!!k1 ]] 
 --?? $ATK.total > 30 ?? Raises:| Five 
 --?? $ATK.total > 24 AND $ATK.total < 30 ??  Raises:| Four 
 --?? $ATK.total > 19 AND $ATK.total < 25 ??  Raises:| Three
 --?? $ATK.total > 14 AND $ATK.total < 20 ??  Raises:| Two
 --?? $ATK.total > 9 AND $ATK.total < 15 ??  Raises:| One
 --~~~
 --?? $ATK >= 5 ?? Location: |  [[ 1d20+2 ]]
 -- Head Damage: | [[2d6!!]]
 -- Gizzard Damage: | [[1d6!!]]
--Special: |  Wind damage. Make vigour check and take delta in damage
}}


# Bowie Knife

(line 0)

!power {{
 --name | @{nickname}
 --leftsub | Fightin
 --rightsub | Bowie Knife
 --attack: | [[ [$ATK] 5d12!!k1 + 0 + ?{Modifier|0} ]] vs 5
 --?? $ATK.ones >= 3 ?? Warning: |  Possible botch!
 --?? $ATK < 5 ?? !Alert:| ~C ~~~***Missed. Want to use a chip?***~~~ ~C
 --Str Damage: |   [[ 3d8!!k1 + ?{Damage Mod} ]]  
 --Weapon Damage: |   [[ 1d6!! ]]  
 --?? $ATK.total > 30 ?? Raises:| Five 
 --?? $ATK.total > 24 AND $ATK.total < 30 ??  Raises:| Four 
 --?? $ATK.total > 19 AND $ATK.total < 25 ??  Raises:| Three
 --?? $ATK.total > 14 AND $ATK.total < 20 ??  Raises:| Two
 --?? $ATK.total > 9 AND $ATK.total < 15 ??  Raises:| One
 --~~~
-- Location: |  [[ [$LOC] 1d20 ]]
--?? $LOC == 1 OR $LOC == 2 ?? In The:| Right Leg
--?? $LOC == 3 OR $LOC == 4 ?? In The:| Left Leg
--?? $LOC == 11 OR $LOC == 12 ?? In The:| Right Arm
--?? $LOC == 13 OR $LOC == 14 ?? In The:| Left Leg
--?? $LOC >= 15 AND $LOC <= 19 ?? In The:| Upper Guts
--?? $LOC >= 5 AND $LOC <= 9 ?? In The:| Lower Guts
--?? $LOC == 10 ?? In The:| Gizzard
--?? $LOC == 20 ?? In The:| Head
 -- Head Damage: | [[2d8!!]]
 -- Gizzard Damage: | [[1d8!!]]
}}