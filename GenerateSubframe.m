function [signal RBs] = GenerateSubframe(SYSTEM, cellID, subframeID)

TxNum = SYSTEM.TxNum;
DLRBnum = SYSTEM.totalRB;
cellID = SYSTEM.cellID;
prsRBnum = SYSTEM.totalRB_PRS;

[ PRS, PRSSC, PRSOFDMnumber] = GeneratePRS(cellID, subframeID, TXnum, DLRBnum, prsRBnum );
[ CRS, CRSSC, CRSOFDMnumber ] = GenerateCRS(cellID, subframeID, TXnum, DLRBnum );

end