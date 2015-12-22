/*
@author: Atif Hassan
@description: This trigger handles if some other account is set as a parent account, then it tags existing opportunities
              of child account as indirect opportunities to its parent account
@creation date: 8th December 2015
@modification date: 
*/
trigger AccountUpdateTrg on Account (after update)  
{ 
    AccountHelper acctHelper = new AccountHelper();
	acctHelper.handleAccountUpdate(Trigger.old, Trigger.new);
}