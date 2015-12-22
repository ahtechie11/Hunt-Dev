/*
@author: Atif Hassan
@description: This trigger handles if some other account is tagged on opportunity, then it removes parent of
              old account and inserts parent of newly tagged account in junction object.
@creation date: 3rd December 2015
@modification date: 
*/

trigger OpportunityUpdateTrg on Opportunity (after update)  
{ 
	if (Trigger.old[0].AccountId != Trigger.new[0].AccountId)
	{
		Account acct = [select ParentId from Account where Id = :Trigger.old[0].AccountId];

		Delete [select Id 
		        from Indirect_Opportunity__c 
				where Opportunity__c = :Trigger.old[0].Id
		        and Account__c = :acct.ParentId];

		Indirect_Opportunity__c indOpp = new Indirect_Opportunity__c(Account__c=acct.ParentId, Opportunity__c=Trigger.new[0].Id);

		insert indOpp;   
	}
}