/*
@author: Atif Hassan
@description: This trigger handles insertion of opportunity in junction object so that, that opportunity could 
              be shown on parent Account's indirect opportunity (loan) related list as well.
@creation date: 3rd December 2015
@modification date: 
*/

trigger OpportunityInsertTrg on Opportunity (after insert)  
{ 
	List<Id> listOpp = new List<Id>();
	List<Id> listAcct = new List<Id>();

	Id oppId;

	for (Opportunity opp : Trigger.New)
	{
		listOpp.add(opp.Id);
		oppId = opp.Id;
		listAcct.add(opp.AccountId);
	}

	List<Account> listPAcct = [select ParentId from Account where Id = :listAcct];

	Indirect_Opportunity__c indOpp = new Indirect_Opportunity__c(Account__c=listPAcct[0].ParentId, Opportunity__c=oppId);

	insert indOpp;
	
}