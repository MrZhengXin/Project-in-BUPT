update tbCell
set PSS = PCI % 3


update tbCell

set PCI = 3*SSS+PSS


update tbHandOver

set HOSUCCRATE = case
			when HOATT is not null and HOSUCC is not null and HOATT>0 
			then HOSUCC/HOATT
			else null
		end
