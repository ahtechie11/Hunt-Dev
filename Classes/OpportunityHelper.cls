public class OpportunityHelper 
{ 
	public void handleOpportunityInsert(List<Opportunity> pListOpp)
	{
		List<Id> listOpp = new List<Id>();
		List<Id> listAcct = new List<Id>();

		Id oppId;

		for (Opportunity opp : pListOpp)
		{
			listOpp.add(opp.Id);
			oppId = opp.Id;
			listAcct.add(opp.AccountId);
		}

		List<Account> listPAcct = [select ParentId from Account where Id = :listAcct];
		System.debug('account list size ' + listPAcct.size());

		if (listPAcct.size()> 0)
		{
			if (listPAcct[0].ParentId != null)
			{
				Indirect_Opportunity__c indOpp = new Indirect_Opportunity__c(Account__c=listPAcct[0].ParentId, Opportunity__c=oppId);
				insert indOpp;
			}
		}
	}

	public void handleOpportunityUpdate(List<Opportunity> pOldListOpp, List<Opportunity> pNewListOpp)
	{
		if (pOldListOpp[0].AccountId != pNewListOpp[0].AccountId)
		{
			if (pOldListOpp[0].AccountId != null)
			{
				Account oldAcctParent = [select ParentId from Account where Id = :pOldListOpp[0].AccountId];

				if (oldAcctParent.ParentId != null)
				{
					Delete [select Id 
							from Indirect_Opportunity__c 
							where Opportunity__c = :pOldListOpp[0].Id
							and Account__c = :oldAcctParent.ParentId];
				}

			}

			if (pNewListOpp[0].AccountId !=null)
			{
				Account newAcctParent = [select ParentId from Account where Id = :pNewListOpp[0].AccountId];

				if (newAcctParent.ParentId != null)
				{
					Indirect_Opportunity__c indOpp = new Indirect_Opportunity__c(Account__c=newAcctParent.ParentId, Opportunity__c=pNewListOpp[0].Id);
					insert indOpp;
				}
			}  
		}
	}
}