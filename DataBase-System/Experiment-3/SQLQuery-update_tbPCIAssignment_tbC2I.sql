update tbCell
set TOTLETILT = ELECTTILT + MECHTILT


update tbPCIAssignment
set PCI=PCI%3,
	SSS=PCI/3

update tbC2I
set WeightedC2I = PrC2I9*SampleCount