public class AccountHelper 
{ 
    public void handleAccountUpdate(List<Account> pOldListAcct, List<Account> pNewListAcct)
	{
			if ((pOldListAcct[0].ParentId == null && pNewListAcct[0].ParentId != null) ||
				(pOldListAcct[0].ParentId != null && pNewListAcct[0].ParentId == null) ||
				((pOldListAcct[0].ParentId != null && pNewListAcct[0].ParentId != null) && (pOldListAcct[0].ParentId != pNewListAcct[0].ParentId)))
			{
        
				List<Indirect_Opportunity__c> listIndOpp = new List<Indirect_Opportunity__c>();
				List<Opportunity> listOpp;

				if (pOldListAcct[0].ParentId == null && pNewListAcct[0].ParentId != null)
				{
					listOpp = [select Id, AccountId, Account.ParentId from Opportunity where AccountId = :pNewListAcct[0].Id];
            
					for (Opportunity opp : listOpp)
					{
						Indirect_Opportunity__c indOpp = new Indirect_Opportunity__c();
						indOpp.Opportunity__c = opp.Id;
						indOpp.Account__c = pNewListAcct[0].ParentId;       //opp.Account.ParentId;
                
						listIndOpp.add(indOpp); 
					}
            
					insert listIndOpp;
					listIndOpp.clear();
				}
        
				/*
				if some account was parent now it's been removed as a parent, below code removes parent accounts relevant records
				from Indirect Opportunity object    
				*/
				if (pOldListAcct[0].ParentId != null && pNewListAcct[0].ParentId == null)
				{
					listOpp = [select Id from Opportunity where AccountId = :pOldListAcct[0].Id];

					listIndOpp = [select Id from Indirect_Opportunity__c 
								  where Account__c = :pOldListAcct[0].ParentId
								  and Opportunity__c = :listOpp];

					delete listIndOpp;
					listIndOpp.clear();
				}

				/* 
				if old parent was not null, new parent is assigned then remove old records and insert new entries in 
				Indirect Opportunity Object
				*/
				if ((pOldListAcct[0].ParentId != null && pNewListAcct[0].ParentId != null) && (pOldListAcct[0].ParentId != pNewListAcct[0].ParentId))
				{
					listOpp = [select Id from Opportunity where AccountId = :pOldListAcct[0].Id];

					listIndOpp = [select Id from Indirect_Opportunity__c 
								  where Account__c = :pOldListAcct[0].ParentId
								  and Opportunity__c = :listOpp];

					delete listIndOpp;
					listIndOpp.clear();
            
					listOpp = [select Id, AccountId from Opportunity where AccountId = :pNewListAcct[0].Id];
            
					for (Opportunity opp : listOpp)
					{
						Indirect_Opportunity__c indOpp = new Indirect_Opportunity__c();
						indOpp.Opportunity__c = opp.Id;
						indOpp.Account__c = pNewListAcct[0].ParentId;       //opp.Account.ParentId;
                
						listIndOpp.add(indOpp); 
					}
            
					insert listIndOpp;      
					listIndOpp.clear();                
				}
			}	    
	}
}